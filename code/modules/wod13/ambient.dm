//this needs to be changed to a rating from 1 to 10, but this is how it was added for Kuei-jin
#define VERY_HIGH_WALL_RATING 3
#define HIGH_WALL_RATING 2
#define LOW_WALL_RATING 1

/area
	var/fire_controled = FALSE
	var/fire_controling = FALSE
	var/zone_type = "masquerade"
	//Chi stuff
	var/yang_chi = 1
	var/yin_chi = 1
	var/wall_rating = VERY_HIGH_WALL_RATING

/area/vtm
	name = "San Francisco"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sewer"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	wall_rating = VERY_HIGH_WALL_RATING
	var/music
	var/upper = TRUE


/area/vtm/powered(chan)
	if(!requires_power)
		return TRUE
	return FALSE

/area/vtm/proc/break_elysium()
	if(zone_type == "masquerade")
		zone_type = "battle"
		spawn(1800)
			zone_type = "masquerade"

/area/vtm/interior
	name = "Interior"
	icon_state = "interior"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/shop
	name = "Shop"
	icon_state = "shop"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/laundromat
	name = "Laundromat"
	icon_state = "shop"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/giovanni
	name = "Giovanni Mansion"
	icon_state = "giovanni"
	upper = FALSE
	zone_type = "elysium"
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/giovanni/outside
	name = "Giovanni Mansion - Courtyard"
	icon_state = "giovanni"
	upper = TRUE
	zone_type = "elysium"
	fire_controled = FALSE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/giovanni/basement
	name = "Giovanni Mansion - Basement"
	icon_state = "giovanni"
	upper = FALSE
	zone_type = "elysium"
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/techshop
	name = "Nightwolf Techshop"
	icon_state = "shop"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/bianchiBank
	name = "Bianchi Bank"
	icon_state = "giovanni"
	upper = FALSE
	zone_type = "elysium"
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/police
	name = "Police Station"
	icon_state = "police"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/police/morgue
	name = "Police Station - Morgue"
	icon_state = "police"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/police/upstairs
	name = "Police Station - Upstairs"
	icon_state = "police"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/police/fed
	name = "Hotel"
	icon_state = "police"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/vjanitor
	name = "Cleaners"
	icon_state = "janitor"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/strip
	name = "Strip Club"
	icon_state = "strip"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/strip/toreador
	name = "Strip Club - Apartments"
	icon_state = "prince"
	upper = FALSE
	fire_controled = TRUE
	zone_type = "elysium"

/area/vtm/interior/strip/elysium
	name = "Strip Club - Elysium"
	icon_state = "prince"
	upper = FALSE
	fire_controled = TRUE
	zone_type = "elysium"

/area/vtm/interior/mansion
	name = "Abandoned Mansion"
	icon_state = "mansion"
	upper = FALSE
	zone_type = "battle"
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/apartment
	name = "Millenium Apartments"
	icon_state = "camarilla_interior"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/ghetto
	name = "Ghetto Apartments"
	icon_state = "ghetto_interior"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/financialdistrict
	name = "Financial District"
	icon_state = "financialdistrict"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/downtown
	upper = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/financialdistrict/construction
	name = "Financial District - In Construction"

/area/vtm/financialdistrict/library
	name = "Financial District - Cultural Square"

/area/vtm/ghetto
	name = "Ghetto"
	icon_state = "ghetto"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/downtown
	upper = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/ghetto/old
	name = "Ghetto - Old Quarter"

/area/vtm/pacificheights
	name = "Pacific Heights"
	icon_state = "pacificheights"
	ambience_index = AMBIENCE_NATURE
	music = /datum/vampiremusic/hollywood
	upper = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/pacificheights/forest
	name = "Pacific Heights Forest Outskirts"
	music = /datum/vampiremusic/forest
	wall_rating = LOW_WALL_RATING

/area/vtm/pacificheights/old
	name = "Pacific Heights - Old District"

/area/vtm/pacificheights/community
	name = "Pacific Heights - Community Road"

/area/vtm/chinatown
	name = "Chinatown"
	icon_state = "chinatown"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/chinatown
	upper = TRUE
	wall_rating = LOW_WALL_RATING	//Kinda chinatown is part of asia and has some deeper connection?

/area/vtm/fishermanswharf
	name = "Fisherman's Wharf"
	icon_state = "fishermanswharf"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/santamonica
	upper = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/fishermanswharf/ghetto
	name = "Fisherman's Wharf - Ghetto"

