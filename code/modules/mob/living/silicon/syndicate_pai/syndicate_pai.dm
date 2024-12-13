/mob/living/silicon/pai/syndicate
	name = "Syndicate pAI"
	icon = 'icons/mob/pai.dmi'//
	icon_state = "assaultmini"

	syndicate = TRUE

	var/summoned = FALSE

/mob/living/silicon/pai/syndicate/Initialize(mapload)

	possible_chassis += list(
		"Assault" = "assaultmini",
	)

	if(istype(loc, /obj/item/paicard/syndicate))
		card = loc
	else
		card = new(get_turf(src))
		forceMove(card)
		card.setPersonality(src)

	if(card)
		faction = card.faction.Copy()

	integ_signaler = new(src)

	if(card)
		if(!card.radio)
			card.radio = new /obj/item/radio(card)
		radio = card.radio

	//Default languages without universal translator software
	add_language("Sol Common")
	add_language("Tradeband")
	add_language("Gutter")
	add_language("Trinary")

	AddSpell(new /datum/spell/access_software_pai)
	AddSpell(new /datum/spell/unfold_chassis_pai/syndicate)

	//PDA
	pda = new(src)
	pda.ownjob = "Personal Assistant"
	pda.owner = "[src]"
	pda.name = "[pda.owner] ([pda.ownjob])"
	var/datum/data/pda/app/messenger/M = pda.find_program(/datum/data/pda/app/messenger)
	M.toff = TRUE

	if(has_ahudded())
		message_admins("[key_name(src)] has joined as a pAI, having previously enabled antag hud.")
		log_admin("[key_name(src)] has joined as a pAI, having previously enabled antag hud.")

	// Software modules. No these var names have nothing to do with photoshop
	for(var/PS in subtypesof(/datum/pai_software))
		var/datum/pai_software/PSD = new PS(src)
		if (!istype(PS, /datum/pai_software/syndicate) || PSD.default)
			installed_software[PSD.id] = PSD

	active_software = installed_software["mainmenu"] // Default us to the main menu

/mob/living/silicon/pai/proc/explode()
	var/turf/T = get_turf(src.loc)

//	if(ismob(loc))
//		var/mob/M = loc
//		M.show_message("<span class='danger'>Your [src] explodes!</span>", 1)

	if(T)
		T.hotspot_expose(700,125)

		explosion(T, -1, -1, 2, 3)
	qdel(src)
	return

// /datum/spell/access_software_pai/syndicate
// . = ..()

/datum/spell/unfold_chassis_pai/syndicate
	name = "Unfold/Fold Chassis"
	desc = "Allows you to fold in/out of your mobile form."
	clothes_req = FALSE
	base_cooldown = 20 SECONDS
	action_icon_state = "assaultmini"
	action_background_icon_state = "bg_tech_blue"

/datum/spell/unfold_chassis_pai/create_new_targeting()
	return new /datum/spell_targeting/self

/datum/spell/unfold_chassis_pai/cast(list/targets, mob/living/user = usr)
	var/mob/living/silicon/pai/syndicate/pai_user = user

	if(pai_user.loc != pai_user.card)
		pai_user.close_up()
		return TRUE
	pai_user.force_fold_out_syndicate()

	pai_user.visible_message("<span class='notice'>[pai_user] folds outwards, expanding into a mobile form.</span>", "<span class='notice'>You fold outwards, expanding into a mobile form.</span>")
	return TRUE

/mob/living/silicon/pai/syndicate/proc/force_fold_out_syndicate()
	if(ismob(card.loc))
		var/mob/holder = card.loc
		holder.unEquip(card)
	else if(istype(card.loc, /obj/item/pda))
		var/obj/item/pda/holder = card.loc
		holder.pai = null

	forceMove(get_turf(card))

	card.forceMove(src)
	card.screen_loc = null
