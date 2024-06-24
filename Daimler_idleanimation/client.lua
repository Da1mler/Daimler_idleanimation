local isIdlePlaying = false
local lastActionTime = 0
local idleTimeout = 5000
local isWaitingForAnimation = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then
                lastActionTime = GetGameTimer()
            end
            
            if GetGameTimer() - lastActionTime > idleTimeout then
                if not isIdlePlaying then
                    DrawText3D(x, y, z, "~b~Press E for a random animation")
                    if IsControlJustReleased(0, 38) and not isWaitingForAnimation then
                        isWaitingForAnimation = true
                        RequestAnimDict("move_m@generic_idles@std")
                        if HasAnimDictLoaded("move_m@generic_idles@std") then
                            TaskPlayAnim(playerPed, "move_m@generic_idles@std", "idle", 8.0, -8, -1, 49, 0, false, false, false)
                            isIdlePlaying = true
                            Citizen.Wait(500)
                            isIdlePlaying = false
                            isWaitingForAnimation = false
                        end
                    end
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local scale = 0.35
    
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(173, 216, 230)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
