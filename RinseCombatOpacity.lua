-- Rinse Combat Opacity
--
-- Rinse has one Opacity slider for its main frame (the debuff buttons sit in their own frame
-- and are always fully visible). This adds a "Combat Opacity" slider right under it in
-- Rinse's options window, and relabels Rinse's slider "OOC Opacity":
--   in combat      -> combat opacity (default 1.00)
--   out of combat  -> Rinse's own opacity
--   mouse over it  -> fully opaque (Rinse's own behaviour, left alone)
--
-- The value is stored next to Rinse's own as RINSE_CONFIG.COMBAT_OPACITY (account-wide,
-- like RINSE_CONFIG.OPACITY). Rinse's files stay untouched.

if not RinseFrame or not RinseOptionsFrameOpacitySlider then return end

local inCombat = false

local function combatAlpha()
	local a = RINSE_CONFIG and tonumber(RINSE_CONFIG.COMBAT_OPACITY) or 1
	if a < 0 then a = 0 end
	if a > 1 then a = 1 end
	return a
end

local function baseAlpha()
	if inCombat then return combatAlpha() end
	return RINSE_CONFIG and tonumber(RINSE_CONFIG.OPACITY) or 1
end

local function hovered()
	local hit = getglobal("RinseFrameHitRect")
	-- same area Rinse uses for its own mouseover (the title bar strip)
	return hit and MouseIsOver(hit)
end

-- Rinse sets the frame to 1 on mouseover and restores RinseFrame.alpha on leave, so keep
-- that stored value in step and only touch the alpha while the mouse isn't over it.
local function apply()
	if not RINSE_CONFIG then return end
	local a = baseAlpha()
	RinseFrame.alpha = a
	if not hovered() and math.abs(RinseFrame:GetAlpha() - a) > 0.001 then
		RinseFrame:SetAlpha(a)
	end
end

-- Relabel Rinse's slider: it's now the out-of-combat opacity.
if Rinse and Rinse.L then
	Rinse.L.FMT_OPACITY = "OOC Opacity (%.2f)"
end

-- Combat Opacity slider, right under Rinse's Opacity slider; everything that was anchored
-- under that slider moves down one slot and the window grows to match.
local opts = RinseOptionsFrame
local oocSlider = RinseOptionsFrameOpacitySlider
local slider = CreateFrame("Slider", "RinseOptionsFrameCombatOpacitySlider", opts, "RinseOptionsSliderTemplate")
slider:SetWidth(160)
slider:SetHeight(16)
slider:SetPoint("TOPLEFT", oocSlider, "BOTTOMLEFT", 0, -16)
getglobal(slider:GetName() .. "Low"):SetText("0")
getglobal(slider:GetName() .. "High"):SetText("1")
slider:SetMinMaxValues(0, 1)
slider:SetValueStep(0.01)
slider.tooltipText = "Opacity of the Rinse frame while you're in combat. Out of combat the OOC Opacity above is used; with the mouse over the frame it's always fully visible."
slider:SetScript("OnValueChanged", function()
	local a = tonumber(format("%.2f", this:GetValue()))
	if RINSE_CONFIG then RINSE_CONFIG.COMBAT_OPACITY = a end
	getglobal(this:GetName() .. "Text"):SetText(format("Combat Opacity (%.2f)", a))
	apply()
end)
getglobal(slider:GetName() .. "Text"):SetText(format("Combat Opacity (%.2f)", 1))

local below = getglobal("RinseOptionsFrameWyvernSting")
if below then
	below:ClearAllPoints()
	below:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -24)
end
opts:SetHeight(opts:GetHeight() + 32)

-- Rinse's own slider sets the frame alpha directly whenever it changes; re-apply after it so
-- moving it in combat doesn't change the in-combat opacity.
local origOnValueChanged = oocSlider:GetScript("OnValueChanged")
oocSlider:SetScript("OnValueChanged", function()
	if origOnValueChanged then origOnValueChanged() end
	apply()
end)

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:SetScript("OnEvent", function()
	if event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
	else
		-- Rinse has loaded its settings (ADDON_LOADED) by now.
		inCombat = UnitAffectingCombat("player") and true or false
		if RINSE_CONFIG then
			RINSE_CONFIG.COMBAT_OPACITY = RINSE_CONFIG.COMBAT_OPACITY or 1.0
			slider:SetValue(RINSE_CONFIG.COMBAT_OPACITY)
			getglobal(oocSlider:GetName() .. "Text"):SetText(format(Rinse.L.FMT_OPACITY, RINSE_CONFIG.OPACITY or 1))
		end
	end
	apply()
end)

-- Catch the mouse leaving mid-combat-change and anything else that resets the alpha.
local nextTick = 0
events:SetScript("OnUpdate", function()
	local now = GetTime()
	if now < nextTick then return end
	nextTick = now + 0.2
	apply()
end)
