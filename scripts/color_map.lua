
local TEST_COLORS = false

local color_maps = {
	
	--#0 - Archive (default )  - Olive
	{
		GL_Color(221, 141,140),
		GL_Color(136, 126, 68),
		GL_Color(63, 75, 50),
		GL_Color(29, 40, 31),
		GL_Color(15, 22, 16),
		GL_Color(34, 36, 34),
		GL_Color(67, 72, 68),
		GL_Color(134, 146, 120)
	},
	--#1  - Rust   -  Orange + darkbrown
	{
		GL_Color(91, 255, 125),
		GL_Color(203, 123, 53),
		GL_Color(150, 58, 28),
		GL_Color(73, 36, 28),
		GL_Color(32, 19, 16),
		GL_Color(28, 28, 29),
		GL_Color(58, 51, 42),
		GL_Color(104, 97, 89),
	},
	
	--#2 - Pinnacle   - DarkBlue/darkgrey
	{
		GL_Color(255, 87, 85),
		GL_Color(78, 121, 132),
		GL_Color(47, 64, 71),
		GL_Color(30, 35, 45),
		GL_Color(13, 17, 25),
		GL_Color(32, 28, 24),
		GL_Color(63, 59, 46),
		GL_Color(134, 125, 108),
	},
	--#3 - Detritus   -- Yellow + grey
	{
		GL_Color(90, 255, 249),
		GL_Color(255, 253, 157),
		GL_Color(126, 120, 73),
		GL_Color(72, 59, 43),
		GL_Color(23, 19, 16),
		GL_Color(29, 30, 35),
		GL_Color(76, 79, 90),
		GL_Color(144, 155, 158),
	},
	--#4- "Archive2"   -  SHIVAN?
	{
		GL_Color(255, 68, 86),
		GL_Color(70, 79, 68),
		GL_Color(34, 39, 37),
		GL_Color(20, 21, 22),
		GL_Color(10, 10, 11),
		GL_Color(38, 38, 38),
		GL_Color(81, 81, 81),
		GL_Color(127, 127, 127),
	},
	--#5 - "Rust2"  - red + tan
	{
		GL_Color(91, 211, 255),
		GL_Color(183, 84, 89),
		GL_Color(136, 35, 48),
		GL_Color(75, 29, 30),
		GL_Color(32, 16, 15),
		GL_Color(33, 34, 27),
		GL_Color(78, 70, 54),
		GL_Color(154, 140, 109),
	},
	--#6 - "Pinnacle2"   -  Lightblue + grey
	{
		GL_Color(255, 87, 85),
		GL_Color(198, 246, 250),
		GL_Color(125, 161, 165),
		GL_Color(73, 88, 98),
		GL_Color(24, 25, 33),
		GL_Color(46, 50, 57),
		GL_Color(85, 89, 93),
		GL_Color(126, 128, 126),
	},
	--#7 - "Detritus2"   - Tan + grey/green
	{
		GL_Color(255, 238, 90),
		GL_Color(187, 162, 129),
		GL_Color(107, 80, 69),
		GL_Color(70, 46, 47),
		GL_Color(23, 17, 17),
		GL_Color(29, 35, 32),
		GL_Color(76, 90, 82),
		GL_Color(107, 154, 102),
	},
	--#8 - "Vek Coloring"   - Purple + light grey
	{
		GL_Color(255, 197, 86),
		GL_Color(139, 121, 164),
		GL_Color(85, 88, 112),
		GL_Color(36, 41, 65),
		GL_Color(9, 22, 27),
		GL_Color(61, 64, 48),
		GL_Color(111, 125, 124),
		GL_Color(215, 255, 210),
	},
	--[[
	--#8was1 - No Corp  - Purply
	{
		GL_Color(72, 145, 255),
		GL_Color(179, 184, 194),
		GL_Color(87, 84, 92),
		GL_Color(37, 34, 41),
		GL_Color(16, 14, 14),
		GL_Color(25, 27, 25),
		GL_Color(58, 58, 54),
		GL_Color(102, 103, 93),
	},]]
}

function GetColorCount()
	return #color_maps
end

function GetColorMap(id)
	return color_maps[id]
end

function IsColorMapTest()
	return TEST_COLORS
end
