/obj/effect/decal/rugs
	name = "rugs"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "rugs"

/obj/effect/decal/rugs/Initialize()
	. = ..()
	icon_state = "rugs[rand(1, 11)]"

/obj/structure/vampfence
	name = "\improper fence"
	desc = "Protects places from walking in."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "fence"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/vampfence/corner
	icon_state = "fence_corner"

/obj/structure/vampfence/rich
	icon = 'code/modules/wod13/32x48.dmi'

/obj/structure/vampfence/corner/rich
	icon = 'code/modules/wod13/32x48.dmi'

/obj/structure/vampfence/Initialize()
	.=..()
	AddElement(/datum/element/climbable)

/obj/structure/vampfence/rich/Initialize()
	.=..()
	RemoveElement(/datum/element/climbable)


/obj/structure/gargoyle
	name = "\improper gargoyle"
	desc = "Some kind of gothic architecture."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "gargoyle"
	pixel_z = 8
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYERS_LAYER
	anchored = TRUE

/obj/structure/lamppost
	name = "lamppost"
	desc = "Gives some light to the streets."
	icon = 'code/modules/wod13/lamppost.dmi'
	base_icon_state = "base"
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	var/number_of_lamps
	pixel_w = -32
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/effect/decal/lamplight
	alpha = 0

/obj/effect/decal/lamplight/Initialize()
	. = ..()
	set_light(4, 3, "#ffde9b")

/obj/structure/lamppost/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"
	switch(number_of_lamps)
		if(1)
			switch(dir)
				if(NORTH)
					new /obj/effect/decal/lamplight(get_step(loc, NORTH))
				if(SOUTH)
					new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
				if(EAST)
					new /obj/effect/decal/lamplight(get_step(loc, EAST))
				if(WEST)
					new /obj/effect/decal/lamplight(get_step(loc, WEST))
		if(2)
			switch(dir)
				if(NORTH)
					new /obj/effect/decal/lamplight(get_step(loc, NORTH))
					new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
				if(SOUTH)
					new /obj/effect/decal/lamplight(get_step(loc, NORTH))
					new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
				if(EAST)
					new /obj/effect/decal/lamplight(get_step(loc, EAST))
					new /obj/effect/decal/lamplight(get_step(loc, WEST))
				if(WEST)
					new /obj/effect/decal/lamplight(get_step(loc, EAST))
					new /obj/effect/decal/lamplight(get_step(loc, WEST))
		if(3)
			switch(dir)
				if(NORTH)
					new /obj/effect/decal/lamplight(get_step(loc, NORTH))
					new /obj/effect/decal/lamplight(get_step(loc, EAST))
					new /obj/effect/decal/lamplight(get_step(loc, WEST))
				if(SOUTH)
					new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
					new /obj/effect/decal/lamplight(get_step(loc, EAST))
					new /obj/effect/decal/lamplight(get_step(loc, WEST))
				if(EAST)
					new /obj/effect/decal/lamplight(get_step(loc, EAST))
					new /obj/effect/decal/lamplight(get_step(loc, NORTH))
					new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
				if(WEST)
					new /obj/effect/decal/lamplight(get_step(loc, WEST))
					new /obj/effect/decal/lamplight(get_step(loc, NORTH))
					new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
		if(4)
			new /obj/effect/decal/lamplight(get_step(loc, NORTH))
			new /obj/effect/decal/lamplight(get_step(loc, SOUTH))
			new /obj/effect/decal/lamplight(get_step(loc, EAST))
			new /obj/effect/decal/lamplight(get_step(loc, WEST))
		else
			new /obj/effect/decal/lamplight(loc)

/obj/structure/lamppost/one
	icon_state = "one"
	number_of_lamps = 1

/obj/structure/lamppost/two
	icon_state = "two"
	number_of_lamps = 2

/obj/structure/lamppost/three
	icon_state = "three"
	number_of_lamps = 3

/obj/structure/lamppost/four
	icon_state = "four"
	number_of_lamps = 4

/obj/structure/lamppost/sidewalk
	icon_state = "civ"
	number_of_lamps = 5

/obj/structure/lamppost/sidewalk/chinese
	icon_state = "chinese"

/obj/structure/trafficlight
	name = "traffic light"
	desc = "Shows when road is free or not."
	icon = 'code/modules/wod13/lamppost.dmi'
	icon_state = "traffic"
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	pixel_w = -32
	anchored = TRUE

/obj/structure/trafficlight/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/effect/decal/litter
	name = "litter"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "paper1"

/obj/effect/decal/litter/Initialize()
	. = ..()
	icon_state = "paper[rand(1, 6)]"

/obj/effect/decal/cardboard
	name = "cardboard"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "cardboard1"

/obj/effect/decal/cardboard/Initialize()
	. = ..()
	icon_state = "cardboard[rand(1, 5)]"
	var/matrix/M = matrix()
	M.Turn(rand(0, 360))
	transform = M

/obj/structure/clothingrack
	name = "clothing rack"
	desc = "Have some clothes."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "rack"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/clothingrack/rand
	icon_state = "rack2"

/obj/structure/clothingrack/rand/Initialize()
	. = ..()
	icon_state = "rack[rand(1, 5)]"

/obj/structure/clothinghanger
	name = "clothing hanger"
	desc = "Have some clothes."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "hanger1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/clothinghanger/Initialize()
	. = ..()
	icon_state = "hanger[rand(1, 4)]"

