--- At the start, we are provided with two very important arguments that should be used in the file.
local args = ...
--- This is the full path to the texture file for the combo. Use this in the `Font=` attribute in your BitmapText to properly load your combo font.
local texPath = args.TexPath
--- We're going to use this local as a controller for the combo. It's not necessary, but its used here so it's more familiar with the implementation on the _fallback theme, in case
--- you want to explore that theme.
local c
-- Margin for when the combo should show up. We'll be grabbing the value assigned to the theme, but you can change it here with a number.
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")

-- These will be ranges for the number's zoom.
-- For now, these will grab the values that the theme assigns, but you can replace them with your own.
local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

-- Pulse function. Just a helper function to animate the small pulse when you hit a note.
local Pulse = function(self)
	local combo=self:GetZoom()
	-- Here we'll use the three variables to detemine the scale of the combo.
	local newZoom=scale(combo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom)
	self:zoom(1.2*newZoom):linear(0.05):zoom(newZoom)
end

local PulseLabel = function(self)
	local combo=self:GetZoom()
	-- Here we'll use the three variables to detemine the scale of the combo.
	local newZoom=scale(combo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom)
	self:zoom(1.2*newZoom):linear(0.05):zoom(newZoom)
end

local function findLast(haystack, needle)
    local i=haystack:match(".*"..needle.."()")
    if i==nil then return nil else return i-1 end
end

local folderLocation = string.sub( texPath, 0, findLast(texPath, "/") )
lua.ReportScriptError(texPath)

local t = Def.ActorFrame {
	InitCommand=function(self)
		self:vertalign(bottom)
	end,
	
	-- Since we're going to be using different kinds of textures, we're going to force the font in different ways.
	-- However, it's recommended that one of the fonts remains the name of the folder, so it's compatible with
	-- themes that may want to preview the combo.
	-- For reference: FPC is used for an ongoing Full Perfect Combo or Full Flawless Combo, FC for an ongoing Full Great Combo
	-- and Normal is for when a combo break has occured at least once.
	Def.BitmapText{
        File = folderLocation .. "FPC.ini",
		Name="NumberFPC",
		OnCommand = function(self)
            self:halign(1):vertalign(0):y(0)
        end,
	},

	Def.BitmapText{
        File = folderLocation .. "FC.ini",
		Name="NumberFC",
		OnCommand = function(self)
            self:halign(1):vertalign(0):y(0)
        end,
	},

	Def.BitmapText{
        File = texPath,
		Name="NumberRegular",
		OnCommand = function(self)
            self:halign(1):vertalign(0):y(0):zoom(2):strokecolor(Color.Black)
        end,
	},
	LoadActor("Label FPC") .. {
		Name="LabelFFC";
		OnCommand = function(self)
            self:shadowlength(4):vertalign(0)
        end,
	};
	LoadActor("Label FPC") .. {
		Name="LabelFPC";
		OnCommand = function(self)
            self:shadowlength(4):vertalign(0)
        end,
	};
	LoadActor("Label FC") .. {
		Name="LabelFC";
		OnCommand = function(self)
            self:shadowlength(4):vertalign(0)
        end,
	};
	LoadActor("Label Normal") .. {
		Name="Label";
		OnCommand = function(self)
            self:shadowlength(4):vertalign(0)
        end
	};

	InitCommand = function(self)
		c = self:GetChildren()
		c.NumberRegular:visible(false)
		c.NumberFC:visible(false)
	end,

	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo
		-- If the combo isn't positive (misses) or we haven't reached the threshold, then don't show it.
		if not iCombo or iCombo < ShowComboAt then
			c.NumberRegular:visible(false)
			c.NumberFC:visible(false)
			c.NumberFPC:visible(false)
			c.LabelFFC:visible(false);
			c.LabelFPC:visible(false);
			c.LabelFC:visible(false);
			c.Label:visible(false);
			c.NumberRegular:x(30);
			c.NumberFC:x(30);
			c.NumberFPC:x(30);
			c.LabelFFC:y(10);
			c.LabelFPC:y(10);
			c.LabelFC:y(10);
			c.Label:y(10);
			c.LabelFFC:x(30);
			c.LabelFPC:x(30);
			c.LabelFC:x(30);
			c.Label:x(30);
			return
		end

		c.LabelFFC:visible(false);
		c.LabelFPC:visible(false);
		c.LabelFC:visible(false);
		c.Label:visible(false);

		-- Check for the player's current perk.
		if param.FullComboW1 then -- Full Fantastic Combo
			c.NumberFPC:visible(true)
			c.NumberFC:visible(false)
			c.NumberRegular:visible(false)
			c.LabelFFC:visible(true)
			c.LabelFPC:visible(false)
			c.LabelFC:visible(false)
			c.Label:visible(false)
		elseif param.FullComboW2 then -- Full Excellent Combo
			c.NumberFPC:visible(true)
			c.NumberFC:visible(false)
			c.NumberRegular:visible(false)
			c.LabelFFC:visible(false)
			c.LabelFPC:visible(true)
			c.LabelFC:visible(false)
			c.Label:visible(false)
		elseif param.FullComboW3 then -- Full Great Combo
			c.NumberFPC:visible(false)
			c.NumberFC:visible(true)
			c.NumberRegular:visible(false)
			c.LabelFFC:visible(false)
			c.LabelFPC:visible(false)
			c.LabelFC:visible(true)
			c.Label:visible(false)
		elseif param.Combo then -- Regular Combo
			c.NumberFPC:visible(false)
			c.NumberRegular:visible(true)
			c.NumberFC:visible(false)
			c.LabelFFC:visible(false)
			c.LabelFPC:visible(false)
			c.LabelFC:visible(false)
			c.Label:visible(true)
		else -- Misses
			c.NumberFPC:visible(false)
			c.NumberRegular:visible(false)
			c.NumberFC:visible(false)
			c.LabelFFC:visible(false)
			c.LabelFPC:visible(false)
			c.LabelFC:visible(false)
			c.Label:visible(false)
		end
		
		-- Draw the current combo to the number.
		c.NumberRegular:settext( string.format("%i", iCombo) ):finishtweening()
		c.NumberFC:settext( string.format("%i", iCombo) ):finishtweening()
		c.NumberFPC:settext( string.format("%i", iCombo) ):finishtweening()
		-- Variable doesn't exist in the code!
		--c.NumberFFC:settext( string.format("%i", iCombo) ):finishtweening()
		c.Label:finishtweening()
		c.LabelFC:finishtweening()
		c.LabelFPC:finishtweening()
		c.LabelFFC:finishtweening()
		-- Now call the pulse function from above.
		Pulse( c.NumberRegular )
		Pulse( c.NumberFC )
		Pulse( c.NumberFPC )
		-- Variable doesn't exist in the code!
		--Pulse( c.NumberFFC )
		PulseLabel( c.Label )
		PulseLabel( c.LabelFC )
		PulseLabel( c.LabelFPC )
		-- Variable doesn't exist in the code!
		--PulseLabel( c.LabelFFC )
	end
}

return t
