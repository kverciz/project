/obj/item/airlock_painter
	name = "маркировщик шлюзов"
	desc = "An advanced autopainter preprogrammed with several paintjobs for airlocks. Use it on an airlock during or after construction to change the paintjob."
	icon = 'icons/obj/objects.dmi'
	icon_state = "paint sprayer"
	inhand_icon_state = "paint sprayer"
	worn_icon_state = "painter"
	w_class = WEIGHT_CLASS_SMALL

	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)

	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	usesound = 'sound/effects/spray2.ogg'

	var/obj/item/toner/ink = null
	/// Associate list of all paint jobs the airlock painter can apply. The key is the name of the airlock the user will see. The value is the type path of the airlock
	var/list/available_paint_jobs = list(
		"Public" = /obj/machinery/door/airlock/public,
		"Engineering" = /obj/machinery/door/airlock/engineering,
		"Atmospherics" = /obj/machinery/door/airlock/atmos,
		"Security" = /obj/machinery/door/airlock/security,
		"Command" = /obj/machinery/door/airlock/command,
		"Medical" = /obj/machinery/door/airlock/medical,
		"Research" = /obj/machinery/door/airlock/research,
		"Freezer" = /obj/machinery/door/airlock/freezer,
		"Science" = /obj/machinery/door/airlock/science,
		"Mining" = /obj/machinery/door/airlock/mining,
		"Maintenance" = /obj/machinery/door/airlock/maintenance,
		"External" = /obj/machinery/door/airlock/external,
		"External Maintenance"= /obj/machinery/door/airlock/maintenance/external,
		"Virology" = /obj/machinery/door/airlock/virology,
		"Standard" = /obj/machinery/door/airlock
	)

/obj/item/airlock_painter/Initialize()
	. = ..()
	ink = new /obj/item/toner(src)

//This proc doesn't just check if the painter can be used, but also uses it.
//Only call this if you are certain that the painter will be used right after this check!
/obj/item/airlock_painter/proc/use_paint(mob/user)
	if(can_use(user))
		ink.charges--
		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE)
		return TRUE
	else
		return FALSE

//This proc only checks if the painter can be used.
//Call this if you don't want the painter to be used right after this check, for example
//because you're expecting user input.
/obj/item/airlock_painter/proc/can_use(mob/user)
	if(!ink)
		to_chat(user, span_warning("There is no toner cartridge installed in [src]!"))
		return FALSE
	else if(ink.charges < 1)
		to_chat(user, span_warning("[capitalize(src.name)] is out of ink!"))
		return FALSE
	else
		return TRUE

