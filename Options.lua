local addonName, CratisDFQuests = ...

local f = CreateFrame("Frame")

local defaults = {
    playSound = true,
    autoDrop = false,
    shareQuests = true,
}

function f:OnEvent(event, addOnName)
    if addOnName == "CratisDFQuests" then
        print("|cfffcba03Cratis_DFQuestsloaded - Options: /cdf")

        CratisDFQuestsDB = CratisDFQuestsDB or CopyTable(defaults)
        QuestDB = QuestDB or CopyTable(CratisDFQuests.validDFQuests)
        self.db = CratisDFQuestsDB
        self.questDB = QuestDB
        self:InitializeOptions()
    end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)

function f:InitializeOptions()
    self.panel = CreateFrame("Frame", nil, UIParent)
    self.panel.name = "CratisDFQuests"



    local t = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText("Cratis Dragonflight Quests")
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

    do
        local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -140)
        cb.Text:SetText("Auto Share Quest with Group")
        -- there already is an existing OnClick script that plays a sound, hook it
        cb:HookScript("OnClick", function(_, btn, down)
            self.db.shareQuests = cb:GetChecked()
        end)
        cb:SetChecked(self.db.shareQuests)
    end


    local t = self.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText("List of Side Quests & Bonus Objectives:")
    t:SetPoint("TOPLEFT", self.panel, 20, -250)
    do
        local scrollFrame = CreateFrame("ScrollFrame", nil, self.panel, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 3, -280)
        scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

        local scrollChild = CreateFrame("Frame")
        scrollFrame:SetScrollChild(scrollChild)
        scrollChild:SetWidth(500)
        scrollChild:SetHeight(1)


        local coord = -20
        local bd = CreateFrame("Frame", nil, scrollChild)
        for k, v in pairs(self.questDB) do
            do
                local cb = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
                cb:SetPoint("TOPLEFT", 20, coord)


                cb.Text:SetText(k)
                -- there already is an existing OnClick script that plays a sound, hook it
                cb:HookScript("OnClick", function(_, btn, down)
                    self.questDB[k] = cb:GetChecked()
                end)
                cb:SetChecked(self.questDB[k])
                coord = coord + -20
            end
        end

    end

    InterfaceOptions_AddCategory(self.panel)
end

SLASH_CDF1 = "/cdf"

SlashCmdList.CDF = function(msg, editBox)
    InterfaceOptionsFrame_OpenToCategory(f.panel)
end
