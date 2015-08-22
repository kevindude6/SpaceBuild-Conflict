--[[----------------------------------------------------
Jupiter Debug Core -Allows Easy Debugging.
----------------------------------------------------]]--

local SBC = SBC --Localise the global table for speed.
SBC.DebugLogs = SBC.DebugLogs or {}

local DebugTypes = {Verbose=3,Basic=2,None=1}
local DebugMode = DebugTypes["None"]
local DebugLogs = SBC.DebugLogs

function SBC.SetDebugMode(Mode)
	if not DebugTypes[Mode] then 
		print("Error! Debug Mode is Invalid! Defaulting to 'None'.") 
		SBC.DebugMode="None"
		DebugMode = DebugTypes["None"]
		return
	end
	
	SBC.DebugMode=Mode
	DebugMode = DebugTypes[Mode]
end
SBC.SetDebugMode(SBC.DebugMode)

function SBC.Debug(MSG,Type,Source)
	--print("T: "..tostring(Type).." D: "..tostring(DebugMode))
	if Type <= DebugMode then
		if SERVER then
			print("SD["..tostring(Source or "Error").."]: "..tostring(MSG))
			MsgAll("SD["..tostring(Source or "Error").."]: "..tostring(MSG).."\n")
		else
			print("SD["..tostring(Source or "Error").."]: "..tostring(MSG))
		end
	end
	
	if not SERVER then return end --Add client to server logging later.
	local Log = {C=math.floor(CurTime()),M=MSG}
	if not DebugLogs[Source] then 
		DebugLogs[Source] = {}
	end
	table.insert(DebugLogs[Source],Log)
end




