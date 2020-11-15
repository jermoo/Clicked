Clicked.STOP_CASTING_BUTTON_NAME = "ClickedStopCastingButton"
Clicked.MACRO_FRAME_HANDLER_NAME = "ClickedMacroFrameHandler"

Clicked.EVENT_MACRO_HANDLER_ATTRIBUTES_CREATED = "MACRO_HANDLER_ATTRIBUTES_CREATED"
Clicked.EVENT_HOVERCAST_ATTRIBUTES_CREATED = "HOVERCAST_ATTRIBUTES_CREATED"

local macroFrameHandler
local stopCastingButton

local function CreateStateDriverAttribute(frame, state, condition)
	frame:SetAttribute("_onstate-" .. state, [[
		if not self:IsShown() then
			return
		end

		if newstate == "enabled" then
			self:RunAttribute("clicked-clear-bindings")
		else
			self:RunAttribute("clicked-register-bindings")
		end
	]])

	RegisterStateDriver(frame, state, condition)
end

local function EnsureStopCastingButton()
	if stopCastingButton ~= nil then
		return
	end

	stopCastingButton = CreateFrame("Button", Clicked.STOP_CASTING_BUTTON_NAME, nil, "SecureActionButtonTemplate")
	stopCastingButton:SetAttribute("type", "stop")
end

local function EnsureMacroFrameHandler()
	if macroFrameHandler ~= nil then
		return
	end

	macroFrameHandler = CreateFrame("Button", Clicked.MACRO_FRAME_HANDLER_NAME, UIParent, "SecureActionButtonTemplate,SecureHandlerStateTemplate,SecureHandlerShowHideTemplate")
	macroFrameHandler:Hide()

	-- set required data first
	macroFrameHandler:SetAttribute("clicked-keybinds", "")
	macroFrameHandler:SetAttribute("clicked-identifiers", "")

	-- register OnShow and OnHide handlers to ensure bindings are registered
	macroFrameHandler:SetAttribute("_onshow", [[
		self:RunAttribute("clicked-register-bindings")
	]])

	macroFrameHandler:SetAttribute("_onhide", [[
		self:RunAttribute("clicked-clear-bindings")
	]])

	-- attempt to register a binding, this will also check if the binding
	-- is currently allowed to be active (e.g. not in a vehicle or pet battle)
	macroFrameHandler:SetAttribute("clicked-register-bindings", [[
		if not self:IsShown() then
			return
		end

		if self:GetAttribute("state-petbattle") == "enabled" then
			return
		end

		if self:GetAttribute("state-vehicle") == "enabled" or self:GetAttribute("state-vehicleui") == "enabled" then
			return
		end

		if self:GetAttribute("state-possessbar") == "enabled" then
			return
		end

		local keybinds = self:GetAttribute("clicked-keybinds")
		local identifiers = self:GetAttribute("clicked-identifiers")

		if strlen(keybinds) > 0 then
			keybinds = table.new(strsplit("\001", keybinds))
			identifiers = table.new(strsplit("\001", identifiers))

			for i = 1, table.maxn(keybinds) do
				local keybind = keybinds[i]
				local identifier = identifiers[i]

				self:SetBindingClick(true, keybind, self, identifier)
			end
		end
	]])

	-- unregister a binding
	macroFrameHandler:SetAttribute("clicked-clear-bindings", [[
		local keybinds = self:GetAttribute("clicked-keybinds")

		if strlen(keybinds) > 0 then
			keybinds = table.new(strsplit("\001", keybinds))

			for i = 1, table.maxn(keybinds) do
				local keybind = keybinds[i]
				self:ClearBinding(keybind)
			end
		end
	]])

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		CreateStateDriverAttribute(macroFrameHandler, "vehicle", "[@vehicle,exists] enabled; disabled")
		CreateStateDriverAttribute(macroFrameHandler, "vehicleui", "[vehicleui] enabled; disabled")
		CreateStateDriverAttribute(macroFrameHandler, "petbattle", "[petbattle] enabled; disabled")
	end

	CreateStateDriverAttribute(macroFrameHandler, "possessbar", "[possessbar] enabled; disabled")
end

function Clicked:UpdateMacroFrameHandler(keybinds, attributes)
	local split = {
		keybinds = {},
		identifiers = {}
	}

	for _, keybind in ipairs(keybinds) do
		table.insert(split.keybinds, keybind.key)
		table.insert(split.identifiers, keybind.identifier)
	end

	macroFrameHandler:SetAttribute("clicked-keybinds", table.concat(split.keybinds, "\001"))
	macroFrameHandler:SetAttribute("clicked-identifiers", table.concat(split.identifiers, "\001"))

	self:SetPendingFrameAttributes(macroFrameHandler, attributes)
	self:ApplyAttributesToFrame(macroFrameHandler)
end

-- Note: This is a secure function and may not be called during combat
function Clicked:ProcessCommands(commands)
	if InCombatLockdown() then
		return
	end

	local newClickCastFrameKeybinds = {}
	local newClickCastFrameAttributes = {}

	local newMacroFrameHandlerKeybinds = {}
	local newMacroFrameHandlerAttributes = {}

	EnsureStopCastingButton()
	EnsureMacroFrameHandler()

	-- Unregister all current keybinds
	macroFrameHandler:Hide()

	for _, command in ipairs(commands) do
		local attributes = {}

		local targetKeybinds
		local targetAttributes

		local keybind = {
			key = command.keybind,
			identifier = command.suffix
		}

		self:CreateCommandAttributes(attributes, command, command.prefix, command.suffix)
		self:SendMessage(self.EVENT_MACRO_HANDLER_ATTRIBUTES_CREATED, command, attributes)

		if command.hovercast then
			targetKeybinds = newClickCastFrameKeybinds
			targetAttributes = newClickCastFrameAttributes
		else
			targetKeybinds = newMacroFrameHandlerKeybinds
			targetAttributes = newMacroFrameHandlerAttributes
		end

		table.insert(targetKeybinds, keybind)

		for attribute, value in pairs(attributes) do
			targetAttributes[attribute] = value
		end
	end

	self:SendMessage(Clicked.EVENT_MACRO_HANDLER_ATTRIBUTES_CREATED, newClickCastFrameKeybinds, newClickCastFrameAttributes)
	self:UpdateMacroFrameHandler(newMacroFrameHandlerKeybinds, newMacroFrameHandlerAttributes)

	-- Register all new keybinds
	macroFrameHandler:Show()

	self:SendMessage(Clicked.EVENT_HOVERCAST_ATTRIBUTES_CREATED, newClickCastFrameKeybinds, newClickCastFrameAttributes)
	self:UpdateClickCastHeader(newClickCastFrameKeybinds)
	self:UpdateClickCastFrames(newClickCastFrameAttributes)
end