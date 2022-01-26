///////////////////////////////////
//////////Autolathe Designs ///////
///////////////////////////////////

/datum/design/bucket
	name = "Ведро"
	id = "bucket"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 200)
	build_path = /obj/item/reagent_containers/glass/bucket
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/mop
	name = "Швабра"
	id = "mop"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/mop
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/broom
	name="Метла"
	id="pushbroom"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/pushbroom
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/crowbar
	name = "Карманный ломик"
	id = "crowbar"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/crowbar
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/flashlight
	name = "Фонарик"
	id = "flashlight"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 20)
	build_path = /obj/item/flashlight
	category = list("initial","Инструменты")

/datum/design/extinguisher
	name = "Огнетушитель"
	id = "extinguisher"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 90)
	build_path = /obj/item/extinguisher
	category = list("initial","Инструменты")

/datum/design/pocketfireextinguisher
	name = "Карманный огнетушитель"
	id = "pocketfireextinguisher"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	build_path = /obj/item/extinguisher/mini
	category = list("initial","Инструменты")

/datum/design/multitool
	name = "Мультитул"
	id = "multitool"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 20)
	build_path = /obj/item/multitool
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/analyzer
	name = "Газоанализатор"
	id = "analyzer"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	build_path = /obj/item/analyzer
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/tscanner
	name = "Терагерцовый сканер"
	id = "tscanner"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/t_scanner
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/weldingtool
	name = "Сварочный аппарат"
	id = "welding_tool"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 70, /datum/material/glass = 20)
	build_path = /obj/item/weldingtool
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/mini_weldingtool
	name = "Аварийный сварочный аппарат"
	id = "mini_welding_tool"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30, /datum/material/glass = 10)
	build_path = /obj/item/weldingtool/mini
	category = list("initial","Инструменты")

/datum/design/screwdriver
	name = "Отвёртка"
	id = "screwdriver"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/screwdriver
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/wirecutters
	name = "Кусачки"
	id = "wirecutters"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/wirecutters
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/wrench
	name = "Гаечный ключ"
	id = "wrench"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/wrench
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/plunger
	name = "Вантуз"
	desc = "Не для унитаза!"
	id = "plunger"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	materials = list(/datum/material/iron = 150)
	build_path = /obj/item/plunger
	construction_time = 40
	category = list("initial","Инструменты","Рабочие инструменты", "Фармацевтика")
	sub_category = list("Хим-фабрика")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/welding_helmet
	name = "Сварочная маска"
	id = "welding_helmet"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1750, /datum/material/glass = 400)
	build_path = /obj/item/clothing/head/welding
	category = list("initial","Инструменты")

/datum/design/cable_coil
	name = "Моток кабеля"
	id = "cable_coil"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10, /datum/material/glass = 5)
	build_path = /obj/item/stack/cable_coil
	category = list("initial","Инструменты","Рабочие инструменты")
	maxstack = MAXCOIL
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/toolbox
	name = "Ящик с инструментами"
	id = "tool_box"
	build_type = AUTOLATHE
	materials = list(MAT_CATEGORY_ITEM_MATERIAL = 500)
	build_path = /obj/item/storage/toolbox
	category = list("initial","Инструменты")

