local addonName, CratisQuests = ...

-- Create the main options panel
CratisQuests.panel = CreateFrame("Frame", "CratisQuestsPanel", UIParent)
CratisQuests.panel.name = "CratisQuests"

-- Register the options panel as a settings category
CratisQuests.category = Settings.RegisterCanvasLayoutCategory(CratisQuests.panel, CratisQuests.panel.name)
CratisQuests.categoryID = CratisQuests.category:GetID()
Settings.RegisterAddOnCategory(CratisQuests.category)

local defaults = {
    playSound = true,
    autoDrop = false,
    shareQuests = true,
}

function CratisQuests.panel:OnEvent(event, addOnName)
    if addOnName == addonName then
        print("|cfffcba03Cratis_Quests loaded - Options: /cq")

        CratisQuestsDB = CratisQuestsDB or CopyTable(defaults)
        QuestDB = QuestDB or CopyTable(CratisQuests.validQuests)
        self.db = CratisQuestsDB
        self.questDB = QuestDB
        self:InitializeOptions()
    end
end

CratisQuests.panel:RegisterEvent("ADDON_LOADED")
CratisQuests.panel:SetScript("OnEvent", CratisQuests.panel.OnEvent)

function CratisQuests.panel:InitializeOptions()
    -- Setup options panel content
    local t = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText("Cratis Quests")
    t:SetPoint("TOPLEFT", self, 20, -15)

    local t = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetText("Contact: " .. "  xxx@gmail.com")
    t:SetPoint("TOPLEFT", self, 20, -50)

    local t = self:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    t:SetText("Optimal Side Quest list based off of the hard work of amzeus (discord: amzeus#4876)")
    t:SetPoint("TOPLEFT", self, 20, -200)

    do
        local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -100)
        cb.Text:SetText("Play Sound on Quest Abandoned")
        cb:HookScript("OnClick", function(_, btn, down)
            self.db.playSound = cb:GetChecked()
        end)
        cb:SetChecked(self.db.playSound)
    end
    do
        local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -120)
        cb.Text:SetText("Auto Drop Quest (if unchecked, it will ask to drop the quest)")
        cb:HookScript("OnClick", function(_, btn, down)
            self.db.autoDrop = cb:GetChecked()
        end)
        cb:SetChecked(self.db.autoDrop)
    end

    do
        local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, -140)
        cb.Text:SetText("Auto Share Quest with Group")
        cb:HookScript("OnClick", function(_, btn, down)
            self.db.shareQuests = cb:GetChecked()
        end)
        cb:SetChecked(self.db.shareQuests)
    end

    local t = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    t:SetText("List of Side Quests & Bonus Objectives:")
    t:SetPoint("TOPLEFT", self, 20, -250)

    do
        local scrollFrame = CreateFrame("ScrollFrame", nil, self, "UIPanelScrollFrameTemplate")
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
                cb:HookScript("OnClick", function(_, btn, down)
                    self.questDB[k] = cb:GetChecked()
                end)
                cb:SetChecked(self.questDB[k])
                coord = coord + -20
            end
        end
    end
end

-- Define the slash command
SLASH_CQ1 = "/cq"

SlashCmdList.CQ = function(msg, editBox)
    -- Open directly to the registered category panel
    if CratisQuests.category then
        Settings.OpenToCategory(CratisQuests.categoryID)
    else
        print("CratisQuests category not found!")
    end
end
