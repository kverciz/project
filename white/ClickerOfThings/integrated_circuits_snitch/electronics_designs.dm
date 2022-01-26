/datum/design/integrated_printer
	name = "Integrated circuit printer"
	desc = "This machine provides all necessary things for circuitry."
	id = "icprinter"
	build_type = PROTOLATHE
	materials = list(/datum/material/glass = 5000, /datum/material/iron = 10000)
	build_path = /obj/item/integrated_circuit_printer
	category = list("Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/IC_printer_upgrade_advanced
	name = "Integrated circuit printer upgrade: Advanced Designs"
	desc = "This disk allows for integrated circuit printers to print advanced circuitry designs."
	id = "icupgadv"
	build_type = PROTOLATHE
	materials = list(/datum/material/glass = 10000, /datum/material/iron = 10000)
	build_path = /obj/item/disk/integrated_circuit_old/upgrade/advanced
	category = list("Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/IC_printer_upgrade_clone
	name = "Integrated circuit printer upgrade: Instant Cloning"
	desc = "This disk allows for integrated circuit printers to clone designs instantaneously."
	id = "icupgclo"
	build_type = PROTOLATHE
	materials = list(/datum/material/glass = 10000, /datum/material/iron = 10000)
	build_path = /obj/item/disk/integrated_circuit_old/upgrade/clone
	category = list("Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE
