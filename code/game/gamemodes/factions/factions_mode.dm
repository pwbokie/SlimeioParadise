/datum/game_mode/factions
	name = "factions"
	config_tag = "factions"
	// tdm_gamemode = TRUE
	// TODO: ^ do we count this??
	// required_players = 40
	var/list/factions = list()
	var/list/allianced = list()

/datum/game_mode/factions/announce()
	to_chat(world, "<B>The current game mode is - Factions!</B>")
	to_chat(world, "<B>Each department forms a faction! Who will come out on top?</B>")

/datum/game_mode/factions/pre_setup()
	// Announcement / alert level / other updates will trigger a minute after roundstart
	addtimer(CALLBACK(src, PROC_REF(begin_factions_protocol)), 10 SECONDS)
	return TRUE

/datum/game_mode/factions/proc/begin_factions_protocol()
	SSsecurity_level.set_level("yellow")

	// assemble the factions! (for each department that has crew associated)
	for(var/datum/station_department/department in SSjobs.station_departments)
		if(department.members.len != 0)
			var/datum/faction/new_faction = new()
			factions += new_faction
			for(var/mob/living/carbon/human/player in GLOB.player_list)
				// TODO: this doesn't work right, department heads are mishandled and legal is completely messed up (put into service)
				if(player.mind.assigned_role in department.department_roles)
					new_faction.add_member(player)
			new_faction.Initialize(department.department_name)

	for(var/mob/M in GLOB.player_list)
		if (ishuman(M))
			// update everyone's faction allegiance
			var/mob/living/carbon/human/target = M
			target.factions_hud_set_faction()
			// ... then give everyone the ability to see the hud
			var/datum/atom_hud/hud = GLOB.huds[DATA_HUD_FACTION]
			hud.add_hud_to(target)