/area/vtm/fishermanswharf/lower
	name = "Fisherman's Wharf - Lower Beachside"

/area/vtm/northbeach
	name = "Beach"
	icon_state = "northbeach"
	ambience_index = AMBIENCE_BEACH
	music = /datum/vampiremusic/santamonica
	upper = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/unionsquare
	name = "Union Square"
	icon_state = "unionsquare"
	ambience_index = AMBIENCE_CITY
	music = /datum/vampiremusic/downtown
	upper = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/millennium_tower
	name = "Millennium Tower F1"
	icon_state = "millenniumtowerf1"
	music = /datum/vampiremusic/prince
	zone_type = "elysium"
	fire_controled = TRUE

/area/vtm/interior/millennium_tower/f2
	name = "Millennium Tower F2"
	icon_state = "millenniumtowerf2"

/area/vtm/interior/millennium_tower/f3
	name = "Millennium Tower F3 - Security Wing"
	icon_state = "millenniumtowerf3"

/area/vtm/interior/millennium_tower/f4
	name = "Millennium Tower F4 - Executive Floor"
	icon_state = "millenniumtowerf4"

/area/vtm/interior/millennium_tower/f5
	name = "Millennium Tower F5 - Roof Access"
	icon_state = "millenniumtowerf5"
	fire_controled = FALSE

/area/vtm/interior/millennium_tower/ventrue
	name = "Jazz Club Penthouse"
	icon_state = "millenniumtowerpenthouse"

/area/vtm/jazzclub
	name = "Jazz Club"
	icon_state = "camarilla"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	zone_type = "elysium"
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/cabaret
	name = "Siren's Cabaret"
	icon_state = "melpominee"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/cabaret/basement
	name = "Siren's Cabaret - Basement"
	zone_type = "elysium"
/area/vtm/clinic
	name = "Hospital"
	icon_state = "clinic"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	yang_chi = 2
	yin_chi = 0
	wall_rating = HIGH_WALL_RATING

/area/vtm/clinic/haven
	name = "Hospital - Psych Ward"
	zone_type = "elysium"

/area/vtm/supply
	name = "Supply Depot"
	icon_state = "supply"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	wall_rating = HIGH_WALL_RATING

/area/vtm/anarch
	name = "Bar"
	icon_state = "anarch"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	music = /datum/vampiremusic/bar
	zone_type = "elysium"
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/anarch/basement
	name = "Bar - Basement"
	icon_state = "anarch"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	music = /datum/vampiremusic/bar
	zone_type = "elysium"
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/anarch/garage
	name = "Garage"
	icon_state = "anarch"
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/hotel
	name = "Hotel"
	icon_state = "hotel"
	music = /datum/vampiremusic/bar
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/church
	name = "Church Grounds"
	icon_state = "church"
	music = /datum/vampiremusic/forest
	upper = TRUE
	wall_rating = LOW_WALL_RATING

/area/vtm/church/interior
	name = "Church - Interior"
	icon_state = "church"
	music = /datum/vampiremusic/church
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING

/area/vtm/church/interior/staff
	name = "Church - Backrooms"
	icon_state = "church"
	zone_type = "elysium"
	music = /datum/vampiremusic/church
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING

/area/vtm/church/interior/haven
	name = "Church - Restricted Floor"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/church
	ambience_index = AMBIENCE_INTERIOR
	upper = FALSE
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/graveyard
	name = "Graveyard"
	icon_state = "graveyard"
	ambience_index = AMBIENCE_INTERIOR
	music = /datum/vampiremusic/hollywood
	upper = TRUE
	zone_type = "battle"
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/graveyard/interior
	name = "Graveyard Interior"
	icon_state = "interior"
	upper = FALSE
	zone_type = "battle"
	yang_chi = 0
	yin_chi = 2

/area/vtm/park
	name = "Park"
	icon_state = "park"
	ambience_index = AMBIENCE_NATURE
	music = /datum/vampiremusic/downtown
	upper = TRUE
	yang_chi = 2
	yin_chi = 0
	wall_rating = HIGH_WALL_RATING

/area/vtm/sewer
	name = "Sewer"
	icon_state = "sewer"
	ambience_index = AMBIENCE_SEWER
	music = /datum/vampiremusic/sewer
	upper = FALSE
	zone_type = "battle"
	yang_chi = 0
	yin_chi = 2
	wall_rating = HIGH_WALL_RATING