/obj/structure/foodrack
	name = "food rack"
	desc = "Have some food."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "rack2"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -16

/obj/structure/foodrack/Initialize()
	. = ..()
	icon_state = "rack[rand(1, 5)]"

/obj/structure/trashcan
	name = "trash can"
	desc = "Holds garbage inside."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "garbage"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/trashcan/Initialize()
	. = ..()
	if(prob(25))
		icon_state = "garbage_open"
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/trashbag
	name = "trash bag"
	desc = "Holds garbage inside."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "garbage1"
	anchored = TRUE

/obj/structure/trashbag/Initialize()
	. = ..()
	var/garbagestate = rand(1, 9)
	if(garbagestate > 6)
		density = TRUE
	icon_state = "garbage[garbagestate]"

/obj/structure/hotelsign
	name = "sign"
	desc = "It says H O T E L."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "hotel"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/hotelsign/Initialize()
	. = ..()
	set_light(3, 3, "#8e509e")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/hotelbanner
	name = "banner"
	desc = "It says H O T E L."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "banner"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/hotelbanner/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/milleniumsign
	name = "sign"
	desc = "It says M I L L E N I U M."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "millenium"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/milleniumsign/Initialize()
	. = ..()
	set_light(3, 3, "#4299bb")

/obj/structure/anarchsign
	name = "sign"
	desc = "It says B A R."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "bar"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/anarchsign/Initialize()
	. = ..()
	set_light(3, 3, "#ffffff")
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/chinesesign
	name = "sign"
	desc = "雨天和血的机会."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "chinese1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/chinesesign/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/chinesesign/alt
	icon_state = "chinese2"

/obj/structure/chinesesign/alt/alt
	icon_state = "chinese3"

/obj/structure/arc
	name = "chinatown arc"
	desc = "Cool chinese architecture."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "ark1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/arc/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/arc/add
	icon_state = "ark2"

/obj/structure/trad
	name = "traditional lamp"
	desc = "Cool chinese lamp."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "trad"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/vampipe
	name = "pipes"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "piping1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/vamproofwall
	name = "wall"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "the_wall"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/hydrant
	name = "hydrant"
	desc = "Used for firefighting."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "hydrant"
	anchored = TRUE

/obj/structure/hydrant/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/hydrant/MouseDrop_T(atom/dropping, mob/user, params)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_DWARF)) //Only lean on the fire hydrant if we are smol
		LoadComponent(/datum/component/leanable, dropping)

/obj/structure/vampcar
	name = "car"
	desc = "It drives."
	icon = 'code/modules/wod13/cars.dmi'
	icon_state = "taxi"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -16

/obj/structure/vampcar/Initialize()
	. = ..()
	var/atom/movable/M = new(get_step(loc, EAST))
	M.density = TRUE
	M.anchored = TRUE
	dir = pick(NORTH, SOUTH, WEST, EAST)

/obj/structure/roadblock
	name = "\improper road block"
	desc = "Protects places from walking in."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "roadblock"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/roadblock/alt
	icon_state = "barrier"

/obj/machinery/light/prince
	icon = 'code/modules/wod13/icons.dmi'

/obj/machinery/light/prince/ghost

/obj/machinery/light/prince/ghost/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/L = AM
		if(L.client)
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(5, 1, get_turf(src))
			s.start()
			playsound(loc, 'code/modules/wod13/sounds/explode.ogg', 100, TRUE)
			qdel(src)

/obj/machinery/light/prince/broken
	status = LIGHT_BROKEN
	icon_state = "tube-broken"

/obj/effect/decal/painting
	name = "painting"
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "painting1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/decal/painting/second
	icon_state = "painting2"

/obj/effect/decal/painting/third
	icon_state = "painting3"

/obj/structure/jesuscross
	name = "Jesus Christ on a cross"
	desc = "Jesus said, “Father, forgive them, for they do not know what they are doing.” And they divided up his clothes by casting lots (Luke 23:34)."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "cross"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -16
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/roadsign
	name = "road sign"
	desc = "Do not drive your car cluelessly."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "stop"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/roadsign/stop
	name = "stop sign"
	icon_state = "stop"

/obj/structure/roadsign/noparking
	name = "no parking sign"
	icon_state = "noparking"

/obj/structure/roadsign/nopedestrian
	name = "no pedestrian sign"
	icon_state = "nopedestrian"

/obj/structure/roadsign/busstop
	name = "bus stop sign"
	icon_state = "busstop"

/obj/structure/roadsign/speedlimit
	name = "speed limit sign"
	icon_state = "speed50"

/obj/structure/roadsign/speedlimit40
	name = "speed limit sign"
	icon_state = "speed40"

/obj/structure/roadsign/speedlimit25
	name = "speed limit sign"
	icon_state = "speed25"

/obj/structure/roadsign/warningtrafficlight
	name = "traffic light warning sign"
	icon_state = "warningtrafficlight"

/obj/structure/roadsign/warningpedestrian
	name = "pedestrian warning sign"
	icon_state = "warningpedestrian"

/obj/structure/roadsign/parking
	name = "parking sign"
	icon_state = "parking"

/obj/structure/roadsign/crosswalk
	name = "crosswalk sign"
	icon_state = "crosswalk"

/obj/structure/barrels
	name = "barrel"
	desc = "Storage some liquids."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "barrel1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/barrels/rand
	icon_state = "barrel2"

