/obj/item/paicard/syndicate
	name = "syndicate personal AI device"
	icon_state = "syndicate_pai"

	var/used = FALSE
	var/mob_name = "Syndicate pAI"

	var/confirmation_message = "Download a personality from the pAI database?"
	var/failure_message = "The device fails to find a fitting personality, and the screen blinks off."

	var/mobtype = /mob/living/silicon/pai/syndicate

/obj/item/paicard/syndicate/attack_self(mob/living/user)
	used = TRUE
	var/choice = tgui_alert(user, "[confirmation_message]", "Confirm", list("Yes", "No"))
	if (choice != "Yes")
		to_chat(user, "<span class='warning'>You decide against using the [name].</span>")
		used = FALSE
		return
	to_chat(user, "The device begins scanning the database for a suitable personality...")

	var/list/mob/dead/observer/candidates = SSghost_spawns.poll_candidates("Do you want to play as the [mob_name] of [user.real_name]?", ROLE_SYNDICATE_PAI, FALSE, 10 SECONDS, source = src, role_cleanname = "[mob_name]")
	var/mob/dead/observer/theghost = null

	if(length(candidates))
		theghost = pick(candidates)
		dust_if_respawnable(theghost)
		spawn_spai(user, theghost.key)
	else
		to_chat(user, "[failure_message]")
		used = FALSE

/obj/item/paicard/syndicate/proc/spawn_spai(mob/living/user, key)
	var/mob/living/silicon/pai/syndicate/S = new /mob/living/silicon/pai/syndicate(user, user)
	S.summoned = TRUE
	S.key = key
	to_chat(S, "You are a [mob_name] bound to serve [user.real_name].")
	to_chat(S, "TODO")
	to_chat(S, "TODO")
	to_chat(S, "TODO")
	to_chat(S, "<span class='motd'>TODO For more information, check the wiki page: ([GLOB.configuration.url.wiki_url]/index.php/SyndicatePAI)</span>")
	S.faction = user.faction

	var/wizard_name_first = pick(GLOB.wizard_first)
	var/wizard_name_second = pick(GLOB.wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	var/newname = sanitize(copytext(input(S, "You are a [mob_name]. Would you like to change your name to something else?", "Name change", randomname) as null|text,1,MAX_NAME_LEN))

	if(!newname)
		newname = randomname
	S.rename_character(S.real_name, newname)