/datum/design/apc_board
	name = "Контролер энергощитка"
	id = "power control"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/electronics/apc
	category = list("initial", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/airlock_board
	name = "Контролер шлюза"
	id = "airlock_board"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/airlock
	category = list("initial", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/firelock_board
	name = "Контролер пожарного шлюза"
	id = "firelock_board"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/firelock
	category = list("initial", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/airalarm_electronics
	name = "Контролер АТМОСа"
	id = "airalarm_electronics"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/airalarm
	category = list("initial", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/firealarm_electronics
	name = "Контролер пожарной сигнализации"
	id = "firealarm_electronics"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/electronics/firealarm
	category = list("initial", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/camera
	name = "Фотокамера"
	id = "camera"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 100)
	build_path = /obj/item/camera
	category = list("initial", "Разное")

/datum/design/camera_film
	name = "Фотопленка"
	id = "camera_film"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10, /datum/material/glass = 10)
	build_path = /obj/item/camera_film
	category = list("initial", "Разное")

/datum/design/earmuffs
	name = "Беруши"
	id = "earmuffs"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/clothing/ears/earmuffs
	category = list("initial", "Разное")

/datum/design/pipe_painter
	name = "Маркировщик труб"
	id = "pipe_painter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000)
	build_path = /obj/item/pipe_painter
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING

/datum/design/airlock_painter
	name = "Маркировщик шлюзов"
	id = "airlock_painter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/airlock_painter/decal
	name = "Маркировщик пола"
	id = "decal_painter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50, /datum/material/glass = 50)
	build_path = /obj/item/airlock_painter/decal
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/emergency_oxygen
	name = "Аварийный кислородный баллон"
	id = "emergency_oxygen"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/tank/internals/emergency_oxygen/empty
	category = list("initial","Разное","Снаряжение")

/datum/design/emergency_oxygen_engi
	name = "Карманный кислородный баллон"
	id = "emergency_oxygen_engi"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 750)
	build_path = /obj/item/tank/internals/emergency_oxygen/engi/empty
	category = list("hacked","Разное","Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/plasmaman_tank_belt
	name = "Плазма-дыхательный баллон"
	id = "plasmaman_tank_belt"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 800)
	build_path = /obj/item/tank/internals/plasmaman/belt/empty
	category = list("hacked","Разное","Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/generic_gas_tank
	name = "Газовый баллон"
	id = "generic_tank"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/tank/internals/generic
	category = list("initial","Разное","Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_CARGO

/datum/design/iron
	name = "Железо"
	id = "iron"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/iron
	category = list("initial","Конструкции")
	maxstack = 50

/datum/design/glass
	name = "Стекло"
	id = "glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/glass
	category = list("initial","Конструкции")
	maxstack = 50

/datum/design/rglass
	name = "Армированное стекло"
	id = "rglass"
	build_type = AUTOLATHE | SMELTER | PROTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = MINERAL_MATERIAL_AMOUNT)
	build_path = /obj/item/stack/sheet/rglass
	category = list("initial","Конструкции","Запчасти оборудования")
	maxstack = 50

/datum/design/rods
	name = "Железные стержни"
	id = "rods"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/stack/rods
	category = list("initial","Конструкции")
	maxstack = 50

/datum/design/rcd_ammo
	name = "Картридж спрессованной материи"
	id = "rcd_ammo"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 12000, /datum/material/glass = 8000)
	build_path = /obj/item/rcd_ammo
	category = list("initial","Конструкции")

/datum/design/kitchen_knife
	name = "Кухонный нож"
	id = "kitchen_knife"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/kitchen/knife
	category = list("initial","Кухня")

/datum/design/plastic_knife
	name = "Пластиковый нож"
	id = "plastic_knife"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/plastic = 100)
	build_path = /obj/item/kitchen/knife/plastic
	category = list("initial", "Рабочие инструменты","Кухня")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/fork
	name = "Вилка"
	id = "fork"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 80)
	build_path = /obj/item/kitchen/fork
	category = list("initial","Кухня")

/datum/design/plastic_fork
	name = "Пластиковая вилка"
	id = "plastic_fork"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/plastic = 80)
	build_path = /obj/item/kitchen/fork/plastic
	category = list("initial", "Рабочие инструменты", "Кухня")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/spoon
	name = "Ложка"
	id = "spoon"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 120)
	build_path = /obj/item/kitchen/spoon
	category = list("initial", "Рабочие инструменты", "Кухня")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/plastic_spoon
	name = "Пластиковая ложка"
	id = "plastic_spoon"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/plastic = 120)
	build_path = /obj/item/kitchen/spoon/plastic
	category = list("initial", "Рабочие инструменты", "Кухня")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/tray
	name = "Поднос"
	id = "servingtray"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray
	category = list("initial","Кухня")

/datum/design/cafeteria_tray
	name = "Поднос кафетерия"
	id = "foodtray"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/storage/bag/tray/cafeteria
	category = list("initial","Кухня")

/datum/design/bowl
	name = "Чаша"
	id = "bowl"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/bowl
	category = list("initial","Кухня")

/datum/design/drinking_glass
	name = "Стакан"
	id = "drinking_glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass
	category = list("initial","Кухня")

/datum/design/shot_glass
	name = "Шот"
	id = "shot_glass"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/reagent_containers/food/drinks/drinkingglass/shotglass
	category = list("initial","Кухня")