/area/vtm/sewer/nosferatu_town
	name = "Underground Town"
	icon_state = "hotel"
	upper = FALSE
	music = /datum/vampiremusic/nosferatu
	zone_type = "elysium"
	yang_chi = 0
	yin_chi = 2
	wall_rating = HIGH_WALL_RATING

/area/vtm/sewer/cappadocian
	name = "Cappadocian Crypt"
	icon_state = "graveyard"
	ambience_index = AMBIENCE_INTERIOR
	music = /datum/vampiremusic/hollywood
	upper = FALSE
	zone_type = "elysium"
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

// GAROU CENTRIC AREAS
/area/vtm/forest
	name = "Forest"
	icon_state = "park"
	upper = TRUE
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	yang_chi = 2
	yin_chi = 0
	wall_rating = LOW_WALL_RATING	//for werewolves in future

/area/vtm/interior/glasswalker
	name = "Glasswalker's Lab"
	icon_state = "supply"
	upper = FALSE
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/endron_facility
	name = "Endron Headquarters"
	icon_state = "supply"
	zone_type = "masquerade"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 1
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/endron_facility/helipad
	name = "Endron Helipad"
	icon_state = "supply"
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = FALSE
	yang_chi = 0
	yin_chi = 1
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/endron_facility/forest
	name = "Endron Forest Worksite"
	icon_state = "supply"
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 1
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/endron_facility/restricted
	name = "Endron Facility Restricted"
	icon_state = "graveyard"
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/wyrm_corrupted
	name = "Wyrm Corruption"
	icon_state = "graveyard"
	zone_type = "battle"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/cog
	name = "Children of Gaia Generic"
	icon_state = "cog_pantry"

/area/vtm/interior/cog/pantry
	name = "Earth's Bounty Food Pantry"
	icon_state = "cog_pantry"
	music = /datum/vampiremusic/forest
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/cog/caern
	name = "Children of Gaia Caern"
	icon_state = "cog_caern"
	music = /datum/vampiremusic/forest
	zone_type = "elysium"
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/gnawer
	name = "Bone Gnawer Shrine"
	icon_state = "gnawer"
	music = /datum/vampiremusic/forest
	wall_rating = LOW_WALL_RATING

//MISC AND CONTINUED AREAS
/area/vtm/interior/penumbra
	name = "Penumbra"
	icon_state = "church"
	ambience_index = AMBIENCE_NATURE
	upper = FALSE
	zone_type = "battle"
	music = /datum/vampiremusic/penumbra
	fire_controled = FALSE
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/penumbra/enoch
	name = "???"

/area/vtm/interior/chantry
	name = "Chantry"
	icon_state = "theatre"
	zone_type = "elysium"
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2

/area/vtm/interior/chantry/basement
	name = "Chantry Basement"

/area/vtm/interior/theatre
	name = "Theatre"
	icon_state = "theatre"
	music = /datum/vampiremusic/theatre
	zone_type = "elysium"
	fire_controled = TRUE

/area/vtm/interior/oldchurch
	name = "Old Seaside Church"
	icon_state = "church"
	music = /datum/vampiremusic/church
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/museum
	name = "Historical Museum"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/prince
	fire_controled = TRUE
	yang_chi = 0
	yin_chi = 2
	wall_rating = LOW_WALL_RATING // Not all museum pieces are innocent.

/area/vtm/interior/trujah
	name = "Antique Shop"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/prince
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING // something-something safe house to the Shadowlands/Enoch?

/area/vtm/interior/baali
	name = "Alcoholics Anonymous"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/prince
	fire_controled = TRUE
	wall_rating = LOW_WALL_RATING // Holy "All hail Satan" Batman!

/area/vtm/interior/salubri
	name = "Veterinary Clinic"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/prince
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/banu
	name = "Coffee House"
	icon_state = "old_clan_tzimisce"
	music = /datum/vampiremusic/prince
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/banu/haven
	name = "Coffee House Staff Section"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/prince
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/tzimisce_manor
	name = "Clan Tzimisce Manor"
	icon_state = "old_clan_tzimisce"
	zone_type = "elysium"
	music = /datum/vampiremusic/prince
	wall_rating = HIGH_WALL_RATING

/area/vtm/sewer/tzimisce_sanctum
	name = "Clan Tzimisce Sanctum"
	icon_state = "old_clan_sanctum"
	zone_type = "elysium"
	music = /datum/vampiremusic/nosferatu
	wall_rating = LOW_WALL_RATING

