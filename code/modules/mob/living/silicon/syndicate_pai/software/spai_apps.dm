/datum/pai_software/syndicate
	var/passive = FALSE

// Main Menu //
/datum/pai_software/main_menu/syndicate
	template_file = "syndicate_pai_main_menu"

/datum/pai_software/main_menu/syndicate/get_app_data(mob/living/silicon/pai/user)
	var/list/data = list()
	data["available_ram"] = user.ram

	// Emotions
	var/list/emotions = list()
	for(var/name in GLOB.pai_emotions)
		var/list/emote = list()
		emote["name"] = name
		emote["id"] = GLOB.pai_emotions[name]
		emotions[++emotions.len] = emote

	data["emotions"] = emotions
	data["current_emotion"] = user.card.current_emotion

	var/list/speech_types = list()
	for(var/name in user.possible_say_verbs)
		var/list/speech = list()
		speech["name"] = name
		speech["id"] = length(speech_types)
		speech_types[++speech_types.len] = speech

	data["current_speech_verb"] = user.speech_state
	data["speech_verbs"] = speech_types

	var/list/chassis_choices = list()
	var/list/chassises_to_add = list()

	chassis_choices = user.possible_chassis.Copy()
	if(user.custom_sprite)
		chassis_choices["Custom"] = "[user.ckey]-pai"
	for(var/name in chassis_choices)
		var/list/chassis_to_update_with = list()
		chassis_to_update_with["name"] = name
		chassis_to_update_with["icon"] = chassis_choices[name]
		chassis_to_update_with["id"] = length(chassis_to_update_with)
		chassises_to_add[++chassises_to_add.len] = chassis_to_update_with

	data["available_chassises"] = chassises_to_add
	data["current_chassis"] = user.chassis

	var/list/available_syndicate_software = list()
	var/list/available_s = list()
	for(var/s in GLOB.pai_software_by_key)
		var/datum/pai_software/PS = GLOB.pai_software_by_key[s]
		if (istype(PS, /datum/pai_software/syndicate))
			available_syndicate_software += list(list("name" = PS.name, "key" = PS.id, "icon" = PS.ui_icon, "cost" = PS.ram_cost))
		else
			available_s += list(list("name" = PS.name, "key" = PS.id, "icon" = PS.ui_icon, "cost" = PS.ram_cost))

	// Split to installed software and toggles for the UI
	var/list/installed_syndicate_software = list()
	var/list/installed_syndicate_toggles = list()
	var/list/installed_s = list()
	var/list/installed_t = list()
	for(var/s in pai_holder.installed_software)
		var/datum/pai_software/PS = pai_holder.installed_software[s]
		if (istype(PS, /datum/pai_software/syndicate))
			if(PS.toggle_software)
				installed_syndicate_toggles += list(list("name" = PS.name, "key" = PS.id, "icon" = PS.ui_icon, "active" = PS.is_active(user)))
			else
				installed_syndicate_software += list(list("name" = PS.name, "key" = PS.id, "icon" = PS.ui_icon))
		else
			if(PS.toggle_software)
				installed_t += list(list("name" = PS.name, "key" = PS.id, "icon" = PS.ui_icon, "active" = PS.is_active(user)))
			else
				installed_s += list(list("name" = PS.name, "key" = PS.id, "icon" = PS.ui_icon))

	data["available_syndicate_software"] = available_syndicate_software
	data["installed_syndicate_software"] = installed_syndicate_software
	data["installed_syndicate_toggles"] = installed_syndicate_toggles
	data["available_software"] = available_s
	data["installed_software"] = installed_s
	data["installed_toggles"] = installed_t

	return data

/datum/pai_software/syndicate/detomatix
	name = "Detomatix"
	ram_cost = 20
	id = "detomatix"
	default = FALSE
	template_file = "pai_manifest"
	ui_icon = "bomb"
	toggle_software = TRUE

	var/heating_up = FALSE

/datum/pai_software/syndicate/detomatix/toggle(mob/living/silicon/pai/syndicate/user)
	if (!heating_up)
		to_chat(usr, "Your chassis starts heating up, turning a bright red!")
		heating_up = TRUE
		user.explode()
	else
		to_chat(usr, "Your chassis cools off.")
		heating_up = FALSE
	return