/datum/design/shaker
	name = "Шейкер"
	id = "shaker"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1500)
	build_path = /obj/item/reagent_containers/food/drinks/shaker
	category = list("initial","Кухня")

/datum/design/cultivator
	name = "Тяпка"
	id = "cultivator"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron=50)
	build_path = /obj/item/cultivator
	category = list("initial","Разное", "Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/plant_analyzer
	name = "Анализатор растений"
	id = "plant_analyzer"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 30, /datum/material/glass = 20)
	build_path = /obj/item/plant_analyzer
	category = list("initial","Разное", "Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/shovel
	name = "Лопата"
	id = "shovel"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/shovel
	category = list("initial","Разное", "Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/spade
	name = "Лопаточка"
	id = "spade"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 50)
	build_path = /obj/item/shovel/spade
	category = list("initial","Разное", "Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/hatchet
	name = "Топорик"
	id = "hatchet"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/hatchet
	category = list("initial","Разное", "Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/secateurs
	name = "Секатор"
	id = "secateurs"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/secateurs
	category = list("initial","Разное", "Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/foilhat
	name = "Шапочка из фольги"
	id = "tinfoil_hat"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 5500)
	build_path = /obj/item/clothing/head/foilhat
	category = list("hacked", "Разное")

/datum/design/blood_filter
	name = "Фильтр крови"
	desc = "Для фильтрации крови и лимфы."
	id = "blood_filter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1500, /datum/material/silver = 500)
	build_path = /obj/item/blood_filter
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/scalpel
	name = "Скальпель"
	desc = "Очень острое лезвие с микронной заточкой."
	id = "scalpel"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 4000, /datum/material/glass = 1000)
	build_path = /obj/item/scalpel
	category = list("initial", "Медицина", "Рабочие инструменты", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/circular_saw
	name = "Циркулярная пила"
	desc = "Для работы с костью при полостных операциях."
	id = "circular_saw"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/circular_saw
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/bonesetter
	name = "Костоправ"
	desc = "Для правильной ориентации костей при вывихах и переломах."
	id = "bonesetter"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000,  /datum/material/glass = 2500)
	build_path = /obj/item/bonesetter
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/surgicaldrill
	name = "Хирургическая дрель"
	desc = "Можно просверлить с помощью этого что-то. Или пробурить?"
	id = "surgicaldrill"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 6000)
	build_path = /obj/item/surgicaldrill
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/retractor
	name = "Расширитель"
	desc = "Позволяет получить оперативный простор в зоне проведения операции."
	id = "retractor"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 6000, /datum/material/glass = 3000)
	build_path = /obj/item/retractor
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/cautery
	name = "Прижигатель"
	desc = "Останавливает кровотечения и дезинфецирует рабочую зону после завершения операции."
	id = "cautery"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 2500, /datum/material/glass = 750)
	build_path = /obj/item/cautery
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/hemostat
	name = "Зажим"
	desc = "Используется для манипуляций в рабочей области и остановки внутренних кровотечений."
	id = "hemostat"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2500)
	build_path = /obj/item/hemostat
	category = list("initial", "Медицина", "Рабочие инструменты", "Хирургические инструменты")
	sub_category = list("Базовые инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/stethoscope
	name = "Стетоскоп"
	desc = "Устаревший медицинский аппарат для прослушивания звуков человеческого тела. Это также заставляет вас выглядеть так, как будто вы знаете, что делаете."
	id = "stethoscope"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 1000)
	build_path = /obj/item/clothing/neck/stethoscope
	category = list("initial", "Медицина", "Рабочие инструменты", "Медицинское снаряжение")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/beaker
	name = "Химический стакан"
	desc = "Химический стакан, вместимостью до 50 единиц."
	id = "beaker"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/reagent_containers/glass/beaker
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE

/datum/design/large_beaker
	name = "Большой химический стакан"
	desc = "Большой химический стакан, вместимостью до 100 единиц."
	id = "large_beaker"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/glass = 2500)
	build_path = /obj/item/reagent_containers/glass/beaker/large
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Химическая посуда")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SERVICE

/datum/design/pillbottle
	name = "Баночка для таблеток"
	desc = "Хранит в себе разноцветные пилюльки и таблетки."
	id = "pillbottle"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 30
	materials = list(/datum/material/plastic = 20, /datum/material/glass = 100)
	build_path = /obj/item/storage/pill_bottle
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/beanbag_slug
	name = "12 Калибр: Резиновая пуля"
	id = "beanbag_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000)
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	category = list("initial", "Безопасность")

