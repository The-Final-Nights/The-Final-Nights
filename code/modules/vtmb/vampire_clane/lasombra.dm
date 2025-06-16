/datum/vampireclane/lasombra
	name = CLAN_LASOMBRA
	desc = "The Lasombra exist for their own success, fighting for personal victories rather than solely for a crown to wear or a throne to sit upon. They believe that might makes right, and are willing to sacrifice anything to achieve their goals. A clan that uses spirituality as a tool rather than seeking honest enlightenment, their fickle loyalties are currently highlighted by half their clan's defection from the Sabbat."
	curse = "Technology refuse."
	clane_disciplines = list(
		/datum/discipline/potence,
		/datum/discipline/dominate,
		/datum/discipline/obtenebration
	)
	male_clothes = /obj/item/clothing/under/vampire/emo
	female_clothes = /obj/item/clothing/under/vampire/business
	is_enlightened = TRUE
	whitelisted = FALSE
	clan_keys = /obj/item/vamp/keys/lasombra

/datum/vampireclane/lasombra/post_gain(mob/living/carbon/human/H)
	..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
	H.vis_flags |= VIS_HIDE
	H.faction |= CLAN_LASOMBRA

/mob/living/simple_animal/hostile/biter/lasombra /// moved here from tzimisce.dm, as per request. not used anywhere.
	name = "shadow abomination"
	desc = "A shadow given an approximation of life."
	mob_biotypes = MOB_SPIRIT
	icon_state = "shadow"
	icon_living = "shadow"
	del_on_death = TRUE
	maxHealth = 100
	health = 100
	bloodpool = 0
	maxbloodpool = 0
	faction = list(CLAN_LASOMBRA)

/mob/living/simple_animal/hostile/biter/lasombra/better
	icon_state = "shadow2"
	icon_living = "shadow2"
	maxHealth = 200
	health = 200
	melee_damage_lower = 50
	melee_damage_upper = 50
