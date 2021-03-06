
/*
	Blunt/Bone wounds
*/
// TODO: well, a lot really, but i'd kill to get overlays and a bonebreaking effect like Blitz: The League, similar to electric shock skeletons

/datum/wound/blunt
	name = "Blunt (Bone) Wound"
	sound_effect = 'sound/effects/wounds/crack1.ogg'
	wound_type = WOUND_BLUNT
	wound_flags = (BONE_WOUND | ACCEPTS_GAUZE)

	/// Have we been taped?
	var/taped
	/// Have we been bone gel'd?
	var/gelled
	/// If we did the gel + surgical tape healing method for fractures, how many ticks does it take to heal by default
	var/regen_ticks_needed
	/// Our current counter for gel + surgical tape regeneration
	var/regen_ticks_current
	/// If we suffer severe head booboos, we can get brain traumas tied to them
	var/datum/brain_trauma/active_trauma
	/// What brain trauma group, if any, we can draw from for head wounds
	var/brain_trauma_group
	/// If we deal brain traumas, when is the next one due?
	var/next_trauma_cycle
	/// How long do we wait +/- 20% for the next trauma?
	var/trauma_cycle_cooldown
	/// If this is a chest wound and this is set, we have this chance to cough up blood when hit in the chest
	var/internal_bleeding_chance
	var/internal_bleeding_coefficient

/*
	Overwriting of base procs
*/
/datum/wound/blunt/wound_injury(datum/wound/old_wound = null)
	// hook into gaining/losing gauze so crit bone wounds can re-enable/disable depending if they're slung or not
	RegisterSignal(limb, list(COMSIG_BODYPART_GAUZED, COMSIG_BODYPART_GAUZE_DESTROYED), .proc/update_inefficiencies)

	if(limb.body_zone == BODY_ZONE_HEAD && brain_trauma_group)
		processes = TRUE
		active_trauma = victim.gain_trauma_type(brain_trauma_group, TRAUMA_RESILIENCE_WOUND)
		next_trauma_cycle = world.time + (rand(100-WOUND_BONE_HEAD_TIME_VARIANCE, 100+WOUND_BONE_HEAD_TIME_VARIANCE) * 0.01 * trauma_cycle_cooldown)

	RegisterSignal(victim, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, .proc/attack_with_hurt_hand)
	if(limb.held_index && victim.get_item_for_held_index(limb.held_index) && (disabling || prob(30 * severity)))
		var/obj/item/I = victim.get_item_for_held_index(limb.held_index)
		if(istype(I, /obj/item/offhand))
			I = victim.get_inactive_held_item()

		if(I && victim.dropItemToGround(I))
			victim.visible_message(span_danger("<b>[victim]</b> ?????????????? <b>[I]</b> ?? ???????????????? ????????!") , span_warning("???????? ?? ???????? <b>[ru_gde_zone(limb.name)]</b> ???????????????????? ???????? ?????????????? <b>[I]</b>!") , vision_distance=COMBAT_MESSAGE_RANGE)

	update_inefficiencies()

/datum/wound/blunt/remove_wound(ignore_limb, replaced)
	limp_slowdown = 0
	QDEL_NULL(active_trauma)
	if(limb)
		UnregisterSignal(limb, list(COMSIG_BODYPART_GAUZED, COMSIG_BODYPART_GAUZE_DESTROYED))
	if(victim)
		UnregisterSignal(victim, COMSIG_HUMAN_EARLY_UNARMED_ATTACK)
	return ..()

