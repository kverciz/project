/obj/machinery/vending/modularpc
	name = "Deluxe Silicate Selections"
	desc = "Все детали, необходимые для создания собственного ПК."
	icon_state = "modularpc"
	icon_deny = "modularpc-deny"
	light_mask = "modular-light-mask"
	product_ads = "Получите свое игровое снаряжение!;Лучшие графические процессоры для всех ваших потребностей в области космической криптовалюты!;Самое надежное охлаждение!;Лучшая RGB-подсветка в космосе!"
	vend_reply = "Игра началась!"
	products = list(/obj/item/modular_computer/laptop = 4,
					/obj/item/modular_computer/tablet = 4,
					/obj/item/computer_hardware/hard_drive = 4,
					/obj/item/computer_hardware/hard_drive/small = 4,
					/obj/item/computer_hardware/network_card = 8,
					/obj/item/computer_hardware/hard_drive/portable = 8,
					/obj/item/computer_hardware/battery = 8,
					/obj/item/stock_parts/cell/computer = 8,
					/obj/item/computer_hardware/processor_unit = 4,
					/obj/item/computer_hardware/processor_unit/small = 4,
					/obj/item/computer_hardware/sensorpackage = 4)
	premium = list(/obj/item/computer_hardware/card_slot = 2,
		           /obj/item/computer_hardware/ai_slot = 2,
		           /obj/item/computer_hardware/printer/mini = 2,
		           /obj/item/computer_hardware/recharger/apc_recharger = 2,
		           /obj/item/paicard = 2)
	refill_canister = /obj/item/vending_refill/modularpc
	default_price = PAYCHECK_MEDIUM
	extra_price = PAYCHECK_HARD
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/modularpc
	machine_name = "Deluxe Silicate Selections"
	icon_state = "refill_engi"
