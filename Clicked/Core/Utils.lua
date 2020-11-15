local L = LibStub("AceLocale-3.0"):GetLocale("Clicked")

-- /run local a,b,c=table.concat,{},{};for d=1,GetNumShapeshiftForms() do local _,_,_,f=GetShapeshiftFormInfo(d);local e=GetSpellInfo(f);b[#b+1]=e;c[#c+1]=f;end print("{ "..a(c, ",").." }, --"..a(b,", "))
local shapeshiftForms = {
	-- Arms Warrior
	-- Fury Warrior
	-- Protection Warrior
	-- Initial Warrior
	[71] = {},
	[72] = {},
	[73] = {},
	[1446] = {},

	-- Holy Paladin
	-- Protection Paladin
	-- Retribution Paladin
	-- Initial Paladin
	[65] = { 32223, 465, 183435 }, -- Crusader Aura, Devotion Aura, Retribution Aura
	[66] = { 32223, 465, 183435 }, -- Crusader Aura, Devotion Aura, Retribution Aura
	[70] = { 32223, 465, 183435 }, -- Crusader Aura, Devotion Aura, Retribution Aura
	[1451] = { 32223, 465, 183435 }, -- Crusader Aura, Devotion Aura, Retribution Aura

	-- Beast Mastery Hunter
	-- Marksmanship Hunter
	-- Survival Hunter
	-- Initial Hunter
	[253] = {},
	[254] = {},
	[255] = {},
	[1448] = {},

	-- Assassination Rogue
	-- Outlaw Rogue
	-- Subtlety Rogue
	-- Initial Rogue
	[259] = { 1784 }, -- Stealth
	[260] = { 1784 }, -- Stealth
	[261] = { 1784 }, -- Stealth
	[1453] = { 1784 },  -- Stealth

	-- Discipline Priest
	-- Holy Priest
	-- Shadow Priest
	-- Initial Priest
	[256] = {},
	[257] = {},
	[258] = { 232698 }, -- Shadowform
	[1452] = {},

	-- Blood Death Knight
	-- Frost Death Knight
	-- Unholy Death Knight
	-- Initial Death Knight
	[250] = {},
	[251] = {},
	[252] = {},
	[1455] = {},

	-- Elemental Shaman
	-- Enhancement Shaman
	-- Restoration Shaman
	-- Initial Shaman
	[262] = {},
	[263] = {},
	[264] = {},
	[1444] = {},

	-- Arcane Mage
	-- Fire Mage
	-- Frost Mage
	-- Initial Mage
	[62] = {},
	[63] = {},
	[64] = {},
	[1449] = {},

	-- Afflication Warlock
	-- Demonology Warlock
	-- Destruction Warlock
	-- Initial Warlock
	[265] = {},
	[266] = {},
	[267] = {},
	[1454] = {},

	-- Brewmaster Monk
	-- Mistweaver Monk
	-- Windwalker Monk
	-- Initial Monk
	[268] = {},
	[270] = {},
	[269] = {},
	[1450] = {},

	-- Balance Druid
	-- Feral Druid
	-- Guardian Druid
	-- Restoration Druid
	-- Initial Druid
	[102] = { 5487, 768, 783, 24858, 114282, 210053 }, -- Bear Form, Cat Form, Travel Form, Moonkin Form, Treant Form, Mount Form
	[103] = { 5487, 768, 783, 197625, 114282, 210053 }, -- Bear Form, Cat Form, Travel Form, Moonkin Form, Treant Form, Mount Form
	[104] = { 5487, 768, 783, 197625, 114282, 210053 }, -- Bear Form, Cat Form, Travel Form, Moonkin Form, Treant Form, Mount Form
	[105] = { 5487, 768, 783, 197625, 114282, 210053 }, -- Bear Form, Cat Form, Travel Form, Moonkin Form, Treant Form, Mount Form
	[1447] = { 5487, 768, 783, 114282, 210053 }, -- Bear Form, Cat Form, Travel Form, Treant Form, Mount Form

	-- Havoc Demon Hunter
	-- Vengeance Demon Hunter
	-- Initial Demon Hunter
	[577] = {},
	[581] = {},
	[1456] = {}
}

--- Show a popup indicating Clicked is incompatible with the
--- specified addon. The popup will allow the user to disable
--- one of the two addons.
---
--- @param addon string
function Clicked:ShowAddonIncompatibilityPopup(addon)
	StaticPopupDialogs["ClickedAddonIncompatibilityMessage"] = {
		text = L["ERR_ADDON_INCOMPAT_MESSAGE"]:format(addon),
		button1 = L["ERR_ADDON_INCOMPAT_BUTTON_KEEP_X"]:format(L["ADDON_NAME"]),
		button2 = L["ERR_ADDON_INCOMPAT_BUTTON_KEEP_X"]:format(addon),
		OnAccept = function()
			DisableAddOn(addon)
			ReloadUI()
		end,
		OnCancel = function()
			DisableAddOn("Clicked")
			ReloadUI()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = false,
		preferredIndex = 3
	}

	StaticPopup_Show("ClickedAddonIncompatibilityMessage")
end

--- Show a generic information popup informing the user.
--- This allows the user acknowledge the message.
---
--- @param text string
function Clicked:ShowInformationPopup(text)
	StaticPopupDialogs["ClickedInformationMessage"] = {
		text = text,
		button1 = L["MSG_POPUP_BUTTON_CONTINUE"],
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	StaticPopup_Show("ClickedInformationMessage")
end

--- Show a confirmation popup to the user. This will show
--- a two button dialog box allowing the user to either accept
--- or decline. If the user accepts, the specified `func` is invoked
--- with all additional arguments passed to this function.
---
--- @param message string
--- @param func function
function Clicked:ShowConfirmationPopup(message, func, ...)
	StaticPopupDialogs["ClickedConfirmationMessage"] = {
		text = message,
		button1 = L["MSG_POPUP_BUTTON_YES"],
		button2 = L["MSG_POPUP_BUTTON_NO"],
		OnAccept = func,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	StaticPopup_Show("ClickedConfirmationMessage")
end

--- Create a deep copy of the specified table, this will
--- recursively copy the table ensuring all memory locations
--- are no longer pointing to the original.
---
--- @param original table
--- @return table
function Clicked:DeepCopyTable(original)
	if original == nil then
		return nil
	end

	local result = {}

	for k, v in pairs(original) do
		if type(v) == "table" then
			v = self:DeepCopyTable(v)
		end

		result[k] = v
	end

	return result
end

--- Retrieve a chunk of data from a formatted string.
--- Clicked uses custom string formats for many UI operations
--- which condense multiple datasets into a single string.
---
--- Those strings are formatted in the following structure:
--- `<keyword=value>`, for example `<text=Open Spellbook>`.
---
--- A string can contain multiple data chunks.
---
--- @param string string
--- @param keyword string
--- @return string
function Clicked:GetDataFromString(string, keyword)
	if self:IsStringNilOrEmpty(string) or self:IsStringNilOrEmpty(keyword) then
		return nil
	end

	local pattern = string.format("<%s=(.-)>", keyword)
	local match = string.match(string, pattern)

	return match
end

--- Generate an attribute identifier for a key. This will
--- separate the keybind into two parts: a prefix, and a suffix.
---
--- The prefix is always an empty string unless the key is a mouse
--- button _and_ the `hovercast` parameter has been set to `true`.
---
--- That will allow for the generation of proper frame attribute keys:
---
--- * `"BUTTON1"` == `"", "1"` == `"type1"`
--- * `"SHIFT-BUTTON1"` == `"shift", "1"` == `"shift-type1"`
--- * etc.
---
--- For any keys that are _not_ mouse buttons, or the `hovercast`
--- parameter has been set to `false`, a custom identifier will
--- be generated, generally prefixed by `clicked-mouse-` or
--- `clicked-button-` for mouse buttons and all other buttons respectively.
---
--- * `"T"` == `"", "clicked-button-t"` == `"type-clicked-button-t"`
--- * `"SHIFT-T"` == `"", "clicked-button-shiftt"` == `"type-clicked-button-shiftt"`
--- * `"BUTTON3"` == `"", "clicked-mouse-3"` == `"type-clicked-mouse-3"`
--- * `"SHIFT-BUTTON3"` == `"", "clicked-mouse-shift3"` == `"type-clicked-mouse-shift3"`
---
--- @param key string
--- @param hovercast boolean
--- @return string prefix
--- @return string suffix
function Clicked:CreateAttributeIdentifier(key, hovercast)
	-- separate modifiers from the actual binding
	local prefix, suffix = string.match(key, "^(.-)([^%-]+)$")
	local buttonIndex = string.match(suffix, "^BUTTON(%d+)$")

	-- remove any trailing dashes (shift- becomes shift, ctrl- becomes ctrl, etc.)
	if string.sub(prefix, -1, -1) == "-" then
		prefix = string.sub(prefix, 1, -2)
	end

	-- convert the parts to lowercase so it fits the attribute naming style
	prefix = prefix:lower()
	suffix = suffix:lower()

	if buttonIndex ~= nil and hovercast then
		suffix = buttonIndex
	elseif buttonIndex ~= nil then
		suffix = "clicked-mouse-" .. tostring(prefix) .. tostring(buttonIndex)
		prefix = ""
	else
		suffix = "clicked-button-" .. tostring(prefix) .. tostring(suffix)
		prefix = ""
	end

	return prefix, suffix
end

--- Check if a string is `nil` or currently empty.
--- A string is considered empty if its length is 0.
---
--- @param string string
--- @return boolean
function Clicked:IsStringNilOrEmpty(string)
	return string == nil or #string == 0
end

--- Get all available shapeshift forms the the specified spec ID.
--- Note that this does not mean _currently available_ shapeshift forms,
--- just all possible shapeshift forms.
---
--- It is important that we use this instead of `GetNumShapeshiftForms` and
--- `GetShapeshiftFormInfo` as those will dynamically change depending on what
--- the player currently knows, which can vary depending on talents or level.
---
--- To ensure that shapeshift form data does not get corrupted when switching
--- talents, we store all available shapeshift forms manually.
---
--- @param specId integer
--- @return table
function Clicked:GetShapeshiftFormsForSpecId(specId)
	local forms = shapeshiftForms[specId] or {}
	return { unpack(forms) }
end

--- Iterate through all available shapeshift forms, this function behaves
--- slightly differently depending on the input value.
---
--- If `specId` is not set (or is `nil`), this will return a `pairs` iterator
--- containing all spec IDs and shapeshift forms per spec ID.
---
--- If `specId` is set, it will return an `ipairs` iterator containing all
--- shapeshift forms for the specified spec ID.
---
--- @param specId integer
function Clicked:IterateShapeshiftForms(specId)
	if specId == nil then
		return pairs(shapeshiftForms)
	else
		return ipairs(shapeshiftForms[specId])
	end
end

--- Check if the specified keybind is "restricted", a restricted keybind
--- is not allowed to do various actions as it is required for core game
--- input (such as left and right mouse buttons).
---
--- Restricted keybinds can still be used for bindings, but they will
--- have limited functionality.
---
--- @param keybind string
--- @return boolean
function Clicked:IsRestrictedKeybind(keybind)
	return keybind == "BUTTON1" or keybind == "BUTTON2"
end

--- Check if the specified keybind is a mouse button. This will also
--- return `true` if the mouse button has been modified with alt/shift/ctrl.
---
--- @param keybind string
--- @return boolean
function Clicked:IsMouseButton(keybind)
	if Clicked:IsStringNilOrEmpty(keybind) then
		return false
	end

	local _, suffix = string.match(keybind, "^(.-)([^%-]+)$")
	local buttonIndex = string.match(suffix, "^BUTTON(%d+)$")

	return buttonIndex ~= nil
end

--- Check if a binding's target unit can have a hostility. This will be
--- `false` when, for example, `PARTY_2` is passed in because party members
--- are by definition always friendly during the configuration phase.
---
--- @param unit string
--- @return boolean
function Clicked:CanUnitBeHostile(unit)
	if unit == Clicked.TargetUnits.TARGET then
		return true
	end

	if unit == Clicked.TargetUnits.TARGET_OF_TARGET then
		return true
	end

	if unit == Clicked.TargetUnits.FOCUS then
		return true
	end

	if unit == Clicked.TargetUnits.MOUSEOVER then
		return true
	end

	if unit == Clicked.TargetUnits.PET_TARGET then
		return true
	end

	-- nil should always refer to hovercast units here
	if unit == nil then
		return true
	end

	return false
end

--- Check if a binding's target unit supports `dead` and `nodead` modifiers.
--- This will be `false` when, for example, `CURSOR` is passed in, but also
--- when `PLAYER` is passed in. The player can technically be dead, but we cannot
--- cast anything while dead so it is a condition that can never be reached.
---
--- @param unit string
--- @return boolean
function Clicked:CanUnitBeDead(unit)
	if unit == Clicked.TargetUnits.TARGET then
		return true
	end

	if unit == Clicked.TargetUnits.TARGET_OF_TARGET then
		return true
	end

	if unit == Clicked.TargetUnits.FOCUS then
		return true
	end

	if unit == Clicked.TargetUnits.PARTY_1 then
		return true
	end

	if unit == Clicked.TargetUnits.PARTY_2 then
		return true
	end

	if unit == Clicked.TargetUnits.PARTY_3 then
		return true
	end

	if unit == Clicked.TargetUnits.PARTY_4 then
		return true
	end

	if unit == Clicked.TargetUnits.PARTY_5 then
		return true
	end

	if unit == Clicked.TargetUnits.MOUSEOVER then
		return true
	end

	if unit == Clicked.TargetUnits.PET then
		return true
	end

	if unit == Clicked.TargetUnits.PET_TARGET then
		return true
	end

	-- nil should always refer to hovercast units here
	if unit == nil then
		return true
	end

	return false
end

--- Check if a binding's target unit can have a follow up target. This will be
--- the case for most targets, but some targets act as a stop sign in macro code
--- as they will always be valid. For example [@player] or [@cursor] will always
--- be 'true' and thus it doesn't make sense to allow targets beyond.
---
--- @param unit string
--- @return string
function Clicked:CanUnitHaveFollowUp(unit)
	if unit == Clicked.TargetUnits.PLAYER then
		return false
	end

	if unit == Clicked.TargetUnits.CURSOR then
		return false
	end

	if unit == Clicked.TargetUnits.DEFAULT then
		return false
	end

	-- nil should always refer to hovercast units here
	if unit == nil then
		return false
	end

	return true
end

--- Get the active action of a binding configuration. The data for spells, items,
--- and macros is all saved in separate data structures. This function will return
--- the correct data structure for the current `type` of the binding.
---
--- @param binding table
--- @return table
function Clicked:GetActiveBindingAction(binding)
	if binding.type == Clicked.BindingTypes.SPELL then
		return binding.actions.spell
	end

	if binding.type == Clicked.BindingTypes.ITEM then
		return binding.actions.item
	end

	if binding.type == Clicked.BindingTypes.MACRO then
		return binding.actions.macro
	end

	if binding.type == Clicked.BindingTypes.UNIT_SELECT then
		return binding.actions.unitSelect
	end

	if binding.type == Clicked.BindingTypes.UNIT_MENU then
		return binding.actions.unitMenu
	end

	return nil
end