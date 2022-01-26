/datum/wires/mulebot
	holder_type = /mob/living/simple_animal/bot/mulebot
	proper_name = "Mulebot"
	randomize = TRUE

/datum/wires/mulebot/New(atom/holder)
	wires = list(
		WIRE_POWER1, WIRE_POWER2,
		WIRE_AVOIDANCE, WIRE_LOADCHECK,
		WIRE_MOTOR1, WIRE_MOTOR2,
		WIRE_RX, WIRE_TX, WIRE_BEACON
	)
	..()

/datum/wires/mulebot/interactable(mob/user)
	var/mob/living/simple_animal/bot/mulebot/M = holder
	if(M.open)
		return TRUE

/datum/wires/mulebot/on_pulse(wire)
	var/mob/living/simple_animal/bot/mulebot/M = holder
	if(!M.has_power(TRUE))
		return //logically mulebots can't flash and beep if they don't have power.
	switch(wire)
		if(WIRE_POWER1, WIRE_POWER2)
			holder.visible_message(span_notice("[icon2html(M, viewers(holder))] Индикатор зарядки мигает."))
		if(WIRE_AVOIDANCE)
			holder.visible_message(span_notice("[icon2html(M, viewers(holder))] Внешние сигнальные огни кратковременно мигают."))
			flick("[M.base_icon]1", M)
		if(WIRE_LOADCHECK)
			holder.visible_message(span_notice("[icon2html(M, viewers(holder))] Грузовая платформа гремит."))
		if(WIRE_MOTOR1, WIRE_MOTOR2)
			holder.visible_message(span_notice("[icon2html(M, viewers(holder))] Двигатель коротко скулит."))
		else
			holder.visible_message(span_notice("[icon2html(M, viewers(holder))] Трещит на языке радио."))
