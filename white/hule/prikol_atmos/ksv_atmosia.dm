/datum/map_template/shuttle/atmosia
	name = "KSV Atmosia"
	prefix = "white/hule/prikol_atmos/"
	port_id = "ksv_atmosia"
	suffix = "b"

///////////////////////////////////////////////////////

/area/shuttle/atmosia
	name = "KSV Atmosia Bridge"
	ambientsounds = ENGINEERING
	requires_power = TRUE
	flags_1 = NONE

/area/shuttle/atmosia/atmos
	name = "KSV Atmosia Atmospherics"
	icon_state = "atmos"

/area/shuttle/atmosia/engine
	name = "KSV Atmosia Engine"
	icon_state = "atmos_engine"

//////////////////////////////////////////////////////

/obj/machinery/computer/shuttle_flight/atmosia
	name = "KSV Atmosia console"
	shuttleId = "ksv_atmosia"
	possible_destinations = "ksv_atmosia_custom;ksv_atmosia_home"

/obj/docking_port/mobile/atmosia
	name = "KSV Atmosia"
	id = "ksv_atmosia"
	dir = 2
	port_direction = 1
	width = 19
	dwidth = 9
	height = 28
	dheight = 1
	movement_force = list("KNOCKDOWN" = 10, "THROW" = 20)
	engine_coeff = 6
	rechargeTime = 10 MINUTES

/obj/docking_port/stationary/atmosia
	name = "KSV Atmosia Home"
	id = "ksv_atmosia_home"
	roundstart_template = /datum/map_template/shuttle/atmosia
	dir = 2
	width = 19
	dwidth = 9
	height = 28
	dheight = 1

/obj/docking_port/stationary/atmosia/hohlostan
	name = "KSV Atmosia Hohlostan"
	id = "ksv_atmosia_hohlostan"
	roundstart_template = null
	dir = 2
	width = 19
	dwidth = 9
	height = 28
	dheight = 1