/obj/structure/barrels/rand/Initialize()
	. = ..()
	icon_state = "barrel[rand(1, 12)]"

/obj/structure/bricks
	name = "bricks"
	desc = "Building material."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "bricks"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/effect/decal/pallet
	name = "pallet"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "under1"

/obj/effect/decal/pallet/Initialize()
	. = ..()
	icon_state = "under[rand(1, 2)]"

/obj/effect/decal/trash
	name = "trash"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "trash1"

/obj/effect/decal/trash/Initialize()
	. = ..()
	icon_state = "trash[rand(1, 30)]"

/obj/cargotrain
	name = "cargocrate"
	desc = "It delivers a lot of things."
	icon = 'code/modules/wod13/containers.dmi'
	icon_state = "1"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB | PASSGLASS | PASSCLOSEDTURF
	movement_type = PHASING
	var/mob/living/starter

/obj/cargotrain/Initialize()
	. = ..()
	icon_state = "[rand(2, 5)]"

/obj/cargotrain/Moved(atom/OldLoc, Dir, Forced = FALSE)
	for(var/mob/living/L in get_step(src, Dir))
		if(isnpc(L))
			if(starter)
				if(ishuman(starter))
					var/mob/living/carbon/human/H = starter
					SEND_SIGNAL(H, COMSIG_PATH_HIT, PATH_SCORE_DOWN, 0)
		L.gib()
	..()

/obj/cargocrate
	name = "cargocrate"
	desc = "It delivers a lot of things."
	icon = 'code/modules/wod13/containers.dmi'
	icon_state = "1"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE


/obj/cargocrate/Initialize()
	. = ..()
	icon_state = "[rand(1, 5)]"
	if(icon_state != "1")
		opacity = TRUE
	density = TRUE
	var/atom/movable/M1 = new(get_step(loc, EAST))
	var/atom/movable/M2 = new(get_step(M1.loc, EAST))
	var/atom/movable/M3 = new(get_step(M2.loc, EAST))
	M1.density = TRUE
	if(icon_state != "1")
		M1.opacity = TRUE
	M1.anchored = TRUE
	M2.density = TRUE
	if(icon_state != "1")
		M2.opacity = TRUE
	M2.anchored = TRUE
	M3.density = TRUE
	if(icon_state != "1")
		M3.opacity = TRUE
	M3.anchored = TRUE

/proc/get_nearest_free_turf(turf/start)
	if(isopenturf(get_step(start, EAST)))
		if(isopenturf(get_step(get_step(start, EAST), EAST)))
			if(isopenturf(get_step(get_step(get_step(start, EAST), EAST), EAST)))
				if(isopenturf(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST)))
					if(isopenturf(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST)))
						if(isopenturf(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST)))
							if(isopenturf(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST)))
								if(isopenturf(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)))
									if(isopenturf(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)))
										if(isopenturf(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)))
											if(isopenturf(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)))
												return get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)
											return get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)
										return get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)
									return get_step(get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST), EAST)
								return get_step(get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST), EAST)
							return get_step(get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST), EAST)
						return get_step(get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST), EAST)
					return get_step(get_step(get_step(get_step(start, EAST), EAST), EAST), EAST)
				return get_step(get_step(get_step(start, EAST), EAST), EAST)
			return get_step(get_step(start, EAST), EAST)
		return get_step(start, EAST)
	return start

/obj/structure/marketplace
	name = "stock market"
	desc = "Recent stocks visualization."
	icon = 'code/modules/wod13/stonks.dmi'
	icon_state = "marketplace"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -24
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/fuelstation
	name = "fuel station"
	desc = "Fuel your car here. 50 dollars per 1000 units."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "fuelstation"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/stored_money = 0

/obj/structure/fuelstation/AltClick(mob/user)
	if(stored_money)
		say("Money refunded.")
		for(var/i in 1 to stored_money)
			new /obj/item/stack/dollar(loc)
		stored_money = 0

/obj/structure/fuelstation/examine(mob/user)
	. = ..()
	. += "<b>Balance</b>: [stored_money] dollars"

/obj/structure/fuelstation/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/D = I
		stored_money += D.amount
		to_chat(user, "<span class='notice'>You insert [D.amount] dollars into [src].</span>")
		qdel(I)
		say("Payment received.")
	if(istype(I, /obj/item/gas_can))
		var/obj/item/gas_can/G = I
		if(G.stored_gasoline < 1000 && stored_money)
			var/gas_to_dispense = min(stored_money*20, 1000-G.stored_gasoline)
			var/money_to_spend = round(gas_to_dispense/20)
			G.stored_gasoline = min(1000, G.stored_gasoline+gas_to_dispense)
			stored_money = max(0, stored_money-money_to_spend)
			playsound(loc, 'code/modules/wod13/sounds/gas_fill.ogg', 50, TRUE)
			to_chat(user, "<span class='notice'>You fill [I].</span>")
			say("Gas filled.")


/obj/structure/reagent_dispensers/cleaningfluid
	name = "cleaning fluid tank"
	desc = "A container filled with cleaning fluid."
	reagent_id = /datum/reagent/space_cleaner
	icon_state = "water"

/obj/structure/rack/tacobell
	name = "table"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "tacobell"

/obj/structure/rack/tacobell/attack_hand(mob/living/user)
	return

/obj/structure/rack/tacobell/horizontal
	icon_state = "tacobell1"