/datum/design/rubbershot
	name = "12 Калибр: Резиновая картечь"
	id = "rubber_shot"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/rubbershot
	category = list("initial", "Безопасность")

/datum/design/c38
	name = "Скорозарядник (.38)"
	id = "c38"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 20000)
	build_path = /obj/item/ammo_box/c38
	category = list("initial", "Безопасность")

/datum/design/recorder
	name = "диктофон"
	id = "recorder"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 60, /datum/material/glass = 30)
	build_path = /obj/item/taperecorder/empty
	category = list("initial", "Разное")

/datum/design/tape
	name = "Магнитная касета"
	id = "tape"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 20, /datum/material/glass = 5)
	build_path = /obj/item/tape/random
	category = list("initial", "Разное")

/datum/design/igniter
	name = "Воспламенитель"
	id = "igniter"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/igniter
	category = list("initial", "Разное")

/datum/design/condenser
	name = "Конденсатор"
	id = "condenser"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron=250, /datum/material/glass=300)
	build_path = /obj/item/assembly/igniter/condenser
	category = list("initial", "Разное")

/datum/design/signaler
	name = "Сигналер"
	id = "signaler"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 400, /datum/material/glass = 120)
	build_path = /obj/item/assembly/signaler
	category = list("initial", "Телекомы")

/datum/design/radio_headset
	name = "Гарнитура"
	id = "radio_headset"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/radio/headset
	category = list("initial", "Телекомы")

/datum/design/bounced_radio
	name = "Рация"
	id = "bounced_radio"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 75, /datum/material/glass = 25)
	build_path = /obj/item/radio/off
	category = list("initial", "Телекомы")

/datum/design/intercom_frame
	name = "Каркас интеркома"
	id = "intercom_frame"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 75, /datum/material/glass = 25)
	build_path = /obj/item/wallframe/intercom
	category = list("initial", "Телекомы")

/datum/design/infrared_emitter
	name = "Инфракрасный излучатель"
	id = "infrared_emitter"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000, /datum/material/glass = 500)
	build_path = /obj/item/assembly/infra
	category = list("initial", "Разное")

/datum/design/health_sensor
	name = "Датчик жизни"
	desc = "Следит за основными жизненными показателями пользователя, может отправлять сигналы при смерти или критическом состоянии носителя."
	id = "health_sensor"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/health
	category = list("initial", "Медицина", "Медицинское снаряжение")
	sub_category = list("Диагностика и мониторинг")

/datum/design/timer
	name = "Таймер"
	id = "timer"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/timer
	category = list("initial", "Разное")

/datum/design/voice_analyser
	name = "Анализатор голоса"
	id = "voice_analyser"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 50)
	build_path = /obj/item/assembly/voice
	category = list("initial", "Разное")

/datum/design/light_tube
	name = "Лампа дневного света"
	id = "light_tube"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/light/tube
	category = list("initial", "Конструкции")

/datum/design/light_bulb
	name = "Лампочка"
	id = "light_bulb"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 100)
	build_path = /obj/item/light/bulb
	category = list("initial", "Конструкции")

/datum/design/camera_assembly
	name = "Сборка камеры"
	id = "camera_assembly"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 400, /datum/material/glass = 250)
	build_path = /obj/item/wallframe/camera
	category = list("initial", "Конструкции")

/datum/design/newscaster_frame
	name = "Рама новостника"
	id = "newscaster_frame"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 14000, /datum/material/glass = 8000)
	build_path = /obj/item/wallframe/newscaster
	category = list("initial", "Конструкции")

/datum/design/bounty_board_frame
	name = "Рама доски вознаграждений"
	id = "bountyboard_frame"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 14000, /datum/material/glass = 8000)
	build_path = /obj/item/wallframe/bounty_board
	category = list("initial", "Конструкции")

