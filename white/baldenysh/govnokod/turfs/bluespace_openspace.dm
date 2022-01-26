/turf/open/openspace/bluespace
	name = "голубое пространство"
	desc = "голубое"
	icon = 'white/baldenysh/icons/turf/bluespace_openspace.dmi'
	icon_state = "transparent"
	smoothing_flags = SMOOTH_CORNERS | SMOOTH_BORDER
	canSmoothWith = list(SMOOTH_GROUP_BLUESPACE_OPENSPACE)
	smoothing_groups = list(SMOOTH_GROUP_BLUESPACE_OPENSPACE)
	baseturfs = /turf/open/floor/plating
	CanAtmosPassVertical = ATMOS_PASS_YES
	can_cover_up = FALSE
	can_build_on = FALSE
	requires_activation = TRUE

	var/list/fall_proctected = list()
	var/instability = 0

/turf/open/openspace/bluespace/LateInitialize()
	spawn(5 SECONDS)
		AddElement(/datum/element/turf_z_transparency, TRUE)

/turf/open/openspace/bluespace/process()
	instability++

	if(instability >= 30 && prob(instability/5))
		collapse()
		return PROCESS_KILL

/turf/open/openspace/bluespace/Destroy()
	close_rift()
	return ..()

/turf/open/openspace/bluespace/proc/start_collapse()
	START_PROCESSING(SSobj, src)

/turf/open/openspace/bluespace/proc/stop_collapse()
	if(!instability)
		return

	STOP_PROCESSING(SSobj, src)
	instability = 0

/turf/open/openspace/bluespace/proc/rift(turf/below)
	if(!below)
		return FALSE

	if(below_override)
		close_rift()

	below.above_override = src
	below_override = below
	if(istype(below, /turf/open))
		if(isopenspace(below) || isspaceturf(below))
			return FALSE
		below_override.CanAtmosPassVertical = ATMOS_PASS_YES

	return TRUE

/turf/open/openspace/bluespace/proc/close_rift()
	if(!below_override)
		return

	below_override.above_override = null
	below_override.CanAtmosPassVertical = initial(below_override.CanAtmosPassVertical)

	below_override = null

/turf/open/openspace/bluespace/proc/collapse()
	close_rift()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/openspace/bluespace/zPassOut(atom/movable/A, direction, turf/destination)
	. = ..()
	if(A.type in fall_proctected)
		return FALSE
	if(below_override)
		for(var/obj/O in below_override.contents)
			if(O.density)
				return FALSE

/turf/open/openspace/bluespace/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return TRUE

/turf/open/openspace/bluespace/debug
	name = "прикольное голубое пространство"

/turf/open/openspace/bluespace/debug/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, NORTH), NORTH))
	rift(below)

/turf/open/openspace/bluespace/reverse
	name = "реверсивное прикольное голубое пространство"

/turf/open/openspace/bluespace/reverse/Initialize()
	..()

	var/turf/below = get_turf(get_step(get_step(src, SOUTH), SOUTH))
	rift(below)
