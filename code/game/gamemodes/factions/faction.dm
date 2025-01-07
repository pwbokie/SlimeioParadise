/datum/faction
	var/name
	var/datum/alliance // the alliance we are a part of
	var/members = list() // human members of this faction
	var/icon = null // HUD icon for the faction
	var/motd = "" // shown to new joiners and in faction details

	var/mob/living/carbon/human/leader // leader of the faction
	var/department // the department that this faction represents, or originally represented
	var/list/objectives = list()

/datum/faction/proc/Initialize(source_department)
	department = source_department

	switch(source_department)
		if(DEPARTMENT_COMMAND)
			icon = "command"
			src.rename("Commandtozka")
			objectives.Add("Help maintain balance between the factions.")
		if(DEPARTMENT_MEDICAL)
			icon = "medical"
			src.rename("Medistan")
		if(DEPARTMENT_ENGINEERING)
			icon = "engineering"
			src.rename("Atmosia")
			objectives.Add("Keep the station powered, and its air breathable.")
		if(DEPARTMENT_SCIENCE)
			icon = "science"
			src.rename("Scientopia")
		if(DEPARTMENT_SECURITY)
			icon = "security"
			src.rename("Brigston")
		if(DEPARTMENT_SUPPLY)
			icon = "supply"
			src.rename("Cargonia")
		if(DEPARTMENT_SERVICE)
			icon = "service"
			src.rename("Servicion")

	alliance = new /datum/alliance()

	// TODO: logic for picking a leader
	leader = pick(members)

	// greet all members
	for(var/mob/living/carbon/human/member in members)
		if (member == leader)
			greet_leader(member)
		else
			greet_member(member)

// Greeting for new members
/datum/faction/proc/greet_member(mob/living/carbon/human/member)
	var/list/messages = list()
	messages.Add("<b><font size=3 color='yellow'>You are a proud member of </font><font size=4>[name]!</font><br></b>")
	messages.Add("<span class='notice'>Follow your faction leader, [leader.real_name], and complete your faction's objectives!</span>")
	add_objectives_to_messages(messages)
	to_chat(member, chat_box_green(messages.Join("<br>")))
	member.create_log(MISC_LOG, "[member] was added to the faction [name]")

/datum/faction/proc/greet_leader(mob/living/carbon/human/leader)
	var/list/messages = list()
	messages.Add("<b><font size=3 color='yellow'>You are the proud leader of </font><font size=4>[name]!</font><br></b>")
	messages.Add("<span class='notice'>Lead your faction and complete your faction's objectives!</span>")
	add_objectives_to_messages(messages)
	to_chat(leader, chat_box_green(messages.Join("<br>")))
	leader.create_log(MISC_LOG, "[leader] was made the leader of the faction [name]")

/datum/faction/proc/add_objectives_to_messages(var/list/messages)
	var/count = 1
	for (var/objective in objectives)
		objectives.Add("<font color='white'[count]. [objective]</font>")
		count++

// simple faction management
/datum/faction/proc/rename(new_name)
	if(new_name)
		name = new_name
		return TRUE
	else
		return FALSE

/datum/faction/proc/set_motd(new_motd)
	if(new_motd)
		motd = new_motd
		return TRUE
	else
		return FALSE

/datum/faction/proc/add_member(mob/living/carbon/human/new_member)
	if(new_member && new_member.factions_mode_allegiance == null)
		new_member.factions_mode_allegiance = src
		src.members += new_member
		return TRUE
	else
		return FALSE

/datum/faction/proc/remove_member(mob/living/carbon/human/member)
	if((member) && (member in members) && (member.factions_mode_allegiance == src))
		member.factions_mode_allegiance = null
		src.members -= member
		return TRUE
	else
		return FALSE

/datum/faction/proc/join_alliance(datum/alliance/new_alliance)
	if(new_alliance)
		new_alliance.members += src
		src.alliance = new_alliance
		return TRUE
	else
		return FALSE

// /datum/faction/proc/leave_current_alliance()
// 	if(alliance)
//		alliance.remove_member(src)

// Alliances

/datum/alliance
	var/name = "Unset Alliance Name"
	var/list/members = list() // factions included in the alliance
	var/at_war_with = list() // alliances we are at war with

/datum/alliance/proc/add_member(new_member)
	var/datum/faction/faction_new_member = new_member

	if(faction_new_member && faction_new_member.alliance == null)
		faction_new_member.alliance = src
		members += faction_new_member
		return TRUE
	else
		return FALSE

/datum/alliance/proc/remove_member(datum/faction/old_member)
	if((old_member) && (old_member in members))
		members -= old_member
		// no point in an alliance with no members
		if (members.len == 0)
			qdel(src)
		return TRUE
	else
		return FALSE

/datum/alliance/proc/declare_war(datum/alliance/target)
	if((target) && (target != src) && !(target in at_war_with))
		src.at_war_with += target
		target.at_war_with += src
		// TODO: notify everyone in both factions
		return TRUE
	else
		return FALSE
