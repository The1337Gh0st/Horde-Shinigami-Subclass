PERK.PrintName = "Psychopomp"
PERK.Description = "10% increased ballistic damage. \n20% additional ballistic headshot damage."
PERK.Icon = "materials/perks/necromancer/necromastery.png"
PERK.Params = {
    [1] = {value = 1, percent = true},
    [2] = {value = 0.25, percent = true},
	[3] = {value = 0.5, percent = true},
}

PERK.Hooks = {}

	
PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup, dmginfo)
    if not ply:Horde_GetPerk("shinigami_1_2")  then return end
	if HORDE:IsBallisticDamage(dmginfo) then
    bonus.increase = bonus.increase + 0.1
	end

	if hitgroup == HITGROUP_HEAD and HORDE:IsBallisticDamage(dmginfo) then
	bonus.increase = bonus.increase + 0.2
	end
end