/obj/structure/rack/tacobell/vertical
	icon_state = "tacobell2"

/obj/structure/rack/tacobell/south
	icon_state = "tacobell3"

/obj/structure/rack/tacobell/north
	icon_state = "tacobell4"

/obj/structure/rack/tacobell/east
	icon_state = "tacobell5"

/obj/structure/rack/tacobell/west
	icon_state = "tacobell6"

/obj/structure/rack/bubway
	name = "table"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "bubway"

/obj/structure/rack/bubway/attack_hand(mob/living/user)
	return

/obj/structure/rack/bubway/horizontal
	icon_state = "bubway1"

/obj/structure/rack/bubway/vertical
	icon_state = "bubway2"

/obj/structure/rack/bubway/south
	icon_state = "bubway3"

/obj/structure/rack/bubway/north
	icon_state = "bubway4"

/obj/structure/rack/bubway/east
	icon_state = "bubway5"

/obj/structure/rack/bubway/west
	icon_state = "bubway6"

/obj/bacotell
	name = "Baco Tell"
	desc = "Eat some precious tacos and pizza!"
	icon = 'code/modules/wod13/fastfood.dmi'
	icon_state = "bacotell"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	pixel_w = -16

/obj/bubway
	name = "BubWay"
	desc = "Eat some precious burgers and pizza!"
	icon = 'code/modules/wod13/fastfood.dmi'
	icon_state = "bubway"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	pixel_w = -16

/obj/gummaguts
	name = "Gumma Guts"
	desc = "Eat some precious chicken nuggets and donuts!"
	icon = 'code/modules/wod13/fastfood.dmi'
	icon_state = "gummaguts"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	pixel_w = -16

/obj/underplate
	name = "underplate"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "underplate"
	plane = GAME_PLANE
	layer = TABLE_LAYER
	anchored = TRUE

/obj/underplate/stuff
	icon_state = "stuff"

/obj/order
	name = "order sign"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "order"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

/obj/order1
	name = "order screen"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "order1"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

/obj/order2
	name = "order screen"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "order2"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

/obj/order3
	name = "order screen"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "order3"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

/obj/order4
	name = "order screen"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "order4"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

/obj/matrix
	name = "matrix"
	desc = "Suicide is no exit..."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "matrix"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/matrix/attack_hand(mob/user)
	if(user.client)
		if(iswerewolf(user))
			to_chat(user, span_warning("Return to your homid form before you matrix!"))
			return TRUE
		if(do_after(user, 100, src))
			cryoMob(user, src)
	return TRUE

/obj/matrix/proc/cryoMob(mob/living/mob_occupant)
	var/list/crew_member = list()
	crew_member["name"] = mob_occupant.real_name
	if(mob_occupant.mind && mob_occupant.mind.assigned_role)
		// Handle job slot/tater cleanup.
		var/job = mob_occupant.mind.assigned_role
		crew_member["job"] = job
		SSjob.FreeRole(job, mob_occupant)
		mob_occupant.mind.special_role = null
	else
		crew_member["job"] = "N/A"

	// Delete them from datacore.
	for(var/datum/data/record/medical_record as anything in GLOB.data_core.medical)
		if(medical_record.fields["name"] == mob_occupant.real_name)
			qdel(medical_record)
	for(var/datum/data/record/security_record as anything in GLOB.data_core.security)
		if(security_record.fields["name"] == mob_occupant.real_name)
			qdel(security_record)
	for(var/datum/data/record/general_record as anything in GLOB.data_core.general)
		if(general_record.fields["name"] == mob_occupant.real_name)
			qdel(general_record)

	if(mob_occupant.bloodhunted)
		SSbloodhunt.hunted -= mob_occupant
		mob_occupant.bloodhunted = FALSE
		SSbloodhunt.update_shit()

	// Ghost and delete the mob.
	if(!mob_occupant.get_ghost(TRUE))
		if(world.time < 15 MINUTES) // before the 15 minute mark
			mob_occupant.ghostize(FALSE) // Players despawned too early may not re-enter the game
		else
			mob_occupant.ghostize(TRUE)
	QDEL_NULL(mob_occupant)

/obj/structure/billiard_table
	name = "billiard table"
	desc = "Come here, play some BALLS. I know you want it so much..."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "billiard1"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/billiard_table/Initialize()
	. = ..()
	icon_state = "billiard[rand(1, 3)]"

/obj/police_department
	name = "San Francisco Police Department"
	desc = "Stop right there you criminal scum! Nobody can break the law on my watch!!"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "police"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	pixel_z = 40

/obj/structure/pole
	name = "stripper pole"
	desc = "A pole fastened to the ceiling and floor, used to show of ones goods to company."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "pole"
	density = TRUE
	anchored = TRUE
	var/icon_state_inuse
	layer = 4 //make it the same layer as players.
	density = 0 //easy to step up on

/obj/structure/pole/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(obj_flags & IN_USE)
		to_chat(user, "It's already in use - wait a bit.")
		return
	if(user.dancing)
		return
	else
		obj_flags |= IN_USE
		user.setDir(SOUTH)
		user.Stun(100)
		user.forceMove(src.loc)
		animatepole(user)
		user.layer = layer //set them to the poles layer
		obj_flags &= ~IN_USE
		user.pixel_y = 0
		icon_state = initial(icon_state)

