/// Called when the shuttle starts launching back to centcom, polls a few random players who joined the round for commendations
/datum/controller/subsystem/ticker/proc/poll_hearts()
	if(!CONFIG_GET(number/commendations))
		return
	var/number_to_ask = round(LAZYLEN(GLOB.joined_player_list) * CONFIG_GET(number/commendations)) + rand(0,1)

	for(var/i in GLOB.joined_player_list)
		var/mob/check_mob = get_mob_by_ckey(i)
		if(!check_mob?.mind || !check_mob.client)
			continue
		// maybe some other filters like bans or whatever
		INVOKE_ASYNC(check_mob, /mob.proc/query_heart, 1)
		number_to_ask--
		if(number_to_ask == 0)
			break

/// Once the round is actually over, cycle through the commendations in the hearts list and give them the hearted status
/datum/controller/subsystem/ticker/proc/handle_hearts()
	for(var/i in hearts)
		var/mob/heart_winner = i
		if(!heart_winner.mind || !heart_winner.client)
			continue
		heart_winner.client.prefs.hearted_until = world.realtime + 24 HOURS // make configable
		if(!heart_winner.client)
			return

		heart_winner.client.prefs.hearted = TRUE // so they get it right away
		if(!heart_winner.client)
			return
		heart_winner.client.prefs.save_preferences()
		tgui_alert(heart_winner, "Кто-то поблагодарил меня за прошлый раунд!", "<3!", list("Лан"))

/// Ask someone if they'd like to award a commendation for the round, 3 tries to get the name they want before we give up
/mob/proc/query_heart(attempt=1)
	if(!mind || !client || attempt > 3)
		return
	if(attempt == 1 && tgui_alert(usr, "Понравился ли тебе кто-то в этом раунде?", "<3?", list("Да", "Нет"), timeout = 30 SECONDS) != "Да")
		return

	var/heart_nominee
	switch(attempt)
		if(1)
			heart_nominee = input(src, "Как его зовут? Можешь ввести имя или фамилию. (оставь пустым для отмены)", "<3?")
		if(2)
			heart_nominee = input(src, "Погоди, как там зовут? Можешь ввести имя или фамилию. (оставь пустым для отмены)", "<3?")
		if(3)
			heart_nominee = input(src, "Давай попробуем ещё, как зовут душку? Можешь ввести имя или фамилию. (оставь пустым для отмены)", "<3?")

	if(isnull(heart_nominee) || heart_nominee == "")
		return

	heart_nominee = lowertext(heart_nominee)
	var/list/name_checks = get_mob_by_name(heart_nominee)
	if(!name_checks || name_checks.len == 0)
		query_heart(attempt + 1)
		return
	name_checks = shuffle(name_checks)

	for(var/i in name_checks)
		var/mob/heart_contender = i
		if(heart_contender == src)
			continue

		switch(tgui_alert(usr, "Это нужный господин/госпожа: [heart_contender.real_name]?", "<3?", list("Да!", "Не", "Отмена"), timeout = 15 SECONDS))
			if("Да!")
				nominate_heart(heart_contender)
				return
			if("Не")
				continue
			if("Отмена")
				return

	query_heart(attempt + 1)

/// Once we've confirmed who we're commendating, log it and add them to the hearts list
/mob/proc/nominate_heart(mob/heart_recepient)
	if(!mind || !client)
		return
	to_chat(src, span_nicegreen("Отправлено!"))
	message_admins("[key_name(src)] commended [key_name(heart_recepient)] (<a href='?src=[REF(SSticker)];cancel_heart=1;heart_source=[REF(src)];heart_target=[REF(heart_recepient)]'>CANCEL</a>)") // cancel is probably unnecessary without messages
	log_admin("[key_name(src)] commended [key_name(heart_recepient)]")
	LAZYADD(SSticker.hearts, heart_recepient)