/obj/projectile/bullet
	name = "пуля"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	nodamage = FALSE
	flag = BULLET
	hitsound_wall = "ricochet"
	sharpness = SHARP_POINTY
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	shrapnel_type = /obj/item/shrapnel/bullet
	embedding = list(embed_chance=60, fall_chance=0, jostle_chance=5, ignore_throwspeed_threshold=TRUE, pain_stam_pct=1, pain_mult=5, rip_time=20)
	wound_bonus = 10
	bare_wound_bonus = 15
	stun = 5
	ricochets_max = 2
	ricochet_chance = 20
	ricochet_incidence_leeway = 45

/obj/projectile/bullet/smite
	name = "божественное воздаяние"
	damage = 10