/obj/structure/pole/proc/animatepole(mob/living/user)
	return

/obj/structure/pole/animatepole(mob/living/user)

	if (user.loc != src.loc)
		return
	animate(user,pixel_x = -6, pixel_y = 0, time = 10)
	sleep(20)
	user.dir = 4
	animate(user,pixel_x = -6,pixel_y = 24, time = 10)
	sleep(12)
	src.layer = 4.01 //move the pole infront for now. better to move the pole, because the character moved behind people sitting above otherwise
	animate(user,pixel_x = 6,pixel_y = 12, time = 5)
	user.dir = 8
	sleep(6)
	animate(user,pixel_x = -6,pixel_y = 4, time = 5)
	user.dir = 4
	src.layer = 4 // move it back.
	sleep(6)
	user.dir = 1
	animate(user,pixel_x = 0, pixel_y = 0, time = 3)
	sleep(6)
	user.do_jitter_animation()
	sleep(6)
	user.dir = 2

/obj/structure/strip_club
	name = "sign"
	desc = "It says DO RA. Maybe it's some kind of strip club..."
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "dora"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	pixel_w = -8
	pixel_z = 32

/obj/structure/strip_club/Initialize()
	. = ..()
	set_light(3, 2, "#8e509e")

/obj/structure/cabaret_sign
	name = "cabaret"
	desc = "An enticing pair of legs... I wonder what's inside?"
	icon = 'icons/cabaret.dmi'
	icon_state = "cabar"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/cabaret_sign/Initialize()
	. = ..()
	set_light(3, 2, "#d98aec")

/obj/structure/cabaret_sign2
	name = "cabaret"
	desc = "An enticing pair of legs... I wonder what's inside?"
	icon = 'icons/cabaret.dmi'
	icon_state = "et"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/cabaret_sign2/Initialize()
	. = ..()
	set_light(3, 2, "#d98aec")

/obj/structure/fire_barrel
	name = "barrel"
	desc = "Some kind of light and warm source..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "barrel"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/fire_barrel/Initialize()
	. = ..()
	set_light(3, 2, "#ffa800")

/obj/structure/fountain
	name = "fountain"
	desc = "Gothic water structure."
	icon = 'code/modules/wod13/fountain.dmi'
	icon_state = "fountain"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -16
	pixel_z = -16

/obj/structure/coclock
	name = "clock"
	desc = "See the time."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "clock"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	pixel_z = 32

/obj/structure/coclock/examine(mob/user)
	. = ..()
	to_chat(user, "<b>[SScity_time.timeofnight]</b>")

/obj/structure/coclock/grandpa
	icon = 'code/modules/wod13/grandpa_cock.dmi'
	icon_state = "cock"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	pixel_z = 0

/turf/open/floor/plating/bloodshit
	gender = PLURAL
	name = "blood"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "blood"
	flags_1 = NONE
	attachment_holes = FALSE
	bullet_bounce_sound = null
	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER

/turf/open/floor/plating/bloodshit/Initialize()
	. = ..()
	for(var/mob/living/L in src)
		if(L)
			L.death()
	spawn(5)
		for(var/turf/T in range(1, src))
			if(T && !istype(T, /turf/open/floor/plating/bloodshit))
				new /turf/open/floor/plating/bloodshit(T)

/obj/american_flag
	name = "american flag"
	desc = "PATRIOTHICC!!!"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "flag_usa"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

//flags

/obj/flag
	name = "DO NOT USE"
	desc = "This shouldn't be used. If you see this in-game, someone has fucked up."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "flag_usa"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE

/obj/flag/usa
	name = "flag of the United States"
	desc = "The flag of the United States of America. In God we trust!"
	icon_state = "flag_usa"

/obj/flag/california
	name = "flag of California"
	desc = "The flag of the great State of California. Eureka!"
	icon_state = "flag_california"

/obj/flag/britain
	name = "flag of Great Britain"
	desc = "The flag of the United Kingdom of Great Britain and Northern Ireland. Dieu et mon droit!"
	icon_state = "flag_britain"

/obj/flag/france
	name = "flag of France"
	desc = "The flag of the French Republic. Liberte, egalite, fraternite!"
	icon_state = "flag_france"

/obj/flag/germany
	name = "flag of Germany"
	desc = "The flag of the Federal Republic of Germany."
	icon_state = "flag_germany"

/obj/flag/spain
	name = "flag of Spain"
	desc = "The flag of the Kingdom of Spain. Plus ultra!"
	icon_state = "flag_spain"

/obj/flag/italy
	name = "flag of Italy"
	desc = "The flag of the Republic of Italy."
	icon_state = "flag_italy"

/obj/flag/vatican
	name = "flag of the Vatican"
	desc = "The flag of Vatican City."
	icon_state = "flag_vatican"

/obj/flag/russia
	name = "flag of Russia"
	desc = "The flag of the Russian Federation."
	icon_state = "flag_russia"

/obj/flag/soviet
	name = "flag of the Soviet Union"
	desc = "The flag of the Union of Socialist Soviet Republics. Workers of the world, unite!"
	icon_state = "flag_soviet"

/obj/flag/china
	name = "flag of China"
	desc = "The flag of the People's Republic of China."
	icon_state = "flag_china"

/obj/flag/taiwan
	name = "flag of Taiwan"
	desc = "The flag of the Republic of China."
	icon_state = "flag_taiwan"

