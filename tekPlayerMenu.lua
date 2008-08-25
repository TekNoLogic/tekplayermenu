
local function insertbefore(t, before, val)
 for k,v in ipairs(t) do if v == before then return table.insert(t, k, val) end end
 table.insert(t, val)
end

local clickers = {["ADD_FRIEND"] = AddFriend, ["IGNORE"] = AddIgnore, ["WHO"] = SendWho, ["GUILD_INVITE"] = GuildInvite}


UnitPopupButtons["ADD_FRIEND"] = {text = TEXT(ADD_FRIEND), dist = 0}
UnitPopupButtons["GUILD_INVITE"] = {text = "Guild Invite", dist = 0}
UnitPopupButtons["IGNORE"] = {text = TEXT(IGNORE), dist = 0}
UnitPopupButtons["WHO"] = {text = TEXT(WHO), dist = 0}

insertbefore(UnitPopupMenus["FRIEND"], "GUILD_PROMOTE", "GUILD_INVITE")
insertbefore(UnitPopupMenus["FRIEND"], "GUILD_INVITE", "ADD_FRIEND")
insertbefore(UnitPopupMenus["FRIEND"], "IGNORE", "WHO")
insertbefore(UnitPopupMenus["PLAYER"], "INVITE", "WHO")


hooksecurefunc("UnitPopup_HideButtons", function()
	local dropdownMenu = getglobal(UIDROPDOWNMENU_INIT_MENU)
	for i,v in pairs(UnitPopupMenus[dropdownMenu.which]) do
		if v == "GUILD_INVITE" then UnitPopupShown[i] = (not CanGuildInvite() or dropdownMenu.name == UnitName("player")) and 0 or 1
		elseif clickers[v] then UnitPopupShown[i] = (dropdownMenu.name == UnitName("player") and 0) or 1 end
	end
end)


hooksecurefunc("UnitPopup_OnClick", function(self)
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU)
	local button = self.value
	if clickers[button] then clickers[button](dropdownFrame.name) end
	PlaySound("UChatScrollButton")
end)

