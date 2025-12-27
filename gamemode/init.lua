AddCSLuaFile("cl_init.lua")
AddCSLuaFile("vgui/world-space/healthbar.lua")
AddCSLuaFile("vgui/canvas-space/help/help-base-hud.lua")
AddCSLuaFile("cl/inputmanager.lua")
AddCSLuaFile("shared.lua" )

include( "shared.lua" )

function GM:PlayerSpawn(ply)
    self.BaseClass.PlayerSpawn(self, ply)

    ply:SetModel("models/player/kleiner.mdl")

    if weapons.Get("weapon_fists") then
        ply:StripWeapons()
        ply:Give("weapon_fists")
    end
end

function GM:GetFallDamage(ply, speed)
    return speed * 0.03
end

function GM:InitPostEntity()
    if SERVER then
        local spawnPoints =  util.JSONToTable(file.Read("rpgxspawnpoints/spawnpoints.json", "DATA"), false) or {}

        for _, spawnData in pairs(spawnPoints[game.GetMap()]) do
            local entity = ents.Create(spawnData.settings.SelectedNPCs[1]) -- TODO Change to random selection later
            if not IsValid(entity) then return end

            entity.spawnData = table.Copy(spawnData)
            entity:SetPos(Vector(spawnData.position.x, spawnData.position.y, spawnData.position.z))

            entity:Spawn()
            entity:Activate()

            entity:SetMaxHealth(15)
            entity:SetHealth(15)
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
            antlion.spawnData = npc.spawnData
            antlion:SetPos(Vector(antlion.spawnData.position.x, antlion.spawnData.position.y, antlion.spawnData.position.z)) -- Change coordinates as needed

            -- Make it passive
            antlion:SetKeyValue("sleepstate", 0)

            antlion:Spawn()
            antlion:Activate()

            -- Set health
            antlion:SetMaxHealth(40)
            antlion:SetHealth(40)
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