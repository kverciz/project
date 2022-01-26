/obj/item/computer_hardware/hard_drive/portable
	name = "Диск с данными"
	desc = "Съёмный диск, используемый для хранения данных."
	power_usage = 10
	icon_state = "datadisk6"
	w_class = WEIGHT_CLASS_TINY
	critical = FALSE
	max_capacity = 16
	device_type = MC_SDD

/obj/item/computer_hardware/hard_drive/portable/on_remove(obj/item/modular_computer/MC, mob/user)
	return //this is a floppy disk, let's not shut the computer down when it gets pulled out.

/obj/item/computer_hardware/hard_drive/portable/install_default_programs()
	return // Empty by default

/obj/item/computer_hardware/hard_drive/portable/advanced
	name = "Усовершенствованный диск с данными"
	power_usage = 20
	icon_state = "datadisk5"
	max_capacity = 64

/obj/item/computer_hardware/hard_drive/portable/super
	name = "Супердиск с данными"
	desc = "Съёмный диск, используемый для хранения больших объёмов данных."
	power_usage = 40
	icon_state = "datadisk3"
	max_capacity = 256
