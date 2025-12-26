AddCSLuaFile("cl_init.lua")
AddCSLuaFile("vgui/world-space/healthbar.lua")
AddCSLuaFile("vgui/canvas-space/help/help-base-hud.lua")
AddCSLuaFile("cl/inputmanager.lua")
AddCSLuaFile("shared.lua" )

include( "shared.lua" )

function GM:PlayerSpawn(ply)
    self.BaseClass.PlayerSpawn(self, ply)

    ply:SetModel("models/player/kleiner.mdl")

    local swepClass = "weapon_prinnyknife" -- SWEP class name

    if weapons.Get(swepClass) then
        ply:StripWeapons()           -- optional: remove other weapons
        ply:Give(swepClass)          -- give the SWEP
        ply:SelectWeapon(swepClass)  -- equip immediately
    else
        print("[GM WARNING] SWEP not found: " .. swepClass)
    end
end

function GM:InitPostEntity()
    if SERVER then
        for i = 1, 1 do
            for j = 1, 1 do
                -- Create the antlion
                local antlion = ents.Create("npc_antlion")
                if not IsValid(antlion) then return end

                -- Set position in front of the spawn point
                antlion.spawnPos = Vector(100 * i, 100 * j, 100)
                antlion:SetPos(antlion.spawnPos) -- Change coordinates as needed

                -- Make it passive
                antlion:SetKeyValue("sleepstate", 0)

                antlion:Spawn()
                antlion:Activate()
                
                -- Set health
                antlion:SetMaxHealth(400)
                antlion:SetHealth(400)
            end
        end
    end
end

function RPGX:OnNPCKilled(npc, attacker, inflictor, base)
    if npc:GetClass() == "npc_antlion" then
        if SERVER then
            -- Create the antlion
            local antlion = ents.Create("npc_antlion")
            if not IsValid(antlion) then return end

            -- Set position in front of the spawn point
            antlion.spawnPos = npc.spawnPos
            antlion:SetPos(antlion.spawnPos) -- Change coordinates as needed

            -- Make it passive
            antlion:SetKeyValue("sleepstate", 0)

            antlion:Spawn()
            antlion:Activate()

            -- Set health
            antlion:SetMaxHealth(400)
            antlion:SetHealth(400)
        end
    end
    return base.method(base.gamemode, npc, attacker, inflictor)
end

-- Set up overrides
function GM:PostGamemodeLoaded()
    local base = {
        method = self.OnNPCKilled,
        gamemode = self
    }
    function self:OnNPCKilled(npc, attacker, inflictor)
        return RPGX:OnNPCKilled(npc, attacker, inflictor, base)
    end
end