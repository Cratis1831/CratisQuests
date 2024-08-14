local addonName, CratisQuests = ...

print("|cfffcba03Cratis_Quests loaded")

local doNotShowQuestType = {
	[128] = "Emissary Quest",
	[261] = "Island Weekly Quest",
	[270] = "Threat Emissary Quest",
	[81] = "Threat Emissary Quest",
	[109] = "World Quest",
	[265] = "Hidden Quest",
	--[0] = "Other"
}

local doNotTropQuestTypes = {
	[267] = "Professions",
}


local questDB = {}

local UIConfig = CreateFrame("Frame", nil, UIParent);
UIConfig:SetFrameStrata("BACKGROUND")
UIConfig:Hide()
UIConfig:SetSize(100, 50)
UIConfig:SetPoint("CENTER", UIParent, 0, 50)
UIConfig.Text = UIConfig:CreateFontString()
UIConfig.Text:SetFont("Fonts\\FRIZQT__.TTF", 30, "OUTLINE")
UIConfig.Text:SetPoint("CENTER")
UIConfig.Text:SetJustifyH("CENTER")
UIConfig.Text:SetJustifyV("MIDDLE")

local btnKeep = CreateFrame("Button", nil, UIConfig, "UIPanelButtonTemplate")
local btnDrop = CreateFrame("Button", nil, UIConfig, "UIPanelButtonTemplate")



btnDrop:Hide()
btnKeep:Hide()

UIConfig:RegisterEvent("QUEST_ACCEPTED");

local function shareQuest(questId, questTitle)
	local isPushable = C_QuestLog.IsPushableQuest(questId)
	if (isPushable) then
		C_QuestLog.SetSelectedQuest(questId)
		QuestLogPushQuest();
		DEFAULT_CHAT_FRAME:AddMessage(string.format("Attempting to share %s with your group...", questTitle));
		return;
	end
end

local function eventHandler(self, event, arg1)


	if event == "QUEST_ACCEPTED" and (UnitLevel("player") >= 70 and UnitLevel("player") < 80) then
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID then
			-- Get the map information for the current map
			local mapInfo = C_Map.GetMapInfo(mapID)		
		if mapInfo and mapInfo.parentMapID then
			local mapName = C_Map.GetMapInfo(mapID).name
			local parentMapID = C_Map.GetMapInfo(mapID).parentMapID
			local parentMapName = C_Map.GetMapInfo(C_Map.GetMapInfo(mapID).parentMapID).name

			if (parentMapName == CratisQuests.MapID[parentMapID] or mapName == CratisQuests.MapID[mapID]) then
				self.db = CratisQuestsDB or CopyTable(defaults)
				self.questDB = QuestDB or CopyTable(CratisQuests.validQuests)
				local questID = arg1
				local questType = C_QuestLog.GetQuestType(questID)
				local questTitle = C_QuestLog.GetTitleForQuestID(questID)
				local questLogIndex = C_QuestLog.GetLogIndexForQuestID(questID)
				local info = C_QuestLog.GetInfo(questLogIndex)

				local campaignID = C_CampaignInfo.GetCampaignID(questID)
				local validQuestList = CratisQuests.validQuests
				local keep = false
				if (doNotShowQuestType[questType] == nil) then
					local campaignInfo = C_CampaignInfo.GetCampaignInfo(campaignID)
					-- if (validQuestList[strlower(questTitle)] ~= nil or doNotTropQuestTypes[questType] ~= nil) then
					-- changed to use questID instead of questTitle
					if (validQuestList[questID] ~= nil or doNotTropQuestTypes[questType] ~= nil) then
						keep = true
					end
					if (campaignInfo ~= nil) then
						if (campaignInfo["name"] ~= '') then
							--print("Campaign Name: " .. campaignInfo["name"])
							keep = true
						end
					end
					if (keep == false) then
						--self.Text:SetText("EVENT: " .. event .. " quest: " .. title .. " id: " .. arg1 .. " questType: " .. questType);
						self:Show()

						if (self.db.playSound == true) then
							PlaySoundFile(567459, "Master")
						end
						if (self.db.autoDrop == false) then

							self.Text:SetText("|cfffcba03\"" .. questTitle .. "\" is not an optimal quest")
							btnDrop:Show()
							btnKeep:Show()


							do
								btnKeep:SetPoint("TOPLEFT", UIConfig, -60, -40)
								btnKeep:SetSize(100, 50)
								if (IsInGroup()) then
									btnKeep:SetText("Keep & Share Quest")
									btnKeep:SetSize(125, 50)
								else
									btnKeep:SetText("Keep Quest")
								end

								btnKeep:SetScript("OnClick", function()
									if (IsInGroup()) then
										shareQuest(questID, questTitle)
									end
									self:Hide()
								end)
							end


							do
								btnDrop:SetPoint("TOPRIGHT", UIConfig, 60, -40)
								btnDrop:SetText("Drop Quest")
								btnDrop:SetSize(100, 50)
								btnDrop:SetScript("OnClick", function()
									C_QuestLog.SetSelectedQuest(questID)
									C_QuestLog.SetAbandonQuest()
									C_QuestLog.AbandonQuest()
									self:Hide()
								end)
							end

						end
						if (self.db.autoDrop == true) then
							btnDrop:Hide()
							btnKeep:Hide()
							self.Text:SetText("|cfffcba03\"" .. questTitle .. "\" is not an optimal quest, dropping it!")
							C_Timer.After(2,
								function()
									C_QuestLog.SetSelectedQuest(questID)
									C_QuestLog.SetAbandonQuest()
									C_QuestLog.AbandonQuest()
									self:Hide()
								end
							)
						end
					else
						if (self.db.shareQuests == true and IsInGroup()) then
							shareQuest(questID, questTitle)
						end
					end
				end
				--else
				--	print(mapName .. "(" .. mapID .. ")" .. " is not a Dragonflight Zone ID, allowing quest...")
			end
		end
	end
	end

end

UIConfig:SetScript("OnEvent", eventHandler);
