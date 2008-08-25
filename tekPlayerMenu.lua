
local order = {"WHISPER", "INVITE", "TARGET", "GUILD_PROMOTE", "GUILD_LEAVE", "ADD_FRIEND", "IGNORE", "WHO", "REPORT_SPAM", "CANCEL"}
local clickers = {["ADD_FRIEND"] = AddFriend, ["IGNORE"] = AddIgnore, ["WHO"] = SendWho, ["GUILD_INVITE"] = GuildInviteByName}


UnitPopupButtons["ADD_FRIEND"] = {text = TEXT(ADD_FRIEND), dist = 0}
UnitPopupButtons["GUILD_INVITE"] = {text = "Guild Invite", dist = 0}
UnitPopupButtons["IGNORE"] = {text = TEXT(IGNORE), dist = 0}
UnitPopupButtons["WHO"] = {text = TEXT(WHO), dist = 0}
UnitPopupMenus["FRIEND"] = {}
for k,v in pairs(order) do UnitPopupMenus["FRIEND"][k] = v end

table.insert(UnitPopupMenus["PLAYER"], getn(UnitPopupMenus["PLAYER"])-1, "WHO")
table.insert(UnitPopupMenus["PARTY"], getn(UnitPopupMenus["PARTY"])-1, "WHO")


hooksecurefunc("UnitPopup_HideButtons", function()
	local dropdownMenu = getglobal(UIDROPDOWNMENU_INIT_MENU)
	for i,v in pairs(UnitPopupMenus[dropdownMenu.which]) do
		if v == "GUILD_INVITE" then UnitPopupShown[i] = (not CanGuildInvite() or dropdownMenu.name == UnitName("player")) and 0 or 1
		elseif clickers[v] then UnitPopupShown[i] = (dropdownMenu.name == UnitName("player") and 0) or 1 end
	end
end)


hooksecurefunc("UnitPopup_OnClick", function()
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	local button = this.value
	if clickers[button] then clickers[button](dropdownFrame.name) end
	PlaySound("UChatScrollButton")
end)

