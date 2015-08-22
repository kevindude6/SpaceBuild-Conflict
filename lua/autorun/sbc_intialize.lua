------------------------------------------
//  Jupiter Engine GameMode System      //
------------------------------------------
print("==============================================")
print("==       Environments X    Loading...       ==")
print("==============================================")

AddCSLuaFile()--Make Sure the client gets it.

local start = SysTime()

SBC = {}
local SBC = SBC --MAH SPEED

SBC.Version = "SuperDamEarly V:0.01"
SBC.Gamemode = "SandBox"
SBC.EnableMenu = true --Debug Menu
SBC.DebugMode = "Verbose" 
/*Print to console Debugging variable. 
Types: 
"Verbose" -Prints All Debugging messages.
"Basic"-Prints Basic Debugging messages.
"None"-Doesnt print to console at all.
*/ 

-- 0 Client 1 Shared 2 Server
function SBC.LoadFile(Path,Mode) --Easy way of loading files.
	if SERVER then
		if Mode >= 1 then
			include(Path)
			if Mode == 1 then
				AddCSLuaFile(Path)
			end
		else
			AddCSLuaFile(Path)
		end
	else
		if Mode <= 1 then
			include(Path)
		end
	end
end
local LoadFile = SBC.LoadFile --Lel Speed.

LoadFile("envx/variables.lua",1)

LoadFile("envx/utilities/sh_debug.lua",1)
LoadFile("envx/utilities/sh_utility.lua",1)
LoadFile("envx/utilities/sh_networking.lua",1)
LoadFile("envx/utilities/sh_datamanagement.lua",1)

LoadFile("envx/sbc_spaceengine.lua",2)


if(SERVER)then


	--Resources this mod uses.
	resource.AddFile("resource/fonts/digital-7 (italic).ttf")
	
	resource.AddWorkshop( "174935590" ) --Spore Models
	resource.AddWorkshop( "160250458" ) --Wire Models
	resource.AddWorkshop( "148070174" ) --Mandrac Models
	resource.AddWorkshop( "182803531" ) --SBEP Models	
	
else

end		

print("==============================================")
print("==    SpaceBuild-Conflict   Installed       ==")
print("==============================================")
print("SpaceBuild-Conflict Load Time: "..(SysTime() - start))