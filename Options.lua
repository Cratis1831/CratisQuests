local addonName, CratisDFQuests = ...

local f = CreateFrame("Frame")

local defaults = {
    playSound = true,
    autoDrop = true
}

function f:OnEvent(event, addOnName)
    if addOnName == "CratisDFQuests" then
        print("|cfffcba03Cratis_DFQuestsloaded - Options: /cdf")

        CratisDFQuestsDB = CratisDFQuestsDB or CopyTable(defaults)
        self.db = CratisDFQuestsDB
        self:InitializeOptions()
    end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

function f:InitializeOptions()
    self.panel = CreateFrame("Frame", nil, UIParent)
    self.panel.name = "CratisDFQuests"



    local t = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText("Cratis DF Quests")
    t:SetPoint("TOPLEFT", self.panel, 20, -15)

    local t = self.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetText("Contact: " .. "  xxx@gmail.com")
    t:SetPoint("TOPLEFT", self.panel, 20, -50)

    local t = self.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetText("Optimal Side Quest list based off of the hard work of amzeus (discord: amzeus#4876)")
    t:SetPoint("TOPLEFT", self.panel, 20, -200)

    do
        local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -100)
        cb.Text:SetText("Play Sound on Quest Abandoned")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb:HookScript("OnClick", function(_, btn, down)
            self.db.playSound = cb:GetChecked()
        end)
        cb:SetChecked(self.db.playSound)
    end
    do
        local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -120)
        cb.Text:SetText("Auto Drop Quest (if unchecked, it will ask to drop the quest)")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb:HookScript("OnClick", function(_, btn, down)
            self.db.autoDrop = cb:GetChecked()
        end)
        cb:SetChecked(self.db.autoDrop)
    end

    --local btn = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
    --btn:SetPoint("TOPLEFT", cb, 0, -40)
    --btn:SetText("Click me")
    --btn:SetWidth(100)
    --btn:SetScript("OnClick", function()
    --    print("You clicked me!")
    --end)

    InterfaceOptions_AddCategory(self.panel)
end

SLASH_CDF1 = "/cdf"

SlashCmdList.CDF = function(msg, editBox)
    InterfaceOptionsFrame_OpenToCategory(f.panel)
end
