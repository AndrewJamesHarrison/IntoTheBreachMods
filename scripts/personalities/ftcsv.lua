local ftcsv = {
    _VERSION = 'ftcsv 1.1.0',
    _DESCRIPTION = 'CSV library for Lua',
    _URL         = 'https://github.com/FourierTransformer/ftcsv',
    _LICENSE     = [[
        The MIT License (MIT)

        Copyright (c) 2016 Shakil Thakur

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

-- lua 5.1 load compat
local M = {}
if type(jit) == 'table' or _ENV then
    M.load = _G.load
else
    M.load = loadstring
end

-- perf
local sbyte = string.byte
local ssub = string.sub

-- luajit specific speedups
-- luajit performs faster with iterating over string.byte,
-- whereas vanilla lua performs faster with string.find
if type(jit) == 'table' then
    -- finds the end of an escape sequence
    function M.findClosingQuote(i, inputLength, inputString, quote, doubleQuoteEscape)
        -- local doubleQuoteEscape = doubleQuoteEscape
        local currentChar, nextChar = sbyte(inputString, i), nil
        while i <= inputLength do
            -- print(i)
            nextChar = sbyte(inputString, i+1)

            -- this one deals with " double quotes that are escaped "" within single quotes "
            -- these should be turned into a single quote at the end of the field
            if currentChar == quote and nextChar == quote then
                doubleQuoteEscape = true
                i = i + 2
                currentChar = sbyte(inputString, i)

            -- identifies the escape toggle
            elseif currentChar == quote and nextChar ~= quote then
                -- print("exiting", i-1)
                return i-1, doubleQuoteEscape
            else
                i = i + 1
                currentChar = nextChar
            end
        end
    end

else
    -- vanilla lua closing quote finder
    function M.findClosingQuote(i, inputLength, inputString, quote, doubleQuoteEscape)
        local firstCharIndex = 1
        local firstChar, iChar = nil, nil
        repeat
            firstCharIndex, i = inputString:find('".?', i+1)
            firstChar = sbyte(inputString, firstCharIndex)
            iChar = sbyte(inputString, i)
            -- nextChar = string.byte(inputString, i+1)
            -- print("HI", offset, i)
            -- print(firstChar, iChar)
            if firstChar == quote and iChar == quote then
                doubleQuoteEscape = true
            end
        until iChar ~= quote
        if i == nil then
            return inputLength-1, doubleQuoteEscape
        end
        -- print("exiting", i-2)
        return i-2, doubleQuoteEscape
    end

end

-- load an entire file into memory
local function loadFile(textFile)
    local file = io.open(textFile, "r")
    if not file then error("File not found at " .. textFile) end
    local allLines = file:read("*all")
    file:close()
    return allLines
end

-- creates a new field and adds it to the main table
local function createField(inputString, quote, fieldStart, i, doubleQuoteEscape)
    local field
    -- so, if we just recently de-escaped, we don't want the trailing \"
    if sbyte(inputString, i-1) == quote then
        -- print("Skipping last \"")
        field = ssub(inputString, fieldStart, i-2)
    else
        field = ssub(inputString, fieldStart, i-1)
    end
    if doubleQuoteEscape then
        -- print("QUOTE REPLACE")
        -- print(line[fieldNum])
        field = field:gsub('""', '"')
    end
    return field
end

-- main function used to parse
local function parseString(inputString, inputLength, delimiter, i, headerField, fieldsToKeep)

    -- keep track of my chars!
    local currentChar, nextChar = sbyte(inputString, i), nil
    local skipChar = 0
    local field
    local fieldStart = i
    local fieldNum = 1
    local lineNum = 1
    local doubleQuoteEscape = false
    local exit = false

    --bytes
    local CR = sbyte("\r")
    local LF = sbyte("\n")
    local quote = sbyte('"')
    local delimiterByte = sbyte(delimiter)

    local assignValue
    local outResults
    -- the headers haven't been set yet.
    -- aka this is the first run!
    if headerField == nil then
        -- print("this is for headers")
        headerField = {}
        assignValue = function()
            headerField[fieldNum] = field
            return true
        end
    else
        -- print("this is for magic")
        outResults = {}
        outResults[1] = {}
        assignValue = function()
            outResults[lineNum][headerField[fieldNum]] = field
        end
    end

    while i <= inputLength do
        -- go by two chars at a time! currentChar is set at the bottom.
        -- currentChar = string.byte(inputString, i)
        nextChar = sbyte(inputString, i+1)
        -- print(i, string.char(currentChar), string.char(nextChar))

        -- empty string
        if currentChar == quote and nextChar == quote then
            -- print("EMPTY STRING")
            skipChar = 1
            fieldStart = i + 2
            -- print("fs+2:", fieldStart)

        -- identifies the escape toggle
        elseif currentChar == quote and nextChar ~= quote then
            -- print("ESCAPE TOGGLE")
            fieldStart = i + 1
            i, doubleQuoteEscape = M.findClosingQuote(i+1, inputLength, inputString, quote, doubleQuoteEscape)
            -- print("I VALUE", i, doubleQuoteEscape)
            skipChar = 1

        -- create some fields if we can!
        elseif currentChar == delimiterByte then
            -- create the new field
            -- print(headerField[fieldNum])
            if fieldsToKeep == nil or fieldsToKeep[headerField[fieldNum]] then
                field = createField(inputString, quote, fieldStart, i, doubleQuoteEscape)
            -- print("FIELD", field, "FIELDEND", headerField[fieldNum], lineNum)
            -- outResults[headerField[fieldNum]][lineNum] = field
                assignValue()
            end
            doubleQuoteEscape = false

            fieldNum = fieldNum + 1
            fieldStart = i + 1
            -- print("fs+1:", fieldStart)
        -- end

        -- newline?!
        elseif ((currentChar == CR and nextChar == LF) or currentChar == LF) then
            if fieldsToKeep == nil or fieldsToKeep[headerField[fieldNum]] then
                -- create the new field
                field = createField(inputString, quote, fieldStart, i, doubleQuoteEscape)

                -- outResults[headerField[fieldNum]][lineNum] = field
                exit = assignValue()
                if exit then
                    if (currentChar == CR and nextChar == LF) then
                        return headerField, i + 1
                    else
                        return headerField, i
                    end
                end
            end
            doubleQuoteEscape = false

            -- determine how line ends
            if (currentChar == CR and nextChar == LF) then
                -- print("CRLF DETECTED")
                skipChar = 1
                fieldStart = fieldStart + 1
                -- print("fs:", fieldStart)
            end

            -- incrememnt for new line
            lineNum = lineNum + 1
            outResults[lineNum] = {}
            fieldNum = 1
            fieldStart = i + 1 + skipChar
            -- print("fs:", fieldStart)

        end

        i = i + 1 + skipChar
        if (skipChar > 0) then
            currentChar = sbyte(inputString, i)
        else
            currentChar = nextChar
        end
        skipChar = 0
    end

    -- create last new field
    if fieldsToKeep == nil or fieldsToKeep[headerField[fieldNum]] then
        field = createField(inputString, quote, fieldStart, i, doubleQuoteEscape)
        assignValue()
    end

    -- clean up last line if it's weird (this happens when there is a CRLF newline at end of file)
    -- doing a count gets it to pick up the oddballs
    local finalLineCount = 0
    for _, _ in pairs(outResults[lineNum]) do
        finalLineCount = finalLineCount + 1
    end
    local initialLineCount = 0
    for _, _ in pairs(outResults[1]) do
        initialLineCount = initialLineCount + 1
    end
    -- print("Final/Initial", finalLineCount, initialLineCount)
    if finalLineCount ~= initialLineCount then
        outResults[lineNum] = nil
    end

    return outResults
end

-- runs the show!
function ftcsv.parse(inputFile, delimiter, options)
    -- delimiter MUST be one character
    assert(#delimiter == 1 and type(delimiter) == "string", "the delimiter must be of string type and exactly one character")

    -- OPTIONS yo
    local header = true
    local rename
    local fieldsToKeep = nil
    local loadFromString = false
    local headerFunc
    if options then
        if options.headers ~= nil then
            assert(type(options.headers) == "boolean", "ftcsv only takes the boolean 'true' or 'false' for the optional parameter 'headers' (default 'true'). You passed in '" .. tostring(options.headers) .. "' of type '" .. type(options.headers) .. "'.")
            header = options.headers
        end
        if options.rename ~= nil then
            assert(type(options.rename) == "table", "ftcsv only takes in a key-value table for the optional parameter 'rename'. You passed in '" .. tostring(options.rename) .. "' of type '" .. type(options.rename) .. "'.")
            rename = options.rename
        end
        if options.fieldsToKeep ~= nil then
            assert(type(options.fieldsToKeep) == "table", "ftcsv only takes in a list (as a table) for the optional parameter 'fieldsToKeep'. You passed in '" .. tostring(options.fieldsToKeep) .. "' of type '" .. type(options.fieldsToKeep) .. "'.")
            local ofieldsToKeep = options.fieldsToKeep
            if ofieldsToKeep ~= nil then
                fieldsToKeep = {}
                for j = 1, #ofieldsToKeep do
                    fieldsToKeep[ofieldsToKeep[j]] = true
                end
            end
            if header == false then
                assert(next(rename) ~= nil, "ftcsv can only have fieldsToKeep for header-less files when they have been renamed. Please add the 'rename' option and try again.")
            end
        end
        if options.loadFromString ~= nil then
            assert(type(options.loadFromString) == "boolean", "ftcsv only takes a boolean value for optional parameter 'loadFromString'. You passed in '" .. tostring(options.loadFromString) .. "' of type '" .. type(options.loadFromString) .. "'.")
            loadFromString = options.loadFromString
        end
        if options.headerFunc ~= nil then
            assert(type(options.headerFunc) == "function", "ftcsv only takes a function value for optional parameter 'headerFunc'. You passed in '" .. tostring(options.headerFunc) .. "' of type '" .. type(options.headerFunc) .. "'.")
            headerFunc = options.headerFunc
        end
    end

    -- handle input via string or file!
    local inputString
    if loadFromString then
        inputString = inputFile
    else
        inputString = loadFile(inputFile)
    end
    local inputLength = #inputString

    -- parse through the headers!
    local headerField, i = parseString(inputString, inputLength, delimiter, 0)
    i = i + 1 -- start at the next char

    -- for files where there aren't headers!
    if header == false then
        i = 0
        for j = 1, #headerField do
            headerField[j] = j
        end
    end

    -- rename fields as needed!
    if rename then
        -- basic rename (["a" = "apple"])
        for j = 1, #headerField do
            if rename[headerField[j]] then
                -- print("RENAMING", headerField[j], rename[headerField[j]])
                headerField[j] = rename[headerField[j]]
            end
        end
        -- files without headers, but with a rename need to be handled too!
        if #rename > 0 then
            for j = 1, #rename do
                headerField[j] = rename[j]
            end
        end
    end

    -- apply some sweet header manuipulation
    if headerFunc then
        for j = 1, #headerField do
            headerField[j] = headerFunc(headerField[j])
        end
    end

    local output = parseString(inputString, inputLength, delimiter, i, headerField, fieldsToKeep)
    return output
end

-- a function that delimits " to "", used by the writer
local function delimitField(field)
    field = tostring(field)
    if field:find('"') then
        return field:gsub('"', '""')
    else
        return field
    end
end

-- a function that compiles some lua code to quickly print out the csv
local function writer(inputTable, dilimeter, headers)
    -- they get re-created here if they need to be escaped so lua understands it based on how
    -- they came in
    for i = 1, #headers do
        if inputTable[1][headers[i]] == nil then
            error("the field '" .. headers[i] .. "' doesn't exist in the table")
        end
        if headers[i]:find('"') then
            headers[i] = headers[i]:gsub('"', '\\"')
        end
    end

    local outputFunc = [[
        local state, i = ...
        local d = state.delimitField
        i = i + 1;
        if i > state.tableSize then return nil end;
        return i, '"' .. d(state.t[i]["]] .. table.concat(headers, [["]) .. '"]] .. dilimeter .. [["' .. d(state.t[i]["]]) .. [["]) .. '"\r\n']]

    -- print(outputFunc)

    local state = {}
    state.t = inputTable
    state.tableSize = #inputTable
    state.delimitField = delimitField

    return M.load(outputFunc), state, 0

end

-- takes the values from the headers in the first row of the input table
local function extractHeaders(inputTable)
    local headers = {}
    for key, _ in pairs(inputTable[1]) do
        headers[#headers+1] = key
    end

    -- lets make the headers alphabetical
    table.sort(headers)

    return headers
end

-- turns a lua table into a csv
-- works really quickly with luajit-2.1, because table.concat life
function ftcsv.encode(inputTable, delimiter, options)
    local output = {}

    -- dilimeter MUST be one character
    assert(#delimiter == 1 and type(delimiter) == "string", "the delimiter must be of string type and exactly one character")

    -- grab the headers from the options if they are there
    local headers = nil
    if options then
        if options.fieldsToKeep ~= nil then
            assert(type(options.fieldsToKeep) == "table", "ftcsv only takes in a list (as a table) for the optional parameter 'fieldsToKeep'. You passed in '" .. tostring(options.headers) .. "' of type '" .. type(options.headers) .. "'.")
            headers = options.fieldsToKeep
        end
    end
    if headers == nil then
        headers = extractHeaders(inputTable)
    end

    -- newHeaders are needed if there are quotes within the header
    -- because they need to be escaped
    local newHeaders = {}
    for i = 1, #headers do
        if headers[i]:find('"') then
            newHeaders[i] = headers[i]:gsub('"', '""')
        else
            newHeaders[i] = headers[i]
        end
    end
    output[1] = '"' .. table.concat(newHeaders, '","') .. '"\r\n'

    -- add each line by line.
    for i, line in writer(inputTable, delimiter, headers) do
        output[i+1] = line
    end
    return table.concat(output)
end

return ftcsv