/datum/design/syringe
	name = "Шприц"
	desc = "Может содержать 15 единиц."
	id = "syringe"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 10, /datum/material/glass = 20)
	build_path = /obj/item/reagent_containers/syringe
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Инъекции")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/dropper
	name = "Пипетка"
	desc = "Пипетка, вместимостью до 5 единиц."
	id = "dropper"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/glass = 10, /datum/material/plastic = 30)
	build_path = /obj/item/reagent_containers/dropper
	category = list("initial", "Медицина", "Медицинские разработки", "Фармацевтика")
	sub_category = list("Инъекции")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/prox_sensor
	name = "Датчик движения"
	id = "prox_sensor"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 20
	materials = list(/datum/material/iron = 800, /datum/material/glass = 200)
	build_path = /obj/item/assembly/prox_sensor
	category = list("initial", "Разное", "Медицинское снаряжение")
	sub_category = list("Прочее")

/datum/design/foam_dart
	name = "Коробка с пенными дротиками"
	id = "foam_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/ammo_box/foambox
	category = list("initial", "Разное")

//hacked autolathe recipes
/datum/design/flamethrower
	name = "Огнемет"
	id = "flamethrower"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/flamethrower/full
	category = list("hacked", "Безопасность")

/datum/design/electropack
	name = "Электропак"
	id = "electropack"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 2500)
	build_path = /obj/item/electropack
	category = list("hacked", "Инструменты")

/datum/design/large_welding_tool
	name = "Индустриальный сварочный аппарат"
	id = "large_welding_tool"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 70, /datum/material/glass = 60)
	build_path = /obj/item/weldingtool/largetank
	category = list("hacked", "Инструменты")

/datum/design/handcuffs
	name = "Наручники"
	id = "handcuffs"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/restraints/handcuffs
	category = list("hacked", "Безопасность")

/datum/design/receiver
	name = "Модульный приёмник"
	id = "receiver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 15000)
	build_path = /obj/item/weaponcrafting/receiver
	category = list("hacked", "Безопасность")

/datum/design/shotgun_slug
	name = "12 Калибр: Пулевой"
	id = "shotgun_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun
	category = list("hacked", "Безопасность")

/datum/design/buckshot_shell
	name = "12 Калибр: Картечь"
	id = "buckshot_shell"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/buckshot
	category = list("hacked", "Безопасность")

/datum/design/shotgun_dart
	name = "12 Калибр: Дротик"
	id = "shotgun_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/dart
	category = list("hacked", "Безопасность")

/datum/design/incendiary_slug
	name = "12 Калибр: Зажигательный патрон"
	id = "incendiary_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/shotgun/incendiary
	category = list("hacked", "Безопасность")

/datum/design/riot_dart
	name = "Резиновый пенчик"
	id = "riot_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1000) //Discount for making individually - no box = less iron!
	build_path = /obj/item/ammo_casing/caseless/foam_dart/riot
	category = list("hacked", "Безопасность")

/datum/design/riot_darts
	name = "Коробка с пенными дротиками антибунт"
	id = "riot_darts"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 50000) //Comes with 40 darts
	build_path = /obj/item/ammo_box/foambox/riot
	category = list("hacked", "Безопасность")

/datum/design/a357
	name = "Пуля .357 калибра"
	id = "a357"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 4000)
	build_path = /obj/item/ammo_casing/a357
	category = list("hacked", "Безопасность")

/datum/design/c10mm
	name = "Коробка с патронами (10мм)"
	id = "c10mm"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c10mm
	category = list("hacked", "Безопасность")

/datum/design/c45
	name = "Коробка с патронами (.45)"
	id = "c45"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c45
	category = list("hacked", "Безопасность")

/datum/design/c9mm
	name = "Коробка с патронами (9мм)"
	id = "c9mm"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 30000)
	build_path = /obj/item/ammo_box/c9mm
	category = list("hacked", "Безопасность")

/datum/design/cleaver
	name = "Тесак мясника"
	id = "cleaver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 18000)
	build_path = /obj/item/kitchen/knife/butcher
	category = list("hacked", "Кухня")

/datum/design/spraycan
	name = "Баллончик с краской"
	id = "spraycan"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/toy/crayon/spraycan
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/desttagger
	name = "Этикеровщик назначения"
	id = "desttagger"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 250, /datum/material/glass = 125)
	build_path = /obj/item/dest_tagger
	category = list("initial", "Электроника")

