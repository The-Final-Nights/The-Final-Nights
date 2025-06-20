/obj/item/vamp/keys
	name = "\improper keys"
	desc = "Those can open some doors."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "keys"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/list/accesslocks = list(
		"nothing"
	)
	var/roundstart_fix = FALSE

//===========================VAMPIRE KEYS===========================
/obj/item/vamp/keys/prince
	name = "Prince's keys"
	accesslocks = list(
		"camarilla",
		"prince",
		"clerk",
		"chantry",
		"theatre",
		"milleniumCommon",
		"primogen"
	)
	color = "#bd3327"


/obj/item/vamp/keys/sheriff
	name = "Sheriff's keys"
	accesslocks = list(
		"camarilla",
		"prince",
		"theatre",
		"milleniumCommon",
		"primogen",
		"clerk"
	)
	color = "#bd3327"

/obj/item/vamp/keys/clerk
	name = "Clerk's keys"
	accesslocks = list(
		"camarilla",
		"prince",
		"clerk",
		"theatre",
		"milleniumCommon",
		"primogen"
	)
	color = "#bd3327"

/obj/item/vamp/keys/camarilla
	name = "Millenium Tower Security keys"
	accesslocks = list(
		"milleniumCommon",
		"clerk",
		"camarilla"
	)
	color = "#bd3327"

/obj/item/vamp/keys/camarilla/ghoul
	name = "Millenium Tower Employee keys"
	accesslocks = list(
		"milleniumCommon",
		"clerk",
		"camarilla"
	)
	color = "#bd3327"

/obj/item/vamp/keys/archive
	name = "Archive keys"
	accesslocks = list(
		"chantry"
	)

/obj/item/vamp/keys/regent
	name = "Very archival keys"
	accesslocks = list(
		"chantry",
		"milleniumCommon",
		"primogen",
		"camarilla"
	)

/obj/item/vamp/keys/anarch
	name = "Anarch keys"
	accesslocks = list(
		"anarch"
	)
	color = "#434343"

/obj/item/vamp/keys/bar
	name = "Barkeeper keys"
	accesslocks = list(
		"bar",
		"anarch",
	)
	color = "#434343"

/obj/item/vamp/keys/giovanni
	name = "Mafia keys"
	accesslocks = list(
		"giovanni",
		"bianchiBank"
	)

/obj/item/vamp/keys/capo
	name = "Capo keys"
	accesslocks = list(
		"bankboss",
		"bianchiBank",
		"giovanni"
	)


/obj/item/vamp/keys/baali
	name = "Mystery keys"
	accesslocks = list(
		"baali"
	)

/obj/item/vamp/keys/lasombra
	name = "Dark keys"
	accesslocks = list(
		"lasombra",
		"kyasid",
		"church"
	)
	color = "#290355"

/obj/item/vamp/keys/lasombra/primogen
	name = "Really Dark keys"
	accesslocks = list(
		"lasombra",
		"kyasid",
		"church",
		"primogen",
		"primLasombra",
		"milleniumCommon",
		"camarilla"
	)
	color = "#4b039c"

/obj/item/vamp/keys/trujah
	name = "static keys"
	accesslocks = list(
		"trujah",
		"tmr"
	)

/obj/item/vamp/keys/kiasyd
	name = "Solitary keys"
	accesslocks = list(
		"kiasyd",
		"church",
		"lasombra"
	)
	color = "#580443"

/obj/item/vamp/keys/daughters
	name = "Eclectic keys"
	accesslocks = list(
		"daughters"
	)

/obj/item/vamp/keys/salubri
	name = "Conspiracy keys"
	accesslocks = list(
		"salubri"
	)

/obj/item/vamp/keys/old_clan_tzimisce
	name = "Vintage Regal keys"
	accesslocks = list(
		"old_clan_tzimisce",
		"tmr"
	)

/obj/item/vamp/keys/tzimisce
	name = "Regal keys"
	accesslocks = list(
		"tzimisce"
	)

/obj/item/vamp/keys/tzimisce/manor
	name = "Manor keys"
	accesslocks = list(
		"tzimisce",
		"tzimiscemanor"
	)

/obj/item/vamp/keys/setite
	name = "Serpentine keys"
	accesslocks = list(
		"setite"
	)
	color = "#1805db"

/obj/item/vamp/keys/malkav
	name = "Insane keys"
	accesslocks = list(
		"malkav"
	)
	color = "#8cc4ff"

/obj/item/vamp/keys/malkav/primogen
	name = "Really insane keys"
	accesslocks = list(
		"primMalkav",
		"malkav",
		"primogen",
		"clinic",
		"milleniumCommon",
		"camarilla"
	)
	color = "#2c92ff"

/obj/item/vamp/keys/toreador
	name = "Sexy keys"
	accesslocks = list(
		"toreador",
		"toreador1",
		"toreador2",
		"toreador3",
		"toreador4",
		"strip"
	)
	color = "#ffa7e6"