/obj/flag/japan
	name = "flag of Japan"
	desc = "The flag of the State of Japan."
	icon_state = "flag_japan"

/obj/flag/anarchy
	name = "anarchist flag"
	desc = "The flag of the anarchist movement."
	icon_state = "flag_anarchy"

/obj/effect/decal/graffiti
	name = "graffiti"
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "graffiti1"
	pixel_z = 32
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	var/large = FALSE

/obj/effect/decal/graffiti/large
	pixel_w = -16
	icon = 'code/modules/wod13/64x64.dmi'
	large = TRUE

/obj/effect/decal/graffiti/Initialize()
	. = ..()
	if(!large)
		icon_state = "graffiti[rand(1, 15)]"
	else
		icon_state = "graffiti[rand(1, 3)]"

/obj/structure/roofstuff
	name = "roof ventilation"
	desc = "Air to inside."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "roof1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE

/obj/structure/roofstuff/Initialize()
	. = ..()
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)]-snow"

/obj/structure/roofstuff/alt1
	icon_state = "roof2"
	density = FALSE

/obj/structure/roofstuff/alt2
	icon_state = "roof3"

/obj/structure/roofstuff/alt3
	icon_state = "roof4"

/obj/effect/decal/kopatich
	name = "hide carpet"
	pixel_w = -16
	pixel_z = -16
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "kopatich"

/obj/effect/decal/baalirune
	name = "satanic rune"
	pixel_w = -16
	pixel_z = -16
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "baali"
	var/total_corpses = 0

/obj/effect/decal/baalirune/attack_hand(mob/living/user)
	. = ..()
	var/mob/living/carbon/human/H = locate() in get_turf(src)
	if(H)
		if(H.stat == DEAD)
			H.gib()
			total_corpses += 1
			if(total_corpses >= 20)
				total_corpses = 0
				playsound(get_turf(src), 'sound/magic/demon_dies.ogg', 100, TRUE)
				new /mob/living/simple_animal/hostile/baali_guard(get_turf(src))

/obj/structure/vamptree
	name = "tree"
	desc = "Cute and tall flora."
	icon = 'code/modules/wod13/trees.dmi'
	icon_state = "tree1"
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -32
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/burned = FALSE

/obj/structure/vamptree/Initialize()
	. = ..()
	icon_state = "tree[rand(1, 11)]"
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "[initial(icon_state)][rand(1, 11)]-snow"

/obj/structure/vamptree/proc/burnshit()
	if(!burned)
		burned = TRUE
		icon_state = "dead[rand(1, 3)]"

/obj/structure/vamptree/pine
	name = "pine"
	desc = "Cute and tall flora."
	icon = 'code/modules/wod13/pines.dmi'
	icon_state = "pine1"
	plane = GAME_PLANE
	layer = SPACEVINE_LAYER
	anchored = TRUE
	density = TRUE
	pixel_w = -24
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/vamptree/pine/Initialize()
	. = ..()
	icon_state = "pine[rand(1, 4)]"
	if(GLOB.winter)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.upper)
				icon_state = "pine[rand(1, 4)]-snow"
	if(prob(2))
		burned = TRUE
		icon_state = "dead[rand(1, 5)]"

/obj/structure/vamptree/pine/burnshit()
	if(!burned)
		burned = TRUE
		icon_state = "dead[rand(1, 5)]"

/obj/structure/vampstatue
	name = "statue"
	desc = "A cloaked figure forgotten to the ages."
	icon = 'icons/effects/32x64.dmi'
	icon_state = "statue"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/vampstatue/angel
	name = "angel statue"
	desc = "An angel stands before you. You're glad it's only stone."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "angelstatue"

/obj/structure/vampstatue/cloaked
	name = "cloaked figure"
	desc = "He appears to be sitting."
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "cloakedstatue"

/obj/structure/bath
	name = "bath"
	desc = "Not big enough for hiding in."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "tub"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/bath/sabbatbath
	name = "sabbat bath"
	desc = "A large ceremonial bath, commonly used in Sabbat rituals. It appears to be designed to hold blood."
	icon_state = "tub"
	can_buckle = TRUE
	buckle_lying = 90
	layer = BELOW_MOB_LAYER
	var/blood_level = 0
	var/max_blood = 500
	var/list/blood_donors = list() // List to store blood donors

/obj/structure/bath/sabbatbath/Initialize()
	. = ..()
	create_reagents(max_blood, INJECTABLE)
	update_icon()

/obj/structure/bath/sabbatbath/examine(mob/user)
	. = ..()
	if(blood_level <= 0)
		. += span_notice("The bath is empty.")
	else
		. += span_notice("The bath is filled with blood.")

	if(length(blood_donors) > 0)
		. += span_notice("You can sense [length(blood_donors)] different blood donor[length(blood_donors) == 1 ? "" : "s"] in the mixture.")

/obj/structure/bath/sabbatbath/update_icon()
	. = ..()
	// Change the sprite when it contains blood
	if(blood_level > 0)
		icon_state = "bath_full_blood"
	else
		icon_state = "tub"

