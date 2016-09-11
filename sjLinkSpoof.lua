
sjLinkSpoof = AceLibrary("AceAddon-2.0"):new(
"AceConsole-2.0",
"AceDebug-2.0",
"AceDB-2.0",
"AceEvent-2.0",
"AceHook-2.1")

local PINK = "|cffff77ff[%s]|r"

local addon = sjLinkSpoof
local addonName = "sjLinkSpoof"
local db

function addon:OnInitialize()
    self:RegisterDB(addonName.."_DB")
    self:RegisterDefaults("profile", {
    })
    db = self.db.profile
    self:RegisterChatCommand({"/sjLinkSpoof", "/sjls"}, {
        type = "group",
        args = {
            show = {
                order = 1,
                name = "Show",
                desc = "Show sjLinkSpoof main frame",
                type = "execute",
                func = function()
                    self.main:Show()
                end
            }
        }
    })
    self:SetDebugging(db.debugging)
end

function addon:OnEnable()
    self:InitFrames()
    self:SetupHooks()
end

function addon:SetDebugging(set)
    db.debugging = set
    self.debugging= set
end

function addon:InitFrames()
    -- Main frame
    f = CreateFrame("Frame", addonName.."_Main", UIParent)
    self.main = f
    f:Hide()
    f:SetWidth(600)
    f:SetHeight(100)
    f:SetPoint("CENTER", 0, 0)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f.background = f:CreateTexture(nil, "BACKGROUND")
    f.background:SetAllPoints()
    f.background:SetTexture(0.1, 0.1, 0.1, 0.5)
    f:SetScript("OnDragStart", function()
        self.main:StartMoving()
    end)
    f:SetScript("OnDragStop", function()
        self.main:StopMovingOrSizing()
    end)
    -- Close button
    f = CreateFrame("Button", addonName.."_CloseButton", self.main, "UIPanelCloseButton")
    self.closeButton = f
    f:SetPoint("TOPRIGHT", 4, 3)
    -- Clear button
    f = CreateFrame("Button", addonName.."_ClearButton", self.main, "UIPanelButtonTemplate")
    self.clearButton = f
    f:SetWidth(80)
    f:SetHeight(20)
    f:SetPoint("RIGHT", self.closeButton, "LEFT", 5, 1)
    f:SetText("Clear")
    f:SetScript("OnClick", function()
        self.editBox1:SetText("")
        self.editBox1:ClearFocus()
        self.editBox2:SetText("")
        self.editBox2:ClearFocus()
    end)
    -- Print button
    f = CreateFrame("Button", addonName.."_PrintButton", self.main, "UIPanelButtonTemplate")
    self.printButton = f
    f:SetWidth(80)
    f:SetHeight(20)
    f:SetPoint("RIGHT", self.clearButton, "LEFT", 0, 0)
    f:SetText("Print")
    f:SetScript("OnClick", function()
        self:Print(format("Link: %s", self.editBox1:GetText()))
    end)
    -- Edit box 1
    f = CreateFrame("EditBox", addonName.."_EditBox1", self.main, "InputBoxTemplate")
    self.editBox1 = f
    f:SetAutoFocus(false)
    f:SetWidth(590)
    f:SetHeight(20)
    f:SetPoint("TOPLEFT", 8, -24)
    f:SetScript("OnEditFocusGained", function()
        self.editBoxFocused = self.editBox1
    end)
    f:SetScript("OnEditFocusLost", function()
        self.editBoxFocused = nil
    end)
    f:SetScript("OnTextChanged", function()
        local text = gsub(self.editBox1:GetText(), "\124", "\124\124")
        self.editBox2:SetText(text)
    end)
    -- Edit box 2
    f = CreateFrame("EditBox", addonName.."_EditBox2", self.main, "InputBoxTemplate")
    self.editBox2 = f
    f:SetAutoFocus(false)
    f:SetWidth(590)
    f:SetHeight(20)
    f:SetPoint("TOP", self.editBox1, "BOTTOM", 0, 0)
    f:SetScript("OnEditFocusGained", function()
        self.editBoxFocused = self.editBox2
    end)
    f:SetScript("OnEditFocusLost", function()
        self.editBoxFocused = nil
    end)
    f:SetScript("OnTextChanged", function()
        local text = gsub(self.editBox2:GetText(), "\124\124", "\124")
        self.editBox1:SetText(text)
    end)
end

function addon:SetupHooks()
    -- Scrolling text frames
    self:Hook("SetItemRef", function(link, text, button)
        if
            strsub(link, 1, 6) ~= "player" and IsShiftKeyDown() and
            not ChatFrameEditBox:IsVisible() then
            if self.editBoxFocused then
                self.editBoxFocused:Insert(text)
            end
        end
        self.hooks["SetItemRef"](link, text, button)
    end)
    -- Container items
    self:Hook("ContainerFrameItemButton_OnClick", function(button, ignoreModifiers)
        if
            button == "LeftButton" and not ignoreModifiers and
            IsShiftKeyDown() and not ChatFrameEditBox:IsVisible() and
            GameTooltipTextLeft1:GetText() then
            if self.editBoxFocused then
                self.editBoxFocused:Insert(GetContainerItemLink(this:GetParent():GetID(), this:GetID()))
            end
        end
        self.hooks["ContainerFrameItemButton_OnClick"](button, ignoreModifiers)
    end)
end

