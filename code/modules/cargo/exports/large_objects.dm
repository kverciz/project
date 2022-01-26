/datum/export/large/crate
	cost = CARGO_CRATE_VALUE
	k_elasticity = 0
	unit_name = "ящик"
	export_types = list(/obj/structure/closet/crate)
	exclude_types = list(/obj/structure/closet/crate/large, /obj/structure/closet/crate/wooden, /obj/structure/closet/crate/mail)

/datum/export/large/crate/total_printout(datum/export_report/ex, notes = TRUE) // That's why a goddamn metal crate costs that much.
	. = ..()
	if(. && notes)
		. += " Благодарим за участие в программе переработки ящиков НТ."

/datum/export/large/crate/wooden
	cost = CARGO_CRATE_VALUE/5
	unit_name = "большой деревянный ящик"
	export_types = list(/obj/structure/closet/crate/large)
	exclude_types = list()

/datum/export/large/crate/wooden/ore
	unit_name = "ящик для руды"
	export_types = list(/obj/structure/ore_box)

/datum/export/large/crate/wood
	cost = CARGO_CRATE_VALUE * 0.48
	unit_name = "деревянный ящик"
	export_types = list(/obj/structure/closet/crate/wooden)
	exclude_types = list()

/datum/export/large/crate/coffin
	cost = CARGO_CRATE_VALUE/2 //50 wooden crates cost 2000 points, and you can make 10 coffins in seconds with those planks. Each coffin selling for 250 means you can make a net gain of 500 points for wasting your time making coffins.
	unit_name = "гроб"
	export_types = list(/obj/structure/closet/crate/coffin)

/datum/export/large/reagent_dispenser
	cost = CARGO_CRATE_VALUE * 0.5 // +0-400 depending on amount of reagents left
	var/contents_cost = 4

/datum/export/large/reagent_dispenser/get_cost(obj/O)
	var/obj/structure/reagent_dispensers/D = O
	var/ratio = D.reagents.total_volume / D.reagents.maximum_volume

	return ..() + round(contents_cost * ratio)

/datum/export/large/reagent_dispenser/water
	unit_name = "канистра с водой"
	export_types = list(/obj/structure/reagent_dispensers/watertank)
	contents_cost = 2

/datum/export/large/reagent_dispenser/fuel
	unit_name = "канистра с топливом"
	export_types = list(/obj/structure/reagent_dispensers/fueltank)

/datum/export/large/reagent_dispenser/beer
	unit_name = "пивной бачок"
	contents_cost = CARGO_CRATE_VALUE * 3.5
	export_types = list(/obj/structure/reagent_dispensers/beerkeg)


/datum/export/large/pipedispenser
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "Диспенсер труб"
	export_types = list(/obj/machinery/pipedispenser)

/datum/export/large/emitter
	cost = CARGO_CRATE_VALUE * 2.75
	unit_name = "эмиттер"
	export_types = list(/obj/machinery/power/emitter)

/datum/export/large/field_generator
	cost = CARGO_CRATE_VALUE * 2.75
	unit_name = "генератор поля"
	export_types = list(/obj/machinery/field/generator)

/datum/export/large/collector
	cost = CARGO_CRATE_VALUE * 2
	unit_name = "коллектор радиации"
	export_types = list(/obj/machinery/power/rad_collector)

/datum/export/large/tesla_coil
	cost = CARGO_CRATE_VALUE * 2.25
	unit_name = "катушка тесла"
	export_types = list(/obj/machinery/power/tesla_coil)

/datum/export/large/pa
	cost = CARGO_CRATE_VALUE * 3
	unit_name = "часть ускорителя частиц"
	export_types = list(/obj/structure/particle_accelerator)

/datum/export/large/pa/controls
	cost = CARGO_CRATE_VALUE * 5
	unit_name = "консоль ускорителя частиц"
	export_types = list(/obj/machinery/particle_accelerator/control_box)

/datum/export/large/supermatter
	cost = CARGO_CRATE_VALUE * 16
	unit_name = "осколок суперматерии"
	export_types = list(/obj/machinery/power/supermatter_crystal/shard)

/datum/export/large/grounding_rod
	cost = CARGO_CRATE_VALUE * 1.2
	unit_name = "заземлитель"
	export_types = list(/obj/machinery/power/grounding_rod)

/datum/export/large/tesla_gen
	cost = CARGO_CRATE_VALUE * 4
	unit_name = "генератор теслы"
	export_types = list(/obj/machinery/the_singularitygen/tesla)

/datum/export/large/singulo_gen
	cost = CARGO_CRATE_VALUE * 4
	unit_name = "генератор сингулярности"
	export_types = list(/obj/machinery/the_singularitygen)
	include_subtypes = FALSE

/datum/export/large/iv
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "капельница"
	export_types = list(/obj/machinery/iv_drip)

/datum/export/large/barrier
	cost = CARGO_CRATE_VALUE * 0.25
	unit_name = "защитный барьер"
	export_types = list(/obj/item/grenade/barrier, /obj/structure/barricade/security)

/datum/export/large/gas_canister
	cost = CARGO_CRATE_VALUE * 0.05 //Base cost of canister. You get more for nice gases inside.
	unit_name = "Канистра с газом"
	export_types = list(/obj/machinery/portable_atmospherics/canister)
	k_elasticity = 0.00033

/datum/export/large/gas_canister/get_cost(obj/O)
	var/obj/machinery/portable_atmospherics/canister/C = O
	var/worth = 10

	worth += C.air_contents.get_moles(/datum/gas/bz)*1
	worth += C.air_contents.get_moles(/datum/gas/stimulum)*100
	worth += C.air_contents.get_moles(/datum/gas/hypernoblium)*5
	worth += C.air_contents.get_moles(/datum/gas/miasma)*2
	worth += C.air_contents.get_moles(/datum/gas/tritium)*5
	worth += C.air_contents.get_moles(/datum/gas/pluoxium)*5
	worth += C.air_contents.get_moles(/datum/gas/freon)*15
	worth += C.air_contents.get_moles(/datum/gas/hydrogen)*1
	worth += C.air_contents.get_moles(/datum/gas/healium)*19
	worth += C.air_contents.get_moles(/datum/gas/proto_nitrate)*5
	worth += C.air_contents.get_moles(/datum/gas/zauker)*1050
	worth += C.air_contents.get_moles(/datum/gas/halon)*9
	worth += C.air_contents.get_moles(/datum/gas/helium)*6
	worth += C.air_contents.get_moles(/datum/gas/antinoblium)*10
	return worth