/obj/structure/bath/sabbatbath/attackby(obj/item/W, mob/living/carbon/user, params)
	if(istype(W, /obj/item/sabbat_priest_tome))
		if(user.mind && is_sabbat_priest(user) && has_buckled_mobs())
			var/mob/living/buckled_mob = buckled_mobs[1]
			if(buckled_mob.mind)
				// First, demote any existing Ductus to regular Sabbat Pack
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					if(H.mind && is_sabbat_ductus(H))
						H.mind.assigned_role = "Sabbat Pack"
						var/datum/antagonist/temp_antag = new()
						temp_antag.remove_antag_hud(ANTAG_HUD_REV, H)
						temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev", H)
						qdel(temp_antag)

						to_chat(H, span_cult("You feel your authority as Ductus slipping away... You are now a regular pack member..."))
				// Then promote the new Ductus
				buckled_mob.mind.assigned_role = "Sabbat Ductus"
				var/datum/antagonist/temp_antag = new()
				temp_antag.add_antag_hud(ANTAG_HUD_REV, "rev_head", buckled_mob)
				qdel(temp_antag)
				// Notify all Sabbat members of the new Ductus
				for(var/mob/living/carbon/human/sabbat_member in GLOB.player_list)
					if(sabbat_member.mind && is_sabbatist(sabbat_member))
						to_chat(sabbat_member, span_cult("[buckled_mob] has been anointed as the new Ductus of the pack!"))

				to_chat(buckled_mob, span_cult("You have been anointed as the new Ductus of the pack!"))
		return
	if(istype(W, /obj/item/melee/vampirearms/knife))
		playsound(loc,'sound/weapons/bladeslice.ogg', 50, FALSE)
		if(do_after(user, 100))
			if(user.bloodpool <= 0)
				to_chat(user, span_warning("You have no blood to donate!"))
				return

			user.visible_message(span_notice("[user] cuts [user.p_their()] wrist and lets blood flow into the bath."), span_notice("You cut your wrist and let blood flow into the bath."))

			// Calculate how much blood to transfer
			var/amount_to_donate = min(user.bloodpool, 3)

			// Subtract blood from user
			user.bloodpool -= amount_to_donate

			// Add blood to bath
			blood_level = min(blood_level + amount_to_donate, max_blood)
			reagents.add_reagent(/datum/reagent/blood, amount_to_donate)

			// Add donor to list if not already there
			if(!(user in blood_donors))
				blood_donors += user

			// Update the tub to show blood
			update_icon()

			return TRUE
		else
			to_chat(user, span_warning("You decide not to add your blood to the bathtub..."))

	// Handle vaulderie goblet specifically so that the Priest can use the tub's blood for vaulderie (part of the blood bath rite)
	if(istype(W, /obj/item/reagent_containers/food/drinks/silver_goblet/vaulderie_goblet))
		var/obj/item/reagent_containers/food/drinks/silver_goblet/vaulderie_goblet/goblet = W
		if(blood_level <= 0)
			to_chat(user, span_warning("The bath is empty."))
			return

		var/transfer_amount = min(goblet.volume - goblet.reagents.total_volume, blood_level)
		if(transfer_amount <= 0)
			to_chat(user, span_warning("The goblet is already full."))
			return

		user.visible_message(span_notice("[user] scoops blood from the bath into [goblet]."), span_notice("You scoop blood from the bath into [goblet]."))

		// Transfer blood
		reagents.trans_to(goblet, transfer_amount)
		blood_level -= transfer_amount

		// Transfer donor information
		if(length(blood_donors) > 0)
			goblet.blood_donors = blood_donors

		// Update icon if the bath is now empty
		if(blood_level <= 0)
			update_icon()

		return TRUE

	return ..()

/obj/structure/bath/sabbatbath/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	. = ..()
	if(. && blood_level > 0)
		playsound(loc, 'code/modules/wod13/sounds/catched.ogg', 50, FALSE)
		if(do_after(user, 100))
			if(M == user)
				M.visible_message(span_notice("[user] climbs into the blood-filled bath."), span_notice("You climb into the blood-filled bath."))
			else
				M.visible_message(span_notice("[user] places [M] in the blood-filled bath."), span_notice("[user] places you in the blood-filled bath."))


/obj/structure/bath/sabbatbath/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	. = ..()
	if(.)
		if(buckled_mob == user)
			buckled_mob.visible_message(span_notice("[buckled_mob] climbs out of the bath."), span_notice("You climb out of the bath."))
		else
			buckled_mob.visible_message(span_notice("[user] pulls [buckled_mob] out of the bath."), span_notice("[user] pulls you out of the bath."))

		// Create blood splatters as they exit
		if(blood_level > 0 && ishuman(buckled_mob))
			var/turf/T = get_turf(src)
			for(var/turf/adjacent in RANGE_TURFS(1, T))
				if(prob(40) && adjacent != T)
					buckled_mob.add_splatter_floor(adjacent)


/obj/weapon_showcase
	name = "weapon showcase"
	desc = "Look, a gun."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "showcase"
	density = TRUE
	anchored = TRUE
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/weapon_showcase/Initialize()
	. = ..()
	icon_state = "showcase[rand(1, 7)]"

/obj/effect/decal/carpet
	name = "carpet"
	pixel_w = -16
	pixel_z = -16
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "kover"

/obj/structure/vamprocks
	name = "rock"
	desc = "Rokk."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "rock1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/vamprocks/Initialize()
	. = ..()
	icon_state = "rock[rand(1, 9)]"

/obj/structure/small_vamprocks
	name = "rock"
	desc = "Rokk."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "smallrock1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/small_vamprocks/Initialize()
	. = ..()
	icon_state = "smallrock[rand(1, 6)]"

