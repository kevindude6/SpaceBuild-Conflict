local SBC = SBC

SBC.Planets = {}
local PlanetList = SBC.Planets

--Planet Default Atmospheres
default = {}
default.atmosphere = {}
default.atmosphere.o2 = 30
default.atmosphere.co2 = 5
default.atmosphere.ch4 = 0
default.atmosphere.n = 50
default.atmosphere.h = 15
default.atmosphere.ar = 0

local function SpaceEngineIntialize()
	print("/////////////////////////////////////")
	print("//     Loading SBC SpaceEngine     //")
	print("/////////////////////////////////////")
	print("// Adding Planets..           //")
	local status, error = pcall(function() --log errors
		
		
	end end)--ends the error checker
	
	if not error then
		print("/////////////////////////////////////")
		print("//        SpaceEngine Loaded       //")
		print("/////////////////////////////////////")
	else
		print("/////////////////////////////////////")
		print("//     SpaceEngine Load Failed     //")
		print("/////////////////////////////////////")
		print("ERROR: "..error)
	end
end
hook.Add("InitPostEntity","SpaceEngineIntialize", SpaceEngineIntialize)

function SBC.CreateSBCFromMap()
	local rawdata, rawstars = SBC.LoadFromMap()
	rawdata.version = nil
	for k,v in pairs(rawdata) do
		local planet = SBC.ParsePlanet(v)
		SBC.CreatePlanet(planet)
	end
	Stars = {}
	for k,v in pairs(rawstars) do
	--	local star = SBC.ParseStar(v)
	--	SBC.CreateStar(star)
	--	table.insert(stars, star)
	end
	return rawdata, rawstars
end

function SBC.GrabRawPlanetData()
	local i = 0
	local planets, stars = {}, {}
	print("//   Loading Planets               //")
	
	local entities = ents.FindByClass( "logic_case" )
	for k,ent in pairs(entities) do
		local values = ent:GetKeyValues()
		local tab = ent:GetKeyValues()
			
		local Type = tab.Case01
		local planet = {position = ent:GetPos()}
		
		--KEYS
		planet.radius = tonumber(tab.Case02) --Get Radius
		planet.gravity = tonumber(tab.Case03) --Get Gravity
		--END KEYS
			
		if Type == "env_rectangle" then
			planet.typeof = "cube"

			--Add Defaults
			planet.atmosphere = {}
			planet.atmosphere = table.Copy(default.atmosphere)
			planet.unstable = "false"
			planet.temperature = 288
			planet.pressure = 1
	
			i=i+1
			planet.name = i

			table.insert(planets, planet)
			print("//     Spacebuild Cube Added       //")
		elseif Type == "cube" then --need to fix in the future
			planet.typeof = "cube"

			--Add Defaults
			planet.atmosphere = {}
			planet.atmosphere = table.Copy(default.atmosphere)
			planet.unstable = "false"
			planet.temperature = 288
			planet.pressure = 1
			
			i=i+1
			planet.name = i

			table.insert(planets, planet)
			print("//     Spacebuild Cube Added       //")
		elseif Type == "planet" then
			--Add Defaults
			planet.atmosphere = {}
			planet.atmosphere = table.Copy(default.atmosphere)
			planet.unstable = "false"
			planet.temperature = 288
			planet.pressure = 1
			planet.typeof = "SB2"
			
			--KEYS
			planet.atm = tonumber(tab.Case04)
			planet.temperature = tonumber(tab.Case05)
			planet.suntemperature = tonumber(tab.Case06)
			planet.colorid = tostring(tab.Case07)
			planet.bloomid = tostring(tab.Case08)
			planet.flags = tonumber(tab.Case16)
			--END KEY
		
			if planet.atm == 0 then
				planet.atm = 1
			end
			i=i+1
			planet.name = i
			
			local planet = SBC.ParseSB2Environment(planet)
			table.insert(planets, planet)
			print("//     Spacebuild 2 Planet Added   //")
		elseif Type == "planet2" then
			--Defaults
			planet.atmosphere = {}
			planet.atmosphere = table.Copy(default.atmosphere)
			planet.unstable = "false"
			planet.temperature = 288
			planet.pressure = 1
			
			planet.typeof = "SB3"
			
			planet.atm = tonumber(tab.Case04) --What does this mean?
			planet.pressure = tonumber(tab.Case05)
			planet.temperature = tonumber(tab.Case06)
			planet.suntemperature = tonumber(tab.Case07)
			planet.flags = tonumber(tab.Case08) --can be 0, 1, 2
			planet.atmosphere.o2 = tonumber(tab.Case09)
			planet.atmosphere.co2 = tonumber(tab.Case10)
			planet.atmosphere.n = tonumber(tab.Case11)
			planet.atmosphere.h = tonumber(tab.Case12)
			planet.name = tostring(tab.Case13) --Get Name
			planet.colorid = tostring(tab.Case15)
			planet.bloomid = tostring(tab.Case16)
						
			planet.originalco2per = planet.atmosphere.co2
			
			if planet.atm == 0 then
				planet.atm = 1
			end
				
			i=i+1
			table.insert(planets, planet)
			print("//     Spacebuild 3 Planet Added   //")
		elseif Type == "star" then
			planet.temperature = 10000
			planet.solaractivity = "med"
			planet.baseradiation = "1000"
		
			i=i+1	
			table.insert(stars, planet)
			print("//     Spacebuild 2 Star Added     //")
		elseif Type == "star2" then				
			planet.name = tostring(tab.Case06)
			
			if not planet.name then
				planet.name = "Star"
			end
						
			planet.temperature = 5000
			planet.solaractivity = "med"
			planet.baseradiation = "1000"

			i=i+1
			table.insert(stars, planet)
			print("//     Spacebuild 3 Star Added     //")
		else --not a normal ent

		end
	end
	planets.version = SBC.FileVersion
	
	return planets, stars
