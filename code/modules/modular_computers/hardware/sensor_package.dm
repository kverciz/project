//This item doesn't do much on its own, but is required by apps such as AtmoZphere.
/obj/item/computer_hardware/sensorpackage
	name = "Сенсорный пакет"
	desc = "Интегрированный пакет датчиков, позволяющий компьютеру снимать показания с окружающей среды. Требуется некоторыми программами."
	icon_state = "servo"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_SENSORS
	expansion_hw = TRUE

/obj/item/computer_hardware/radio_card
	name = "integrated radio card"
	desc = "An integrated signaling assembly for computers to send an outgoing frequency signal. Required by certain programs."
	icon_state = "signal_card"
	w_class = WEIGHT_CLASS_TINY
	device_type = MC_SIGNALER
	expansion_hw = TRUE
	power_usage = 10
