/obj/projectile/energy/declone
	name = "радиационный луч"
	icon_state = "declone"
	damage = 20
	damage_type = CLONE
	irradiate = 100
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser

/obj/projectile/energy/bluntenergy
	name = "разломие"
	icon_state = "razlomie"
	damage = 25
	damage_type = BRUTE
	speed = 0.1
	wound_bonus = 20
	bare_wound_bonus = 25
	stun = 15
	immobilize = 5
	stamina = 5
	sharpness = null
	ricochets_max = 3
	ricochet_chance = 22
	ricochet_incidence_leeway = 50

/obj/projectile/energy/declone/weak
	damage = 9
	irradiate = 30

/obj/projectile/energy/dart //ninja throwing dart
	name = "дротик"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	paralyze = 100
	range = 7