/datum/wound/blunt/handle_process(delta_time, times_fired)
	. = ..()
	if(limb.body_zone == BODY_ZONE_HEAD && brain_trauma_group && world.time > next_trauma_cycle)
		if(active_trauma)
			QDEL_NULL(active_trauma)
		else
			active_trauma = victim.gain_trauma_type(brain_trauma_group, TRAUMA_RESILIENCE_WOUND)
		next_trauma_cycle = world.time + (rand(100-WOUND_BONE_HEAD_TIME_VARIANCE, 100+WOUND_BONE_HEAD_TIME_VARIANCE) * 0.01 * trauma_cycle_cooldown)

	if(!gelled || !taped)
		return

	regen_ticks_current++
	if(victim.body_position == LYING_DOWN)
		if(DT_PROB(30, delta_time))
			regen_ticks_current += 0.5
		if(victim.IsSleeping() && DT_PROB(30, delta_time))
			regen_ticks_current += 0.5

	if(DT_PROB(severity * 1.5, delta_time))
		victim.take_bodypart_damage(rand(1, severity * 2), stamina=rand(2, severity * 2.5), wound_bonus=CANT_WOUND)
		if(prob(33))
			to_chat(victim, span_danger("???????????? ???????????? ???????? ???? ????????????????!"))

	if(regen_ticks_current > regen_ticks_needed)
		if(!victim || !limb)
			qdel(src)
			return
		to_chat(victim, span_green("?????? [limb.name] ???????????? ???? ???????????????? ???? ??????????????????!"))
		remove_wound()

/// If we're a human who's punching something with a broken arm, we might hurt ourselves doing so
/datum/wound/blunt/proc/attack_with_hurt_hand(mob/M, atom/target, proximity)
	SIGNAL_HANDLER

	if(victim.get_active_hand() != limb || victim.a_intent == INTENT_HELP || !ismob(target) || severity <= WOUND_SEVERITY_MODERATE)
		return

	// With a severe or critical wound, you have a 15% or 30% chance to proc pain on hit
	if(prob((severity - 1) * 15))
		// And you have a 70% or 50% chance to actually land the blow, respectively
		if(prob(70 - 20 * (severity - 1)))
			to_chat(victim, span_userdanger("?????????????? ?? ???????? [ru_gde_zone(limb.name)] ???????????????? ?????????? ?????? ?????????? <b>[target]</b>!"))
			limb.receive_damage(brute=rand(1,5))
		else
			victim.visible_message(span_danger("<b>[victim]</b> ?????????? ???????? <b>[target]</b> ?????????? ???????????????? ??????????, ???????????????????? ?? ???????????????? ????????!") , \
			span_userdanger("?????????????? ?? ???????? [ru_gde_zone(limb.name)] ???????????????????? ???? ?????????????????????? ????????, ?????????? ?? ?????????????? ?????????????? <b>[target]</b>!") , vision_distance=COMBAT_MESSAGE_RANGE)
			INVOKE_ASYNC(victim, /mob.proc/emote, "agony")
			victim.Stun(0.5 SECONDS)
			limb.receive_damage(brute=rand(3,7))
			return COMPONENT_CANCEL_ATTACK_CHAIN


