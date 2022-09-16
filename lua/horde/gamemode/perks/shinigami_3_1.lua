PERK.PrintName = "Rift Walk"
PERK.Description = "Release a smoke bomb at your feet that gives you 100% evasion \nand speed boost for 3 seconds, but you cannot deal damage while active. \n10 second cooldown."
PERK.Icon = "materials/perks/specops/smokescreen.png"
PERK.Params = {
    [1] = {value = 2},
    [2] = {value = 0.15, percent = true},
	[3] = {value = 0.25, percent = true},
	[4] = {value = 25},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "shinigami_3_1" then
        if ply:Horde_GetPerk("shinigami_3_1") then
            ply:Horde_SetPerkCooldown(10)
        end

        net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Smokescreen, 8)
            net.WriteUInt(1, 3)
        net.Send(ply)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "shinigami_3_1" then
        net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Smokescreen, 8)
            net.WriteUInt(0, 3)
        net.Send(ply)
    end
end

PERK.Hooks.Horde_OnPlayerDamageTaken = function(ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("shinigami_3_1")  then return end
	 if ply:Horde_GetSmokescreen() == 1 then
	bonus.evasion = bonus.evasion + 0.5
	end
end

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinigami_3_1")  then return end
	
	if ply:Horde_GetSmokescreen() == 1 then
        bonus.more = bonus.more * 0
    end
end

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus)
   if not ply:Horde_GetPerk("shinigami_3_1") then return end
	if ply:Horde_GetSmokescreen() == 1 then
    bonus.walkspd = bonus.walkspd * 2
    bonus.sprintspd = bonus.sprintspd * 2
end
end

PERK.Hooks.Horde_UseActivePerk = function (ply)
    if not ply:Horde_GetPerk("shinigami_3_1") then return end
	 local rocket = ents.Create("projectile_horde_smokescreen")
    local vel = 0
    local ang = ply:EyeAngles()

    local src = ply:GetPos() + Vector(0,0,0) + ply:GetEyeTrace().Normal * 5

    if !rocket:IsValid() then print("!!! INVALID ROUND " .. rocket) return end

    local rocketAng = Angle(ang.p, ang.y, ang.r)

    rocket:SetAngles(rocketAng)
    rocket:SetPos(src)

    rocket:SetOwner(ply)
    rocket.Owner = ply
    rocket.Inflictor = rocket

    local RealVelocity = ang:Forward() * vel / 1
    rocket.CurVel = RealVelocity -- for non-physical projectiles that move themselves

    rocket:Spawn()
    rocket:Activate()
    if !rocket.NoPhys and rocket:GetPhysicsObject():IsValid() then
        rocket:SetCollisionGroup(rocket.CollisionGroup or COLLISION_GROUP_DEBRIS)
        rocket:GetPhysicsObject():SetVelocityInstantaneous(RealVelocity)
    end

    if rocket.Launch and rocket.SetState then
        rocket:SetState(1)
        rocket:Launch()
    end

end