/datum/design/salestagger
	name = "Этикеровщик скидок"
	id = "salestagger"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 700, /datum/material/glass = 200)
	build_path = /obj/item/sales_tagger
	category = list("initial", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SERVICE

/datum/design/handlabeler
	name = "Этикетировщик"
	desc = "Комбинированный принтер этикеток, аппликатор и съемник - все в одном портативном устройстве. Разработанный, чтобы быть простым в эксплуатации и использовании."
	id = "handlabel"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 150, /datum/material/glass = 125)
	build_path = /obj/item/hand_labeler
	category = list("initial", "Электроника", "Фармацевтика")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/geiger
	name = "Счётчик гейгера"
	id = "geigercounter"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 150, /datum/material/glass = 150)
	build_path = /obj/item/geiger_counter
	category = list("initial", "Инструменты")

/datum/design/turret_control_frame
	name = "Рама контролера турели"
	id = "turret_control"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 12000)
	build_path = /obj/item/wallframe/turret_control
	category = list("initial", "Конструкции")

/datum/design/conveyor_belt
	name = "Конвейерная лента"
	id = "conveyor_belt"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 3000)
	build_path = /obj/item/stack/conveyor
	category = list("initial", "Конструкции", "Электроника")
	maxstack = 30
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/conveyor_switch
	name = "Переключатель конвейерной ленты"
	id = "conveyor_switch"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 450, /datum/material/glass = 190)
	build_path = /obj/item/conveyor_switch_construct
	category = list("initial", "Конструкции", "Электроника")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/laptop
	name = "Ноутбук (пустой)"
	id = "laptop"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 10000, /datum/material/glass = 1000)
	build_path = /obj/item/modular_computer/laptop/buildable
	category = list("initial","Разное")

/datum/design/tablet
	name = "Планшет (пустой)"
	id = "tablet"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/modular_computer/tablet
	category = list("initial","Разное")

/datum/design/slime_scanner
	name = "Анализатор слаймов"
	id = "slime_scanner"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 300, /datum/material/glass = 200)
	build_path = /obj/item/slime_scanner
	category = list("initial", "Разное")

/datum/design/pet_carrier
	name = "Переноска для животных"
	id = "pet_carrier"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 7500, /datum/material/glass = 100)
	build_path = /obj/item/pet_carrier
	category = list("initial", "Разное")

/datum/design/miniature_power_cell
	name = "Батарея аварийного питания"
	id = "miniature_power_cell"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 20)
	build_path = /obj/item/stock_parts/cell/emergency_light
	category = list("initial", "Электроника")

/datum/design/package_wrap
	name = "Оберточная бумага"
	desc = "Оберните пакеты этой праздничной бумагой, чтобы сделать подарки."
	id = "packagewrap"
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 200, /datum/material/glass = 200)
	build_path = /obj/item/stack/package_wrap
	category = list("initial", "Разное", "Снаряжение", "Прочее")
	maxstack = 30

/datum/design/holodisk
	name = "Голодиск"
	id = "holodisk"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 100)
	build_path = /obj/item/disk/holodisk
	category = list("initial", "Разное")

/datum/design/circuit
	name = "Синяя электронная плитка"
	id = "circuit"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit
	category = list("initial", "Разное")
	maxstack = 50

/datum/design/circuitgreen
	name = "Зелёная электронная плитка"
	id = "circuitgreen"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit/green
	category = list("initial", "Разное")
	maxstack = 50

/datum/design/circuitred
	name = "Красная электронная плитка"
	id = "circuitred"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500)
	build_path = /obj/item/stack/tile/circuit/red
	category = list("initial", "Разное")
	maxstack = 50

/datum/design/price_tagger
	name = "Этикеровщик цен"
	id = "price_tagger"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 1500, /datum/material/glass = 500)
	build_path = /obj/item/price_tagger
	category = list("initial", "Разное")

/datum/design/custom_vendor_refill
	name = "комплект снабжения вендора"
	id = "custom_vendor_refill"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 5000, /datum/material/glass = 2000)
	build_path = /obj/item/vending_refill/custom
	category = list("initial", "Разное")

/datum/design/ducts
	name = "Набор труб"
	desc = "Используются для передачи жидкости на расстояние."
	id = "fluid_ducts"
	build_type = AUTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/iron = 500)
	build_path = /obj/item/stack/ducts
	category = list("initial", "Конструкции", "Фармацевтика")
	sub_category = list("Хим-фабрика")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	maxstack = 50