/obj/item/vamp/keys/banuhaqim
	name = "Just keys"
	accesslocks = list(
		"banuhaqim"
	)
	color = "#06053d"

/obj/item/vamp/keys/banuhaqim/primogen
	name = "Really Just keys"
	accesslocks = list(
		"banuhaqim",
		"primogen",
		"primBanu",
		"police",
		"milleniumCommon",
		"camarilla"
	)
	color = "#05037e"

/obj/item/vamp/keys/toreador/primogen
	name = "Really sexy keys"
	accesslocks = list(
		"primToreador",
		"toreador",
		"toreador1",
		"toreador2",
		"toreador3",
		"toreador4",
		"strip",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#ff2fc4"

/obj/item/vamp/keys/nosferatu
	name = "Ugly keys"
	accesslocks = list(
		"nosferatu"
	)
	color = "#93bc8e"

/obj/item/vamp/keys/nosferatu/primogen
	name = "Really ugly keys"
	accesslocks = list(
		"primNosferatu",
		"nosferatu",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#367c31"

/obj/item/vamp/keys/brujah
	name = "Punk keys"
	accesslocks = list(
		"brujah"
	)
	color = "#ecb586"

/obj/item/vamp/keys/brujah/primogen
	name = "Really punk keys"
	accesslocks = list(
		"primBrujah",
		"brujah",
		"primogen",
		"milleniumCommon",
		"camarilla"
	)
	color = "#ec8f3e"

/obj/item/vamp/keys/ventrue
	name = "Businessy keys"
	accesslocks = list(
		"ventrue"
	)
	color = "#f6ffa7"

/obj/item/vamp/keys/ventrue/primogen
	name = "Really businessy keys"
	accesslocks = list(
		"primVentrue",
		"ventrue",
		"milleniumCommon",
		"primogen",
		"camarilla"
	)
	color = "#e8ff29"

/obj/item/vamp/keys/cappadocian
	name = "Eroded keys"
	accesslocks = list(
		"cappadocian"
	)
	color = "#99620e"

//===========================CLINIC KEYS===========================

/obj/item/vamp/keys/mortician // same as clinic but here for future stuff
	name = "Mortician keys"
	accesslocks = list(
		"clinic"
	)

/obj/item/vamp/keys/clinic
	name = "Clinic keys"
	accesslocks = list(
		"clinic"
	)

/obj/item/vamp/keys/clinics_director
	name = "Clinic director keys"
	accesslocks = list(
		"clinic",
		"clinicsec",
		"director",
		"malkav"
	)

//===========================POLICE KEYS===========================
/obj/item/vamp/keys/police
	name = "Police keys"
	accesslocks = list(
		"police"
	)

/obj/item/vamp/keys/police/federal
	name = "Federal Agent keys"
	accesslocks = list(
		"police",
		"glowie"
	)

/obj/item/vamp/keys/dispatch
	name = "Dispatcher keys"
	accesslocks = list(
		"dispatch"
	)

/obj/item/vamp/keys/police/secure
	name = "Sergeant Police keys"
	accesslocks = list(
		"police",
		"police_secure"
	)

/obj/item/vamp/keys/police/secure/chief
	name = "Chief of Police keys"
	accesslocks = list(
		"dispatch",
		"police",
		"police_secure",
		"police_chief"
	)

//===========================MISC KEYS===========================

/obj/item/vamp/keys/triads
	name = "Rusty keys"
	accesslocks = list(
		"triad",
		"laundromat"
	)

//GAROU KEYS
/obj/item/vamp/keys/techstore
	name = "Tech Store keys"
	accesslocks = list(
		"wolftech"
	)
	color = "#466a72"

/obj/item/vamp/keys/pentex
	name = "Endron Facility keys"
	accesslocks = list(
		"pentex"
	)
	color = "#062e03"

/obj/item/vamp/keys/children_of_gaia
	name = "Food Pantry keys"
	accesslocks = list(
		"coggie"
	)
	color = "#339933"

//JOB KEYS

/obj/item/vamp/keys/graveyard
	name = "Graveyard keys"
	accesslocks = list(
		"graveyard"
	)

/obj/item/vamp/keys/cleaning
	name = "Cleaning keys"
	accesslocks = list(
		"cleaning"
	)

/obj/item/vamp/keys/church
	name = "Church keys"
	accesslocks = list(
		"church"
	)

/obj/item/vamp/keys/hunter
	name = "Creed-Bound keys"
	accesslocks = list(
		"hunter"
	)

/obj/item/vamp/keys/supply
	name = "Supply Depot keys"
	accesslocks = list(
		"supply"
	)
	color = "#434343"

/obj/item/vamp/keys/strip
	name = "Strip Club keys"
	accesslocks = list(
		"strip"
	)

/obj/item/vamp/keys/taxi
	name = "Taxi keys"
	accesslocks = list(
		"taxi"
	)
	color = "#fffb8b"

/obj/item/vamp/keys/apartment
	name = "Apartment keys"
	desc = "The key to someone's home. Hope it's not lost."
	accesslocks = "apartment"