/area/vtm/interior/setite
	name = "Community Center"
	icon_state = "hotel"
	upper = FALSE
	fire_controled = TRUE
	wall_rating = HIGH_WALL_RATING

/area/vtm/interior/setite/basement
	name = "Community Center Basement"
	zone_type = "elysium"
	yang_chi = 0
	yin_chi = 2

//MUSIC

/datum/vampiremusic
	var/length = 30 SECONDS
	var/sound
	var/forced = FALSE

/datum/vampiremusic/forest
	length = 389 SECONDS
	sound = 'code/modules/wod13/sounds/night_ambience.ogg'

/datum/vampiremusic/penumbra
	length = 336 SECONDS
	sound = 'code/modules/wod13/sounds/penumbra.ogg'

/datum/vampiremusic/santamonica
	length = 304 SECONDS
	sound = 'code/modules/wod13/sounds/santamonica.ogg'

/datum/vampiremusic/downtown
	length = 259 SECONDS
	sound = 'code/modules/wod13/sounds/downtown.ogg'

/datum/vampiremusic/sewer
	length = 134 SECONDS
	sound = 'code/modules/wod13/sounds/enterlair.ogg'
	forced = TRUE

/datum/vampiremusic/hollywood
	length = 337 SECONDS
	sound = 'code/modules/wod13/sounds/hollywood.ogg'

/datum/vampiremusic/chinatown
	length = 369 SECONDS
	sound = 'code/modules/wod13/sounds/chinatown.ogg'

/datum/vampiremusic/prince
	length = 132 SECONDS
	sound = 'code/modules/wod13/sounds/prince.ogg'
	forced = TRUE

/datum/vampiremusic/church
	length = 91 SECONDS
	sound = 'code/modules/wod13/sounds/hahihaho.ogg'
	forced = TRUE

/datum/vampiremusic/bar
	length = 497 SECONDS
	sound = 'code/modules/wod13/sounds/naive.ogg'
	forced = TRUE

/datum/vampiremusic/theatre
	length = 93 SECONDS
	sound = 'code/modules/wod13/sounds/theatre.ogg'
	forced = TRUE

/datum/vampiremusic/nosferatu
	length = 181 SECONDS
	sound = 'code/modules/wod13/sounds/nosferatu.ogg'
	forced = TRUE

/datum/vampiremusic/elevator
	length = 157 SECONDS
	sound = 'code/modules/wod13/sounds/lift.ogg'
	forced = TRUE

/mob/living/proc/handle_vampire_music()
	if(!client)
		return
	if(stat == DEAD)
		return

	var/turf/T

	if(!isturf(loc))
		var/atom/A = loc
		if(!isturf(A.loc))
			return
		T = A.loc
	else
		T = loc

	if(istype(get_area(T), /area/vtm))
		var/area/vtm/VTM = get_area(T)
		if(VTM)

			var/cacophony = FALSE

			if(iskindred(src))
				var/mob/living/carbon/human/H = src
				if(H.clane)
					if(H.clane.name == CLAN_DAUGHTERS_OF_CACOPHONY)
						cacophony = FALSE //This Variable was TRUE, which makes the DoC music loop play.

			if(!cacophony)
				if(!(client && (client.prefs.toggles & SOUND_AMBIENCE)))
					return

				if(!VTM.music)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					return
				var/datum/vampiremusic/VMPMSC = new VTM.music()
				if(VMPMSC.forced && wait_for_music != VMPMSC.length)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					wasforced = TRUE

				else if(wasforced && wait_for_music != VMPMSC.length)
					client << sound(null, 0, 0, CHANNEL_LOBBYMUSIC)
					last_vampire_ambience = 0
					wait_for_music = 0
					wasforced = FALSE

				if(last_vampire_ambience+wait_for_music+10 < world.time)
					wait_for_music = VMPMSC.length
					client << sound(VMPMSC.sound, 0, 0, CHANNEL_LOBBYMUSIC, 10)
					last_vampire_ambience = world.time
				qdel(VMPMSC)
			else
				if(last_vampire_ambience+wait_for_music+10 < world.time)
					wait_for_music = 1740
					client << sound('code/modules/wod13/sounds/daughters.ogg', 0, 0, CHANNEL_LOBBYMUSIC, 5)
					last_vampire_ambience = world.time

#undef VERY_HIGH_WALL_RATING
#undef HIGH_WALL_RATING
#undef LOW_WALL_RATING
