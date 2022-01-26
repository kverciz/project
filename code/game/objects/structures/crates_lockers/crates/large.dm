/obj/structure/closet/crate/large
	name = "большой ящик"
	desc = "Огромный деревянный ящик. Вам понадобится лом, чтобы открыть его."
	icon_state = "largecrate"
	density = TRUE
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	delivery_icon = "deliverybox"
	integrity_failure = 0 //Makes the crate break when integrity reaches 0, instead of opening and becoming an invisible sprite.
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50

	// Stops people from "diving into" a crate you can't open normally
	divable = FALSE

/obj/structure/closet/crate/large/attack_hand(mob/user)
	add_fingerprint(user)
	if(manifest)
		tear_manifest(user)
	else
		to_chat(user, span_warning("Мне нужен лом, чтобы открыть это!"))

/obj/structure/closet/crate/large/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_CROWBAR)
		if(manifest)
			tear_manifest(user)

		user.visible_message(span_notice("[user] открываю <b>[src.name]</b> теперь открыт.") , \
			span_notice("Открываю <b>[src.name]</b>.") , \
			span_hear("Слышу треск дерева."))
		playsound(src.loc, 'sound/weapons/slashmiss.ogg', 75, TRUE)

		var/turf/T = get_turf(src)
		for(var/i in 1 to material_drop_amount)
			new material_drop(src)
		for(var/atom/movable/AM in contents)
			AM.forceMove(T)

		qdel(src)

	else
		if(user.a_intent == INTENT_HARM)	//Only return  ..() if intent is harm, otherwise return 0 or just end it.
			return ..()						//Stops it from opening and turning invisible when items are used on it.

		else
			to_chat(user, span_warning("Мне нужен лом, чтобы открыть это!"))
			return FALSE //Just stop. Do nothing. Don't turn into an invisible sprite. Don't open like a locker.
					//The large crate has no non-attack interactions other than the crowbar, anyway.