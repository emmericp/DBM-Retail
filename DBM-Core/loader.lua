require "bit"
function UnitClass() return "Shaman", "SHAMAN" end
function UnitName() return "FakePlayer" end
function GetRealmName() return "FakeServer" end
function GetGuildInfo() return "FakeGuild" end
function GetTime() return 0 end
function UnitLevel() return 60 end
function UnitGUID() return end
function GetLocale() return "enUS" end
function GetBuildInfo() return "1.15", nil, nil, 110002 end
function IsMacClient() return false end
function geterrorhandler() return error end
function seterrorhandler() end
function IsTestBuild() return false end
function IsSpellKnown() return false end
function IsPlayerSpell() return false end
function IsInRaid() return true end
function IsTrialAccount() return false end
function IsInGroup() return true end
function IsInInstance() return true end
function GetNumGroupMembers() return 0 end
function UnitOnTaxi() return false end
function GetSpellTexture() return "" end
function GetNumTalentTabs() return 1 end
function InCombatLockdown() return false end
function UnitPosition() return end
function GetInstanceInfo() return nil, nil, nil, nil, nil, nil, nil, nil, nil end
function Ambiguate(str) return str end
function PlaySoundFile() return end
function tostringall(str, ...)
	if select("#", ...) == 0 then
		return tostring(str)
	end
	return tostring(str), tostringall(...)
end
debugstack = debug.traceback
local oldxpcall = xpcall
function xpcall(f, handler, ...)
	local args = {...}
	return oldxpcall(function()
		return f(unpack(args))
	end, function(...) print("xpcall error", ...) end)
end
local preciseTime
function GetTimePreciseSec() return preciseTime end
date = os.date

C_LFGInfo = {
	GetDungeonInfo = function() return end
}
C_Timer = {
	After = function() return end
}

local magicMock = {}

local function makeMock()
	return setmetatable({}, magicMock)
end

magicMock.__index = function(self, key)
	return makeMock()
end

magicMock.__call = function()
	return makeMock()
end

C_QuestLog = makeMock()
C_AddOns = makeMock()
function C_AddOns.GetAddOnEnableState() return 0 end
function C_AddOns.GetNumAddOns() return 0 end
DBT = makeMock()
DEFAULT_CHAT_FRAME = makeMock()
C_ChatInfo = makeMock()
SlashCmdList = {}

local frame = {}
frame.__index = frame

function CreateFrame()
	return makeMock()
end

GetSpellInfo = makeMock()
C_Map = makeMock()
C_Map.GetBestMapForUnit = function() return 0 end
ChatThrottleLib = makeMock()

local dbmPrivate = {}

local function loadFile(file)
	local f, err = loadfile(file)
	if not f then error(err) end
	f("DBM-Core", dbmPrivate)
end

loadFile("Libs/LibStub/LibStub.lua")

function GetCVar() return 0 end
function SetCVar() return 0 end

strmatch = string.match
strsplit = function(delim, str)
	local results = {}
	local lastOffset = 1
	for i = 1, #str do
		if str:sub(i, i) == delim or i == #str then
			if lastOffset < i - 1 then
				results[#results+1] = str:sub(lastOffset, i == #str and i or i - 1)
			end
			lastOffset = i + 1
		end
	end
	return unpack(results)
end
string.split = strsplit
string.trim = function(str) return str:gsub("%s*(.-)%s*", "%1") end
string.join = function(sep, ...) local res = "" for i = 1, select("#", ...) do res = res .. sep .. select(i, ...) end return res end
table.wipe = function(t) for k in pairs(t) do t[k] = nil end end
tinsert = table.insert
twipe = table.wipe
LibStub:NewLibrary("LibDropDownMenu", 1)
LibStub:NewLibrary("CallbackHandler-1.0", 1).New = makeMock()

loadFile("Data/Enum.lua")
loadFile("Data/Constants.lua")

loadFile("localization.en.lua")
loadFile("commonlocal.en.lua")
loadFile("modules/objects/PrototypeRegistry.lua")
loadFile("modules/objects/Testing.lua")
loadFile("modules/objects/GameVersion.lua")
loadFile("modules/objects/StringUtils.lua")
loadFile("modules/objects/TableUtils.lua")
loadFile("modules/objects/StandardFont.lua")
loadFile("modules/Modules.lua")
loadFile("modules/SpecRole.lua")
loadFile("modules/Scheduler.lua")
loadFile("modules/DevTools.lua")
loadFile("modules/Icons.lua")
loadFile("modules/TargetScanning.lua")

loadFile("DBM-Core.lua")
loadFile("DBM-Arrow.lua")
loadFile("DBM-Flash.lua")
loadFile("DBM-RangeCheck.lua")
loadFile("DBM-InfoFrame.lua")
--loadFile("DBM-HudMap.lua")
--loadFile("DBM-Nameplate.lua")

loadFile("modules/Commands.lua")
loadFile("modules/Hyperlinks.lua")
loadFile("modules/MinimapButton.lua")
loadFile("modules/Notes.lua")
loadFile("modules/Sounds.lua")
loadFile("modules/UpdateReminder.lua")
loadFile("modules/AnnoyingPopup.lua")
loadFile("modules/ZoneCombatScanner.lua")

loadFile("modules/objects/Difficulties.lua")
loadFile("modules/objects/BossMod.lua")
loadFile("modules/objects/BossModEventDispatcher.lua")
loadFile("modules/objects/Localization.lua")
loadFile("modules/objects/VoicePacks.lua")
loadFile("modules/objects/Timer.lua")
loadFile("modules/objects/EnrageTimer.lua")
loadFile("modules/objects/Announce.lua")
loadFile("modules/objects/SpecialWarning.lua")
loadFile("modules/objects/Yell.lua")
loadFile("modules/objects/Sorting.lua")

DBM:ADDON_LOADED("DBM-Core")

loadFile("../DBM-Test/Registry.lua")
loadFile("../DBM-Test/Report.lua")
loadFile("../DBM-Test/Runner.lua")
loadFile("../DBM-Test/TimeWarper.lua")
loadFile("../DBM-Test/Mocks.lua")

loadFile("../../DBM-Vanilla/DBM-Raids-Vanilla/AQ40/Skeram.lua")
loadFile("../../DBM-Vanilla/DBM-Test-Vanilla/Season of Discovery/AQ40/Skeram-Hardmode.lua")

DBM.Test:RunTest("SoD/AQ40/Skeram/Hardmode")



for i = 1, 100 do
	preciseTime = i / 100
	if not DBM.Test.ResumeCoroutine() then break end
end

print(DBM.Test.reporter:Report())
