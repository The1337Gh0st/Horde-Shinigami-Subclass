PERK.PrintName = "Harvest"
PERK.Description = "Cold damage ignores enemy Cold damage resistance. \nKilling elites releases a damaging mist. \nMist deals damage equal to quadruple the max health of the target."
PERK.Icon = "materials/perks/coup.png"
PERK.Params = {
    [1] = {value = 10},
    [2] = {value = 0.25, percent = true},
	[3] = {value = 1},
	[4] = {value = 0.01, percent = true},
	[5] = {value = 0.08, percent = true},
	[6] = {value = 5},
	[7] = {value = 0.01, percent = true},
	[8] = {value = 0.04, percent = true},
	[9] = {value = 3},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerDamagePost = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinigami_4_1")  then return end
	if HORDE:IsColdDamage(dmginfo) then
    dmginfo:SetDamageType(DMG_DIRECT)
	end
end

PERK.Hooks.Horde_OnEnemyKilled = function(victim, killer, inflictor)
    if not victim:IsValid() or not victim:IsNPC() or not killer:IsPlayer() then return end
    if not killer:Horde_GetPerk("shinigami_4_1") then return end
	if not victim:GetVar("is_elite") then return end
    if inflictor:IsNPC() then return end -- Prevent infinite chains
        local dmg = victim:GetMaxHealth() * 4
        local rad = 150
        local e = EffectData()
    local effectdata = EffectData()
    effectdata:SetOrigin(victim:GetPos())
    effectdata:SetRadius(150)
    util.Effect("heal_mist", effectdata)
    victim:EmitSound("arccw_go/smokegrenade/smoke_emit.wav", 90, 100, 1, CHAN_AUTO)
      util.BlastDamage(victim, killer, victim:GetPos(), rad, dmg)
end