/datum/wound/blunt/receive_damage(wounding_type, wounding_dmg, wound_bonus)
	if(!victim || wounding_dmg < WOUND_MINIMUM_DAMAGE)
		return
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		if(NOBLOOD in human_victim.dna?.species.species_traits)
			return

	if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume && prob(internal_bleeding_chance + wounding_dmg))
		var/blood_bled = rand(1, wounding_dmg * internal_bleeding_coefficient * (severity == WOUND_SEVERITY_SEVERE ? 2 : 1.5)) // 12 brute toolbox can cause up to 18/24 bleeding with a severe/critical chest wound
		var/obj/item/organ/lungs/lungs = victim.getorganslot(ORGAN_SLOT_LUNGS)
		var/obj/item/organ/heart/heart = victim.getorganslot(ORGAN_SLOT_HEART)
		var/obj/item/organ/stomach/stomach = victim.getorganslot(ORGAN_SLOT_STOMACH)
		var/obj/item/organ/liver/liver = victim.getorganslot(ORGAN_SLOT_LIVER)
		switch(blood_bled)
			if(1 to 6)
				victim.bleed(blood_bled, TRUE)
			if(7 to 13)
				victim.visible_message(span_danger("<b>[victim]</b> ?????????????? ???????????? ???? ?????????? ?? ??????????.") , span_danger("???????????????????? ?????????????? ?????????? ???? ?????????? ?? ??????????.") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled, TRUE)
				if(prob(20))
					lungs.applyOrganDamage(10)
				else if(prob(20))
					heart.applyOrganDamage(10)
				else if(prob(20))
					stomach.applyOrganDamage(10)
				else if(prob(20))
					liver.applyOrganDamage(10)
			if(14 to 19)
				victim.visible_message(span_danger("<b>[victim]</b> ?????????????????????? ?????????? ?????????? ???? ?????????? ?? ??????????!") , span_danger("???????????????????? ?????????? ?????????? ???? ?????????? ?? ??????????!") , vision_distance=COMBAT_MESSAGE_RANGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
				if(prob(30))
					lungs.applyOrganDamage(20)
				else if(prob(30))
					heart.applyOrganDamage(20)
				else if(prob(30))
					stomach.applyOrganDamage(20)
				else if(prob(30))
					liver.applyOrganDamage(20)
			if(20 to INFINITY)
				victim.visible_message(span_danger("<b>[victim]</b> ?????????????????????? ?????? ???????????? ???? ?????????? ?? ??????????!") , span_danger("<b>???????????????????? ?????? ???????????? ???? ?????????? ?? ??????????!</b>") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))
				if(prob(40))
					lungs.applyOrganDamage(30)
				else if(prob(40))
					heart.applyOrganDamage(30)
				else if(prob(40))
					stomach.applyOrganDamage(30)
				else if(prob(40))
					liver.applyOrganDamage(30)
	if(limb.body_zone == BODY_ZONE_HEAD)
		var/blood_bled = rand(1, wounding_dmg * internal_bleeding_coefficient * (severity == WOUND_SEVERITY_SEVERE ? 2 : 1.5))
		var/obj/item/organ/brain/brain = victim.getorganslot(ORGAN_SLOT_BRAIN)
		switch(blood_bled)
			if(1 to 6)
				victim.bleed(blood_bled, TRUE)
			if(7 to 13)
				victim.visible_message(span_danger("?????????? ???????????????? ???????????? ???? ???????????? [victim]!") , span_danger("???????????????? ???????????????? ???????????????? ???? ??????????????????.") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled, TRUE)
				if(prob(30))
					brain.applyOrganDamage(25)
			if(14 to 19)
				victim.visible_message(span_smalldanger("???????????? [victim] ???????????? ???????????????? ????????????!") , span_danger("?????????????? ?????????? ???????????????? ???? ???????? ????????????!") , vision_distance=COMBAT_MESSAGE_RANGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.bleed(blood_bled)
				if(prob(40))
					brain.applyOrganDamage(35)
			if(20 to INFINITY)
				victim.visible_message(span_danger("???????????? [victim] ?????????????? ????????????!") , span_danger("<b>?????? ????????????! ??????????!</b>") , vision_distance=COMBAT_MESSAGE_RANGE)
				victim.bleed(blood_bled)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(victim.loc, victim.dir)
				victim.add_splatter_floor(get_step(victim.loc, victim.dir))
				if(prob(40))
					brain.applyOrganDamage(40)

/datum/wound/blunt/get_examine_description(mob/user)
	if(!limb.current_gauze && !gelled && !taped)
		return ..()

	var/list/msg = list()
	if(!limb.current_gauze)
		msg += "[victim.ru_ego(TRUE)] [limb.name] [examine_desc]"
	else
		var/sling_condition = ""
		// how much life we have left in these bandages
		switch(limb.current_gauze.absorption_capacity)
			if(0 to 25)
				sling_condition = "????????"
			if(25 to 50)
				sling_condition = "??????????"
			if(50 to 75)
				sling_condition = "??????????????????"
			if(75 to INFINITY)
				sling_condition = "????????????"

		msg += "[capitalize(limb.name)] ???? [victim.ru_na()] [sling_condition] ????????????????"

	if(taped)
		msg += ", ??, ??????????????, ?????????????????????????? ?????? ?????????????????????????? ????????????!"
	else if(gelled)
		msg += ", ?? ???????????????? ?????????????? ???????????? ???????????????? ????????, ?????????????????????? ???? ????????????!"
	else
		msg +=  "!"
	return "<B>[msg.Join()]</B>"

/*
	New common procs for /datum/wound/blunt/
*/

/datum/wound/blunt/proc/update_inefficiencies()
	if(limb.body_zone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		if(limb.current_gauze)
			limp_slowdown = initial(limp_slowdown) * limb.current_gauze.splint_factor
		else
			limp_slowdown = initial(limp_slowdown)
		victim.apply_status_effect(STATUS_EFFECT_LIMP)
	else if(limb.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		if(limb.current_gauze)
			interaction_efficiency_penalty = 1 + ((interaction_efficiency_penalty - 1) * limb.current_gauze.splint_factor)
		else
			interaction_efficiency_penalty = interaction_efficiency_penalty

	if(initial(disabling))
		set_disabling(!limb.current_gauze)

	limb.update_wounds()

/// Joint Dislocation (Moderate Blunt)
/datum/wound/blunt/moderate
	name = "??????????"
	skloname = "????????????"
	desc = "?????????? ???????????????? ?????????????? ???????????????????????? ??????????????, ?????????????????????? ???????????????????? ???????????? ????????????????????."
	treat_text = "?????????????????????????? ?????????????????????????? ???????????????????? ?????? ????????????????????, ???????? ?????????????? ?????????????????????? ?????????? ???????????????????? ???????????????????????? ?????????????? ?? ???????????????? ?? ?????????????????? ???????????????????????????? ?? ???????????????????? ?????????????????????? ?????????? ???????? ????????????????????." //?????? ?????????????????? ?????????? ????????????, ?????? ?????? ?????????????? ???? ???????? ???????????????? ???????????????? ?????????????? ???????????? ???????????? ?? ???????????????????????? ?????????????? ???? ????????. ?????????????? ???????????? ????????????????, ?????? ????????.
	examine_desc = "?????????????? ?????????? ???? ???? ?????????? ??????????"
	occur_text = "?????????????? ?????????????????? ?? ???????????????????????? ?? ???????????????????? ??????????????????"
	severity = WOUND_SEVERITY_MODERATE
	viable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	interaction_efficiency_penalty = 1.5
	limp_slowdown = 3
	internal_bleeding_chance = 25
	internal_bleeding_coefficient = 1
	threshold_minimum = 35
	threshold_penalty = 15
	treatable_tool = TOOL_BONESET
	wound_flags = (BONE_WOUND)
	status_effect_type = /datum/status_effect/wound/blunt/moderate
	scar_keyword = "bluntmoderate"

/datum/wound/blunt/moderate/Destroy()
	if(victim)
		UnregisterSignal(victim, COMSIG_LIVING_DOORCRUSHED)
	return ..()

/datum/wound/blunt/moderate/wound_injury(datum/wound/old_wound)
	. = ..()
	RegisterSignal(victim, COMSIG_LIVING_DOORCRUSHED, .proc/door_crush)

/// Getting smushed in an airlock/firelock is a last-ditch attempt to try relocating your limb
/datum/wound/blunt/moderate/proc/door_crush()
	if(prob(33))
		victim.visible_message(span_danger("<b>[victim]</b> ???????????????????????? [ru_parse_zone(limb.name)] ?? ???????????? ???? ??????????!") , span_userdanger("?????????????????? [ru_parse_zone(limb.name)] ???? ??????????! ????!"))
		remove_wound()

/datum/wound/blunt/moderate/try_handling(mob/living/carbon/human/user)
	if(user.pulling != victim || user.zone_selected != limb.body_zone || user.a_intent == INTENT_GRAB)
		return FALSE

	if(user.grab_state == GRAB_PASSIVE)
		to_chat(user, span_warning("?????? ?????????? ?????????? <b>[victim]</b> ?? ?????????? ?????????????? ???????????? ?????? ?????????????????????? [skloname]!"))
		return TRUE

	if(user.grab_state >= GRAB_AGGRESSIVE)
		user.visible_message(span_danger("<b>[user]</b> ???????????????? ???????????????????? ?? ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b>!") , span_notice("?????????????? ???????????????????? ?? ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b>...") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ???????????????? ?????????????? ?? ?????????????????? ?????????? ???? [ru_gde_zone(limb.name)]!"))
		if(user.a_intent == INTENT_HELP)
			chiropractice(user)
		else
			malpractice(user)
		return TRUE

/// If someone is snapping our dislocated joint back into place by hand with an aggro grab and help intent
/datum/wound/blunt/moderate/proc/chiropractice(mob/living/carbon/human/user)
	var/time = base_treat_time

	if(!do_after(user, time, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	if(prob(65))
		user.visible_message(span_danger("<b>[user]</b> ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b>!") , span_notice("???????????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ???? ??????????!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ?????????????????? ?????? [ru_parse_zone(limb.name)] ???? ??????????!"))
		victim.emote("agony")
		limb.receive_damage(brute=20, wound_bonus=CANT_WOUND)
		qdel(src)
	else
		user.visible_message(span_danger("<b>[user]</b> ???????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ???????????????? ??????????????????????!") , span_danger("?????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ??????????????????????!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ???????????? ?????? [ru_parse_zone(limb.name)] ??????????????????????!"))
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		chiropractice(user)

/// If someone is snapping our dislocated joint into a fracture by hand with an aggro grab and harm or disarm intent
/datum/wound/blunt/moderate/proc/malpractice(mob/living/carbon/human/user)
	var/time = base_treat_time

	if(!do_after(user, time, target=victim, extra_checks = CALLBACK(src, .proc/still_exists)))
		return

	if(prob(65))
		user.visible_message(span_danger("<b>[user]</b> ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ?? ???????????????????????????? ??????????????!") , span_danger("???????????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ?? ???????????????????????????? ??????????????!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ?????????????????? [ru_parse_zone(limb.name)] ?? ???????????????????????????? ??????????????!"))
		victim.emote("agony")
		limb.receive_damage(brute=25, wound_bonus=30)
	else
		user.visible_message(span_danger("<b>[user]</b> ???????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ??????????????????????!") , span_danger("?????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ??????????????????????!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ???????????? ?????? [ru_parse_zone(limb.name)] ??????????????????????!"))
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		malpractice(user)


/datum/wound/blunt/moderate/treat(obj/item/I, mob/user)
	if(victim == user)
		victim.visible_message(span_danger("<b>[user]</b> ???????????????? ?????????????????? [victim.ru_ego()] [ru_parse_zone(limb.name)] ?????????????????? [I].") , span_warning("?????????????? ?????????????????? ???????? [ru_parse_zone(limb.name)] ?????????????????? [I]..."))
	else
		user.visible_message(span_danger("<b>[user]</b> ???????????????? ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ?????????????????? [I].") , span_notice("?????????????? ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b> ?????????????????? [I]..."))

	if(!do_after(user, base_treat_time * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, .proc/still_exists)))
		return

	if(victim == user)
		limb.receive_damage(brute=15, wound_bonus=CANT_WOUND)
		victim.visible_message(span_danger("<b>[user]</b> ?????????????? ?????????????????? [victim.ru_ego()] [ru_parse_zone(limb.name)]!") , span_userdanger("???????????????? ???????? [ru_parse_zone(limb.name)]!"))
	else
		limb.receive_damage(brute=10, wound_bonus=CANT_WOUND)
		user.visible_message(span_danger("<b>[user]</b> ?????????????? ?????????????????? [ru_parse_zone(limb.name)] <b>[victim]</b>!") , span_nicegreen("???????????????? [ru_parse_zone(limb.name)] <b>[victim]</b>!") , victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ?????????????????? ?????? [ru_parse_zone(limb.name)]!"))

	victim.emote("agony")
	qdel(src)

/*
	Severe (Hairline Fracture)
*/

/datum/wound/blunt/severe
	name = "??????????????"
	skloname = "??????????????"
	desc = "?????????? ????????????????, ???????????????????? ?????????????? ???????? ?? ???????????????????? ?????????????????????????????????? ??????????????????????."
	treat_text = "?????????????????????????? ?????????????????????????? ?????????????????????????? ?? ???????????????????? ???????????????? ????????. ?? ???????????????? ???????????????????? ?????????????????? ???????????????????????? ?????????????????????????? ?????????????????????? ?????? ???????????????????????????? ?????????????????? ????????????????."
	examine_desc = "?????????????? ???????????????????? ?? ???????????? ??????????????"
	occur_text = "?????????????????????????? ?????????????? ???????????? ?? ?????????????????? ???????????????????? ???? ?????? ??????????"

	severity = WOUND_SEVERITY_SEVERE
	interaction_efficiency_penalty = 2
	limp_slowdown = 6
	internal_bleeding_chance = 30
	internal_bleeding_coefficient = 1.2
	threshold_minimum = 60
	threshold_penalty = 30
	treatable_by = list(/obj/item/stack/sticky_tape/surgical, /obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/severe
	scar_keyword = "bluntsevere"
	brain_trauma_group = BRAIN_TRAUMA_MILD
	trauma_cycle_cooldown = 1.5 MINUTES
	internal_bleeding_chance = 40
	wound_flags = (BONE_WOUND | ACCEPTS_GAUZE | MANGLES_BONE)
	regen_ticks_needed = 120 // ticks every 2 seconds, 240 seconds, so roughly 4 minutes default

/// Compound Fracture (Critical Blunt)
/datum/wound/blunt/critical
	name = "??????????????"
	skloname = "????????????????"
	desc = "?????????? ???????????????? ?????????????????? ??????????????."
	treat_text = "?????????????????????? ???????????????? ???????????????????? ???????????????????? ?? ?????????????????????? ?????????????????????????? ????????????????????????????."
	examine_desc = "?????????? ???????????????? ???? ?????? ??????????"
	occur_text = "?????????????? ???? ??????????, ???????????????? ?????????????????? ?????????? ????????????"

	severity = WOUND_SEVERITY_CRITICAL
	interaction_efficiency_penalty = 4
	limp_slowdown = 9
	sound_effect = 'sound/effects/wounds/crack2.ogg'
	internal_bleeding_chance = 35
	internal_bleeding_coefficient = 1.5
	threshold_minimum = 115
	threshold_penalty = 50
	disabling = TRUE
	treatable_by = list(/obj/item/stack/sticky_tape/surgical, /obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/critical
	scar_keyword = "bluntcritical"
	brain_trauma_group = BRAIN_TRAUMA_SEVERE
	trauma_cycle_cooldown = 2.5 MINUTES
	internal_bleeding_chance = 60
	wound_flags = (BONE_WOUND | ACCEPTS_GAUZE | MANGLES_BONE)
	regen_ticks_needed = 240 // ticks every 2 seconds, 480 seconds, so roughly 8 minutes default

// doesn't make much sense for "a" bone to stick out of your head
/datum/wound/blunt/critical/apply_wound(obj/item/bodypart/L, silent, datum/wound/old_wound, smited)
	if(L.body_zone == BODY_ZONE_HEAD)
		occur_text = "??????????????, ?????????????? ???????????????????? ?????????? ???????????? ?????????? ?? ??????????"
		examine_desc = "?????????? ?????????????????? ????????????, ?? ?????????????????? ?????????????? ????????????"
	. = ..()

/// if someone is using bone gel on our wound
/datum/wound/blunt/proc/gel(obj/item/stack/medical/bone_gel/I, mob/user)
	if(gelled)
		to_chat(user, span_warning("[capitalize(limb.name)] [user == victim ? " " : "<b>[victim]</b> "] ?????? ?????????????? ?????????????? ??????????!"))
		return

	user.visible_message(span_danger("<b>[user]</b> ???????????????? ???????????????????? [I] ???? [ru_parse_zone(limb.name)] <b>[victim]</b>...") , span_warning("?????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] [user == victim ? " " : "<b>[victim]</b> "], ?????????????????? ???????????????????????????? ???? ????????????????..."))

	if(!do_after(user, base_treat_time * 1.5 * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, .proc/still_exists)))
		return

	I.use(1)
	victim.emote("agony")
	if(user != victim)
		user.visible_message(span_notice("<b>[user]</b> ?????????????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] <b>[victim]</b>, ?????????????? ?????????????? ????????!") , span_notice("???????????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] <b>[victim]</b>!") , ignored_mobs=victim)
		to_chat(victim, span_userdanger("<b>[user]</b> ?????????????????????? ?????????????????? [I] ???? ?????? [ru_parse_zone(limb.name)] ?? ?? ?????????????? ??????????????????????, ?????? ?????? ?????????? ???????????????????? ???? ????????, ?????????? ?????? ???????????????? ?????????? ?? ??????????????????????????????????!"))
	else
		var/painkiller_bonus = 0
		if(victim.drunkenness > 10)
			painkiller_bonus += 10
		if(victim.reagents.has_reagent(/datum/reagent/medicine/morphine))
			painkiller_bonus += 20
		if(victim.reagents.has_reagent(/datum/reagent/determination))
			painkiller_bonus += 10
		if(victim.reagents.has_reagent(/datum/reagent/consumable/ethanol/painkiller))
			painkiller_bonus += 5
		if(victim.reagents.has_reagent(/datum/reagent/medicine/mine_salve))
			painkiller_bonus += 20

		if(prob(25 + (20 * (severity - 2)) - painkiller_bonus)) // 25%/45% chance to fail self-applying with severe and critical wounds, modded by painkillers
			victim.visible_message(span_danger("<b>[victim]</b> ?????????????????????? ?????????????? ?????????????? [I] ???? [victim.ru_ego()] [ru_parse_zone(limb.name)], ?????????? ???????????????? ???? ????????!") , span_notice("?????????? ???????????????? ???? ???????? ?????????????? ?????????????????? [I] ???? ?????? [ru_parse_zone(limb.name)] ?????????? ?????? ?????? ??????????????????!"))
			victim.AdjustUnconscious(5 SECONDS)
			return
		victim.visible_message(span_notice("<b>[victim]</b> ?????????????? ?????????????????? [I] ???? [victim.ru_ego()] [ru_parse_zone(limb.name)], ?????????????????????? ???? ????????!") , span_notice("???????????????????? ?????????????????? [I] ???? ?????? [ru_parse_zone(limb.name)], ???????????????? ?????????????????????? ???????????? ????????!"))

	limb.receive_damage(25, stamina=100, wound_bonus=CANT_WOUND)
	if(!gelled)
		gelled = TRUE

/// if someone is using surgical tape on our wound
/datum/wound/blunt/proc/tape(obj/item/stack/sticky_tape/surgical/I, mob/user)
	if(!gelled)
		to_chat(user, span_warning("[capitalize(limb.name)] [user == victim ? " " : "<b>[victim]</b> "] ???????????? ???????? ???????????? ?????????????? ?????????? ?????? ???????????????????? ???????? ???????????????????? ????????????????!"))
		return
	if(taped)
		to_chat(user, span_warning("[capitalize(limb.name)] [user == victim ? " " : "<b>[victim]</b> "] ?????? ???????????????? ?? [I.name] ?? ??????????????????????????!"))
		return

	user.visible_message(span_danger("<b>[user]</b> ???????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] <b>[victim]</b>...") , span_warning("?????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] [user == victim ? " " : "<b>[victim]</b> "]..."))

	if(!do_after(user, base_treat_time * (user == victim ? 1.5 : 1), target = victim, extra_checks=CALLBACK(src, .proc/still_exists)))
		return

	if(victim == user)
		regen_ticks_needed *= 1.5

	I.use(1)
	if(user != victim)
		user.visible_message(span_notice("<b>[user]</b> ?????????????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] <b>[victim]</b>, ?????????????? ?????????????? ????????!") , span_notice("???????????????????? ?????????????????? [I] ???? [ru_parse_zone(limb.name)] <b>[victim]</b>!") , ignored_mobs=victim)
		to_chat(victim, span_green("<b>[user]</b> ?????????????????????? ?????????????????? [I] ???? ?????? [ru_parse_zone(limb.name)], ?????????? ?????????????? ?????????????????????? ?????? ?????? ?????????? ??????????????????????????!"))
	else
		victim.visible_message(span_notice("<b>[victim]</b> ?????????????????????? ?????????????????? [I] ???? [victim.ru_ego()] [ru_parse_zone(limb.name)], !") , span_green("???????????????????? ?????????????????? [I] ???? ?????? [ru_parse_zone(limb.name)], ?????????? ?????????????? ?????????????????????? ?????? ?????? ?????????? ??????????????????????????!"))

	taped = TRUE
	processes = TRUE

/datum/wound/blunt/treat(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/medical/bone_gel))
		gel(I, user)
	else if(istype(I, /obj/item/stack/sticky_tape/surgical))
		tape(I, user)

/datum/wound/blunt/get_scanner_description(mob/user)
	. = ..()

	. += "<div class='ml-3'>"

	if(!gelled)
		. += "???????????????????????????? ??????????????: ???????????????? ?????????????? ???????? ?????????????????????????????? ???? ???????????????????????? ????????????????????, ?????????? ???????????????? ?????????????????????????? ??????????, ?????????? ???????????? ?????????????????????? ??????????. ?????? ???????????????????? ???????????? ?? ????????????????, ?? ?????????????????????????? ???????????? ?? ?????????????? ??????????????????????????????.\n"
	else if(!taped)
		. += "<span class='notice'>???????????????????? ???????????????????????????? ??????????????: ???????????????? ?????????????????????????? ?????????? ?????????????????????????????? ???? ???????????????????????? ????????????????????, ?????????? ???????????? ?????????????????????? ??????????. ???????????????? ????????????????, ?????? ???????????????????????? ???????????????????? ???????????? ?? ????????????????.</span>\n"
	else
		. += "<span class='notice'>??????????????: ?????????????????????? ???????????? ?? ????????????????. ?????????? ???????????????????????????? ???? [round(regen_ticks_current*100/regen_ticks_needed)]%.</span>\n"

	if(limb.body_zone == BODY_ZONE_HEAD)
		. += "???????????????????? ??????????????-???????????????? ????????????: ?????????????? ?????????? ???????????????? ???? ?????????????????? ?????????????????? [severity == WOUND_SEVERITY_SEVERE ? "????????????????????????????" : "??????????????????"] ?????????? ?????????????????? ??????????, ???????? ?????????? ???? ?????????? ??????????????????????????."
	else if(limb.body_zone == BODY_ZONE_CHEST && victim.blood_volume)
		. += "???????????????????? ???????????? ?????????????? ????????????: ???????????????????? ?????????????????????? ?????????? ?????????? ?????????????? ???????????????????? ????????????????????????, ???????? ???? ?????????? ?????????????????????????? ??????????."
	. += "</div>"
