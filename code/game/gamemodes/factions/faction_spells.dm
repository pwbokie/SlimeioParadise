#define FACTIONS_INNATE_POWER			1

/datum/spell/factions
	action_background_icon = 'icons/mob/actions/actions.dmi'
	action_background_icon_state = "bg_factions"

	var/power_type

/// The shop for purchasing and upgrading abilities, from here on the rest of the file is just handling shopping. Specific powers are in the powers subfolder.
/datum/spell/factions/self/faction_details
	name = "Faction Details"
	desc = "View and manage details of your faction."
	action_icon_state = "factions_flag"
	base_cooldown = 0 SECONDS
	power_type = FACTIONS_INNATE_POWER

/datum/spell/factions/self/faction_details/ui_state(mob/user)
	return GLOB.always_state

/datum/spell/factions/self/faction_details/cast(mob/user)
	ui_interact(user)

/datum/spell/factions/self/faction_details/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AugmentMenu", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/spell/factions/self/faction_details/ui_act(action, list/params, datum/tgui/ui)
	var/mob/user = ui.user
	if(user.stat)
		return

	switch(action)
		if("purchase")
			// var/path = text2path(params["ability_path"])
			update_static_data(ui.user)
