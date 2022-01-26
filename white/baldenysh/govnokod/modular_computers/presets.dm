/obj/item/modular_computer/laptop/preset/medical
	desc = "Специализированный ноутбук, использующийся медперсоналом в своей работе."

/obj/item/modular_computer/laptop/preset/medical/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/surgmaster())
	hard_drive.store_file(new/datum/computer_file/program/radar/lifeline())