/obj/item/airlock_painter/suicide_act(mob/user)
	var/obj/item/organ/lungs/L = user.getorganslot(ORGAN_SLOT_LUNGS)

	if(can_use(user) && L)
		user.visible_message(span_suicide("[user] is inhaling toner from [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
		use(user)

		// Once you've inhaled the toner, you throw up your lungs
		// and then die.

		// Find out if there is an open turf in front of us,
		// and if not, pick the turf we are standing on.
		var/turf/T = get_step(get_turf(src), user.dir)
		if(!isopenturf(T))
			T = get_turf(src)

		// they managed to lose their lungs between then and
		// now. Good job.
		if(!L)
			return OXYLOSS

		L.Remove(user)

		// make some colorful reagent, and apply it to the lungs
		L.create_reagents(10)
		L.reagents.add_reagent(/datum/reagent/colorful_reagent, 10)
		L.reagents.expose(L, TOUCH, 1)

		// TODO maybe add some colorful vomit?

		user.visible_message(span_suicide("[user] vomits out [user.ru_ego()] [L]!"))
		playsound(user.loc, 'sound/effects/splat.ogg', 50, TRUE)

		L.forceMove(T)

		return (TOXLOSS|OXYLOSS)
	else if(can_use(user) && !L)
		user.visible_message(span_suicide("[user] is spraying toner on [user.ru_na()]self from [src]! It looks like [user.p_theyre()] trying to commit suicide."))
		user.reagents.add_reagent(/datum/reagent/colorful_reagent, 1)
		user.reagents.expose(user, TOUCH, 1)
		return TOXLOSS

	else
		user.visible_message(span_suicide("[user] пытается inhale toner from [src]! It might be a suicide attempt if [src] had any toner."))
		return SHAME


/obj/item/airlock_painter/examine(mob/user)
	. = ..()
	if(!ink)
		. += "<hr><span class='notice'>It doesn't have a toner cartridge installed.</span>"
		return
	var/ink_level = "high"
	if(ink.charges < 1)
		ink_level = "empty"
	else if((ink.charges/ink.max_charges) <= 0.25) //25%
		ink_level = "low"
	else if((ink.charges/ink.max_charges) > 1) //Over 100% (admin var edit)
		ink_level = "dangerously high"
	. += "<hr><span class='notice'>Its ink levels look [ink_level].</span>"


/obj/item/airlock_painter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/toner))
		if(ink)
			to_chat(user, span_warning("[capitalize(src.name)] already contains \a [ink]!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		to_chat(user, span_notice("You install [W] into [src]."))
		ink = W
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	else
		return ..()

/obj/item/airlock_painter/attack_self(mob/user)
	if(ink)
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
		ink.forceMove(user.drop_location())
		user.put_in_hands(ink)
		to_chat(user, span_notice("You remove [ink] from [src]."))
		ink = null

/obj/item/airlock_painter/decal
	name = "маркировщик пола"
	desc = "Создает разметку на полу. ПКМ для смены дизайна."
	icon = 'icons/obj/objects.dmi'
	icon_state = "decal_sprayer"
	inhand_icon_state = "decalsprayer"
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=50)
	var/stored_dir = 2
	var/stored_color = ""
	var/stored_decal = "warningline"
	var/stored_decal_total = "warningline"
	var/color_list = list("","red","white")
	var/dir_list = list(1,2,4,8)
	var/decal_list = list(list("Warning Line","warningline"),
			list("Warning Line Corner","warninglinecorner"),
			list("Caution Label","caution"),
			list("Directional Arrows","arrows"),
			list("Stand Clear Label","stand_clear"),
			list("Box","box"),
			list("Box Corner","box_corners"),
			list("Delivery Marker","delivery"),
			list("Warning Box","warn_full"))

/obj/item/airlock_painter/decal/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/turf/open/floor/F = target
	if(!proximity)
		to_chat(user, span_notice("You need to get closer!"))
		return
	if(use_paint(user) && isturf(F))
		F.AddElement(/datum/element/decal, 'icons/turf/decals.dmi', stored_decal_total, stored_dir, null, null, alpha, color, null, CLEAN_TYPE_PAINT, null)

/obj/item/airlock_painter/decal/AltClick(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/airlock_painter/decal/Initialize()
	. = ..()
	ink = new /obj/item/toner/large(src)

/obj/item/airlock_painter/decal/proc/update_decal_path()
	var/yellow_fix = "" //This will have to do until someone refactor's markings.dm
	if (stored_color)
		yellow_fix = "_"
	stored_decal_total = "[stored_decal][yellow_fix][stored_color]"
	return

/obj/item/airlock_painter/decal/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DecalPainter", name)
		ui.open()

/obj/item/airlock_painter/decal/ui_data(mob/user)
	var/list/data = list()
	data["decal_direction"] = stored_dir
	data["decal_color"] = stored_color
	data["decal_style"] = stored_decal
	data["decal_list"] = list()
	data["color_list"] = list()
	data["dir_list"] = list()

	for(var/i in decal_list)
		data["decal_list"] += list(list(
			"name" = i[1],
			"decal" = i[2]
		))
	for(var/j in color_list)
		data["color_list"] += list(list(
			"colors" = j
		))
	for(var/k in dir_list)
		data["dir_list"] += list(list(
			"dirs" = k
		))
	return data

/obj/item/airlock_painter/decal/ui_act(action,list/params)
	. = ..()
	if(.)
		return

	switch(action)
		//Lists of decals and designs
		if("select decal")
			var/selected_decal = params["decals"]
			stored_decal = selected_decal
		if("select color")
			var/selected_color = params["colors"]
			stored_color = selected_color
		if("selected direction")
			var/selected_direction = text2num(params["dirs"])
			stored_dir = selected_direction
	update_decal_path()
	. = TRUE

/obj/item/airlock_painter/decal/debug
	name = "extreme decal painter"
	icon_state = "decal_sprayer_ex"

/obj/item/airlock_painter/decal/debug/Initialize()
	. = ..()
	ink = new /obj/item/toner/extreme(src)

// Floor painter
/obj/item/floor_painter
	name = "полокрас"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "floor_sprayer"
	desc = "Используется для покраски полов. Круто?."

	var/floor_icon
	var/floor_state = "floor"
	var/floor_dir = SOUTH

	worn_icon_state = "electronic"

	var/static/list/star_directions = list("north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest")
	var/static/list/cardinal_directions = list("north", "east", "south", "west")
	var/list/allowed_directions = list("south")

	var/static/list/allowed_states = list(
		"floor", "white", "cafeteria", "whitehall", "whitecorner", "stairs-old",
		"stairs", "stairs-l", "stairs-m", "stairs-r", "grimy", "yellowsiding",
		"yellowcornersiding", "chapel", "pinkblack", "darkfull", "checker",
		"dark", "darkcorner", "solarpanel", "freezerfloor", "showroomfloor","elevatorshaft",
		"recharge_floor", "sepia"
		)

/obj/item/floor_painter/afterattack(atom/A, mob/user, proximity, params)
	if(!proximity)
		return

	var/turf/open/floor/plasteel/F = A
	if(!istype(F))
		to_chat(user, span_warning("\The [src] can only be used on station flooring."))
		return

	if(F.dir == floor_dir && F.icon_state == floor_state && F.base_icon_state == floor_state)
		return //No point wasting ink

	F.icon_state = floor_state
	F.base_icon_state = floor_state
	F.dir = floor_dir
	playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE)

/obj/item/floor_painter/attack_self(mob/user)
	if(!user)
		return FALSE
	user.set_machine(src)
	interact(user)
	return TRUE

/obj/item/floor_painter/interact(mob/user as mob) //TODO: Make TGUI for this because ouch
	if(!floor_icon)
		floor_icon = icon('icons/turf/floors.dmi', floor_state, floor_dir)
	user << browse_rsc(floor_icon, "floor.png")
	var/dat = {"
		<center>
			<img style="-ms-interpolation-mode: nearest-neighbor;" src="floor.png" width=128 height=128 border=4>
		</center>
		<center>
			<a href="?src=[REF(src)];cycleleft=1">&lt;-</a>
			<a href="?src=[REF(src)];choose_state=1">Choose Style</a>
			<a href="?src=[REF(src)];cycleright=1">-&gt;</a>
		</center>
		<div class='statusDisplay'>Style: [floor_state]</div>
		<center>
			<a href="?src=[REF(src)];cycledirleft=1">&lt;-</a>
			<a href="?src=[REF(src)];choose_dir=1">Choose Direction</a>
			<a href="?src=[REF(src)];cycledirright=1">-&gt;</a>
		</center>
		<div class='statusDisplay'>Direction: [dir2ru_text(floor_dir)]</div>
	"}

	var/datum/browser/popup = new(user, "floor_painter", name, 225, 300)
	popup.set_content(dat)
	popup.open()

/obj/item/floor_painter/Topic(href, href_list)
	if(..())
		return

	if(href_list["choose_state"])
		var/state = input("Please select a style", "[src]") as null|anything in allowed_states
		if(state)
			floor_state = state
			check_directional_tile()
	if(href_list["choose_dir"])
		var/seldir = input("Please select a direction", "[src]") as null|anything in allowed_directions
		if(seldir)
			floor_dir = text2dir(seldir)
	if(href_list["cycledirleft"])
		var/index = allowed_directions.Find(dir2text(floor_dir))
		index--
		if(index < 1)
			index = allowed_directions.len
		floor_dir = text2dir(allowed_directions[index])
	if(href_list["cycledirright"])
		var/index = allowed_directions.Find(dir2text(floor_dir))
		index++
		if(index > allowed_directions.len)
			index = 1
		floor_dir = text2dir(allowed_directions[index])
	if(href_list["cycleleft"])
		var/index = allowed_states.Find(floor_state)
		index--
		if(index < 1)
			index = allowed_states.len
		floor_state = allowed_states[index]
		check_directional_tile()
	if(href_list["cycleright"])
		var/index = allowed_states.Find(floor_state)
		index++
		if(index > allowed_states.len)
			index = 1
		floor_state = allowed_states[index]
		check_directional_tile()

	floor_icon = icon('icons/turf/floors.dmi', floor_state, floor_dir)
	if(usr)
		attack_self(usr)

/obj/item/floor_painter/proc/check_directional_tile()
	var/icon/current = icon('icons/turf/floors.dmi', floor_state, NORTHWEST)
	if(current.GetPixel(1,1) != null)
		allowed_directions = star_directions
	else
		current = icon('icons/turf/floors.dmi', floor_state, WEST)
		if(current.GetPixel(1,1) != null)
			allowed_directions = cardinal_directions
		else
			allowed_directions = list("south")

	if(!(dir2text(floor_dir) in allowed_directions))
		floor_dir = SOUTH