/obj/structure/big_vamprocks
	name = "rock"
	desc = "Rokk."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "rock1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	pixel_w = -16

/obj/structure/big_vamprocks/Initialize()
	. = ..()
	icon_state = "rock[rand(1, 4)]"

/obj/structure/stalagmite
	name = "stalagmite"
	desc = "Rokk."
	icon = 'code/modules/wod13/64x64.dmi'
	icon_state = "stalagmite1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	pixel_w = -16

/obj/structure/stalagmite/Initialize()
	. = ..()
	icon_state = "stalagmite[rand(1, 5)]"

/obj/were_ice
	name = "ice block"
	desc = "Stores some precious organs..."
	icon = 'code/modules/wod13/werewolf_lupus.dmi'
	icon_state = "ice_man"
	plane = GAME_PLANE
	layer = CAR_LAYER
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/were_ice/lupus
	icon_state = "ice_wolf"

/obj/were_ice/crinos
	icon = 'code/modules/wod13/werewolf.dmi'
	icon_state = "ice"
	pixel_w = -8

/obj/structure/bury_pit
	name = "bury pit"
	desc = "You can bury someone here."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "pit0"
	plane = GAME_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/burying = FALSE

/obj/structure/bury_pit/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/melee/vampirearms/shovel))
		if(!burying)
			burying = TRUE
			user.visible_message(span_warning("[user] starts to dig [src]"), span_warning("You start to dig [src]."))
			if(do_after(user, 20 SECONDS))
				burying = FALSE
				if(icon_state == "pit0")
					var/dead_amongst = FALSE
					var/kindred_buried = FALSE
					var/list/buried_kindred = list() // Track buried kindred for frenzy

					for(var/mob/living/L in get_turf(src))
						L.forceMove(src) // Move the mob into the pit
						if(L.stat == DEAD)
							dead_amongst = TRUE

						// Check if the buried mob is kindred
						if(istype(L, /mob/living/carbon) && ishuman(L))
							var/mob/living/carbon/human/H = L
							if(istype(H.dna.species, /datum/species/kindred))
								kindred_buried = TRUE
								buried_kindred += L
								// Visual message for being buried
								to_chat(L, span_userdanger("You are buried alive! The weight of the earth presses down on you, and panic begins to rise!"))
								user.visible_message(span_warning("[L] struggles as they are buried!"))

					// Update the pit state
					icon_state = "pit1"
					user.visible_message(span_warning("[user] digs a hole in [src]."), span_warning("You dig a hole in [src]."))

					if(dead_amongst)
						call_dharma("respect", user)
					for(var/mob/living/carbon/K in buried_kindred)
						if(do_after(K, 120 SECONDS, target = K, progress = TRUE))
							kindred_frenzy_escape(K)
						else
							to_chat(K, span_warning("Your escape was interrupted!"))

					// Only refill the pit if no one is buried
					if(!dead_amongst && !kindred_buried)
						user.visible_message(span_warning("[user] refills [src]."), span_warning("You refill [src]."))
						qdel(src)
				else
					// Digging up the pit
					var/dead_amongst = FALSE
					for(var/mob/living/L in src) // This ensures we actually get the mobs from inside the pit
						L.forceMove(get_turf(src))
						if(L.stat == DEAD)
							dead_amongst = TRUE

					icon_state = "pit0"
					user.visible_message(span_warning("[user] digs open [src]."), span_warning("You dig open [src]."))

					if(dead_amongst)
						call_dharma("disrespect", user)
			else
				burying = FALSE

/// Process for kindred to enter frenzy and escape the burial pit
/obj/structure/bury_pit/proc/kindred_frenzy_escape(mob/living/carbon/kindred)
	if(!kindred || !istype(kindred) || kindred.stat == DEAD || !(kindred in src))
		return

	kindred.enter_frenzymod()
	to_chat(kindred, span_userdanger("The Beast within you awakens with primal fury! You will NOT be contained!"))

	visible_message(span_danger("[src] begins to shake violently as something struggles underneath!"))

	// After a brief delay, the kindred breaks free
	addtimer(CALLBACK(src, PROC_REF(complete_kindred_escape), kindred), 5 SECONDS)

	// Exit frenzy after 30 seconds
	addtimer(CALLBACK(kindred, TYPE_PROC_REF(/mob/living/carbon, exit_frenzymod)), 30 SECONDS)

/obj/structure/bury_pit/proc/complete_kindred_escape(mob/living/carbon/kindred)
	if(!kindred || !istype(kindred) || !(kindred in src))
		return
	kindred.SetParalyzed(0)
	kindred.SetStun(0)
	kindred.SetUnconscious(0)
	kindred.SetSleeping(0)
	kindred.SetImmobilized(0)

	kindred.adjustBruteLoss(-50)
	kindred.adjustFireLoss(-50)

	// Move the kindred out of the pit
	kindred.forceMove(get_turf(src))
	icon_state = "pit0" // Pit is now open

	// Visual effects
	visible_message("<span class='danger'>[kindred] bursts from [src] in a frenzy, dirt flying everywhere!</span>")

/obj/structure/bury_pit/container_resist_act(mob/living/user)
	if(!burying)
		burying = TRUE
		if(do_mob(user, src, 30 SECONDS))
			for(var/mob/living/L in src)
				L.forceMove(get_turf(src))
			icon_state = "pit0"
			burying = FALSE
		else
			burying = FALSE
