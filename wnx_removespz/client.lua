local LastVehicle = nil
local LicencePlate = {}
LicencePlate.Index = false
LicencePlate.Number = false

-- Command Pro odebrání SPZ
RegisterCommand("sundatspz", function()
    ExecuteCommand('me Sundává SPZ z vozidla')
    if not LicencePlate.Index and not LicencePlate.Number then
        local PlayerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPed)
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        local VehicleCoords = GetEntityCoords(Vehicle)
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        if Distance < 3.5 and not IsPedInAnyVehicle(PlayerPed, false) then
			LastVehicle = Vehicle
			-- Notifikace + animace
            lib.progressBar({
                duration = 1000,
                label = 'Sundáváš SPZ'
            })
            Animation()
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            Citizen.Wait(6000)
            LicencePlate.Index = GetVehicleNumberPlateTextIndex(Vehicle)
            LicencePlate.Number = GetVehicleNumberPlateText(Vehicle)
            SetVehicleNumberPlateText(Vehicle, " ")
        else
            lib.notify({
                description = 'Žádné vozidlo není poblíž',
                type = 'error'
            })
        end
    else
        lib.notify({
            description = 'Nemáte u sebe SPZ.',
            type = 'error'
        })
    end
end)

-- Command pro nasazení spz zpátky
RegisterCommand("nasaditspz", function()
    ExecuteCommand('me Nasazuje SPZ zpátky')
    if LicencePlate.Index and LicencePlate.Number then
        local PlayerPed = PlayerPedId()
        local Coords = GetEntityCoords(PlayerPed)
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        local VehicleCoords = GetEntityCoords(Vehicle)
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        if ( (Distance < 3.5) and not IsPedInAnyVehicle(PlayerPed, false) ) then
		if (Vehicle == LastVehicle) then
				LastVehicle = nil
                -- Notifikace + animace
                Animation()
                lib.progressBar({
                    duration = 1000,
                    label = 'Nandáváš SPZ'
                })
                StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
			Citizen.Wait(6000)
			SetVehicleNumberPlateTextIndex(Vehicle, LicencePlate.Index)
			SetVehicleNumberPlateText(Vehicle, LicencePlate.Number)
			LicencePlate.Index = false
			LicencePlate.Number = false
		else
            lib.notify({
                description = 'Tato spz sem nepatří',
                type = 'success'
            })
		end
        else
            lib.notify({
                description = 'Žádné vozidlo není poblíž',
                type = 'success'
            })
        end
    else
        lib.notify({
            description = 'Tato spz sem nepatří',
            type = 'info'
        })
    end
end)

function Animation()
    local pid = PlayerPedId()
    RequestAnimDict("mini")
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do 
		Citizen.Wait(10) 
	end
    TaskPlayAnim(pid,"mini@repair","fixing_a_player",1.0,-1.0, 5000, 0, 1, true, true, true)
end
