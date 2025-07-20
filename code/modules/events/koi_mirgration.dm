/datum/event/carp_migration/koi
	spawned_mobs = list(
	/mob/living/basic/retaliate/carp/koi = 98,
	/mob/living/basic/retaliate/carp/koi/honk = 2)


/datum/event/carp_migration/koi/start()
	spawn_fish(rand(4, 6)) //12 to 30 koi, in small groups