end

--Creates the actual game entity for the planet.
function SBC.CreatePlanet(d)
	local planet = nil
	
	//Different Type Support
	if d.typeof == "SB3" then
		planet = ents.Create("sbc_planet")
		planet:Spawn()
		planet:SetPos(d.position)
		planet:Configure(d.radius, d.gravity, d.name, d)
		--planet:Create(d.gravity, d.atmosphere, d.pressure, d.temperature, d.air, d.name, d.total, d.originalco2per)
	elseif d.typeof == "SB2" then
		planet = ents.Create("sbc_planet")
		planet:Spawn()
		planet:SetPos(d.position)
		planet:Configure(d.radius, d.gravity, d.name, d)
		--planet:Create(d.gravity, d.atmosphere, d.pressure, d.temperature, d.air, d.name, d.total, d.originalco2per)
	else
		if d.typeof then
			print("NOT A VALID TYPE: "..d.typeof)
		else
			print("Planet TYPE IS NIL!")
		end
	end
	
	if planet then
		//stop it from getting removed
		planet.Delete = planet.Remove
		planet.Remove = function(d) 
			print("Something Attempted to Remove Planet "..d.name)
		end
		
		table.insert(PlanetList, planet)
	else
		print("CREATED PLANET WAS NIL, OR PLANET WAS NOT CREATED!")
	end
end

--Configures the planet
function SBC.ParsePlanet(planet)
	local gravity = planet.gravity
	local o2 = planet.atmosphere.o2
	local co2 = planet.atmosphere.co2
	local n = planet.atmosphere.n
	local h = planet.atmosphere.h
	local ch4 = planet.atmosphere.ch4
	local ar = planet.atmosphere.ar
	local temperature = planet.temperature
	local suntemperature = planet.suntemperature
	local atmosphere = planet.atm
	local radius = planet.radius
	local volume = GetVolume(radius)
	local unstable =  planet.unstable
	local sunburn = planet.sunburn
	
	if planet.flags then
		unstable, sunburn = GetSB3Flags(planet.flags)
	end
	
	local self = {}
	self.radius = radius
	self.position = planet.position
	self.typeof = planet.typeof

	self.unstable = unstable
	self.sunburn = sunburn
	self.bloomid = planet.bloomid
	self.colorid = planet.colorid
	
	if gravity and type(gravity) == "number" then
		if gravity < 0 then
			gravity = 0
		end
		self.gravity = gravity
	end
	//set atmosphere if given
	if atmosphere and type(atmosphere) == "number" then
		if atmosphere < 0 then
			atmosphere = 0
		elseif atmosphere > 1 then
			atmosphere = 1
		end
		self.atmosphere = atmosphere
	end
	//set pressure if given
	if pressure and type(pressure) == "number" and pressure >= 0 then
		self.pressure = pressure
	else 
		self.pressure = math.Round(self.atmosphere * self.gravity)
	end
	//set temperature if given
	if temperature and type(temperature) == "number" then
		if temperature < 35 then
			temperature = 35
		end
		self.temperature = temperature
	end
	//set suntemperature if given
	if suntemperature and type(suntemperature) == "number" then
		if suntemperature < 35 then
			suntemperature = 35
		end
		self.suntemperature = suntemperature
	end
	
	self.air = {}

	for k,v in pairs(planet.atmosphere) do
		self.air[k] = v
	end
	
	if o2 + co2 + n + h + ch4 + ar < 1 then --FIXED :D (barren planets, what to do here? this breaks venting)
		print("LESS THAN 1% on "..planet.name)
	elseif o2 + co2 + n + h + ch4 + ar > 100 then
		print("MORE THAN 100% on "..planet.name)
	elseif o2 + co2 + n + h + ch4 + ar < 100 then
		print("LESS THAN 100% on "..planet.name)
	else
		print("OK on "..planet.name)
	end
	
	if planet.name then
		self.name = planet.name
	end

	--self.pressure = self.atmosphere * self.gravity * (1 - (self.air.emptyper/100))
	self.originalco2per = self.air.co2per
	
	return self
end

//Borrowed from SB3
function SBC.ParseSB2Environment(planet)
	local habitat, unstable, sunburn = GetFlags(planet.flags)
	planet.flags = nil

	//set Radius if one is given
	if planet.radius and type(radius) == "number" then
		if planet.radius < 0 then
			planet.radius = 0
		end
	end
	//set temperature2 if given
	if habitat then //Based on values for earth
		planet.atmosphere.o2 = 21
		planet.atmosphere.co2 = 0.45
		planet.atmosphere.n = 78
		planet.atmosphere.h = 0.55
	else //Based on values for Venus
		planet.atmosphere.o2 = 0
		planet.atmosphere.co2 = 96.5
		planet.atmosphere.n = 3.5
		planet.atmosphere.h = 0
	end
	planet.sunburn = sunburn
	planet.unstable = unstable
	return planet
end
//End Borrowed code

function SBC.ParseStar(planet)
	local self = {}
	self.radius = planet.radius
	self.position = planet.position
	self.typeof = planet.typeof
	self.name = planet.name
	self.temperature = planet.temperature
	self.isstar = true
	self.gravity = 0 --planet.gravity
	self.air = {}
	self.air.o2per = 0
	return self
end

function SBC.CreateStar(planet)
	local star = ents.Create("Star")
	star:Spawn()
	star:SetPos(planet.position)
	star:Configure(planet.radius, planet.gravity, planet.name, planet)
	
	table.insert(PlanetList, star)
end