/datum/design/toygun
	name = "Игрушечный пистолет"
	id = "toygun"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/toy/gun
	category = list("hacked", "Разное")

/datum/design/capbox
	name = "Коробка с пистонами"
	id = "capbox"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 20, /datum/material/glass = 5)
	build_path = /obj/item/toy/ammo/gun
	category = list("hacked", "Разное")

/datum/design/toy_balloon
	name = "Воздушный шарик"
	id = "toy_balloon"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 1200)
	build_path = /obj/item/toy/balloon
	category = list("hacked", "Разное")

/datum/design/toy_armblade
	name = "Пенопластовая рука-лезвие"
	id = "toy_armblade"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 2000)
	build_path = /obj/item/toy/foamblade
	category = list("hacked", "Разное")

/datum/design/plastic_tree
	name = "Пластиковое дерево"
	id = "plastic_trees"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 8000)
	build_path = /obj/item/kirbyplants/fullysynthetic
	category = list("initial", "Разное")

/datum/design/beads
	name = "Пластиковые бусы"
	id = "plastic_necklace"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/clothing/neck/beads
	category = list("initial", "Разное")

/datum/design/plastic_ring
	name = "Упаковка для содовой"
	id = "ring_holder"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 1200)
	build_path = /obj/item/storage/cans
	category = list("initial", "Кухня")

/datum/design/plastic_box
	name = "Пластиковая коробка"
	id = "plastic_box"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 1000)
	build_path = /obj/item/storage/box/plastic
	category = list("initial", "Разное")

/datum/design/sticky_tape
	name = "Клейкая лента"
	id = "sticky_tape"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/stack/sticky_tape
	category = list("initial", "Разное")

/datum/design/sticky_tape/surgical
	name = "Хирургическая лента"
	desc = "Используется для сращивания поломаных костей как и костный гель. Не для пранков."
	id = "surgical_tape"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 40
	materials = list(/datum/material/plastic = 500)
	build_path = /obj/item/stack/sticky_tape/surgical
	category = list("initial", "Медицина", "Хирургические инструменты")
	sub_category = list("Прочее")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL

/datum/design/petridish
	name = "Чаша Петри"
	id = "petri_dish"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/petri_dish
	category = list("initial","Разное","Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/swab
	name = "Стерильная губка"
	id = "swab"
	build_type = PROTOLATHE | AUTOLATHE
	materials = list(/datum/material/plastic = 200)
	build_path = /obj/item/swab
	category = list("initial","Разное","Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_SCIENCE

/datum/design/chisel
	name = "Стамеска"
	id = "chisel"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 75)
	build_path = /obj/item/chisel
	category = list("initial","Инструменты")

/datum/design/control
	name = "Контролер взрывостойкого шлюза"
	id = "blast"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 100, /datum/material/glass = 50)
	build_path = /obj/item/assembly/control
	category = list("initial","Разное")


/datum/design/holosign/restaurant
	name = "Голопроектор ресторана"
	desc = "A holographic projector that creates seating designation for restaurants."
	id = "holosignrestaurant"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/holosign_creator/robot_seat/restaurant
	category = list("Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/holosign/bar
	name = "Голопроектор бара"
	desc = "A holographic projector that creates seating designation for bars."
	id = "holosignbar"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 2000, /datum/material/glass = 1000)
	build_path = /obj/item/holosign_creator/robot_seat/bar
	category = list("Снаряжение")
	departmental_flags = DEPARTMENTAL_FLAG_SERVICE

/datum/design/floor_painter
	name = "полокрас"
	id = "floor_painter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/floor_painter
	category = list("initial","Инструменты","Рабочие инструменты")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/cannon_ball
	name = "пушечное ядро"
	id = "cannon_ball"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 6000)
	build_path = /obj/item/stack/cannonball
	category = list("hacked","Разное")

/datum/design/cannon_ball_exp
	name = "разрывное пушечное ядро"
	id = "cannon_ball_exp"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 6000, /datum/material/plasma = 2000)
	build_path = /obj/item/stack/cannonball/shellball
	category = list("hacked","Разное")

/datum/design/cannon_ball_big
	name = "противотанковое пушечное ядро"
	id = "cannon_ball_big"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 12000, /datum/material/plasma = 6000)
	build_path = /obj/item/stack/cannonball/the_big_one
	category = list("hacked","Разное")
