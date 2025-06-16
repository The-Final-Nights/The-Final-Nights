// Uniform slot
/datum/gear/uniform
	subtype_path = /datum/gear/uniform
	slot = ITEM_SLOT_ICLOTHING
	sort_category = "Uniforms and Casual Dress"
	cost = 3

// Suits (and suitskirts)
/datum/gear/uniform/suit
	subtype_path = /datum/gear/uniform/suit
	cost = 4 // Suits aren't cheap!

/datum/gear/uniform/suit/fancy_gray
	display_name = "fancy suit, gray"
	path = /obj/item/clothing/under/vampire/fancy_gray

/datum/gear/uniform/suit/fancy_red
	display_name = "fancy suit, red"
	path = /obj/item/clothing/under/vampire/fancy_red

/datum/gear/uniform/suit/fancy_black
	display_name = "luxury suit, black"
	path = /obj/item/clothing/under/vampire/ventrue

/datum/gear/uniform/suit/fancy_black_skirt
	display_name = "luxury suitskirt, black"
	path = /obj/item/clothing/under/vampire/ventrue/female

/datum/gear/uniform/suit/formal_white
	display_name = "plain suit, white"
	path = /obj/item/clothing/under/vampire/office

/datum/gear/uniform/suit/formal_burgundy
	display_name = "plain suit, burgundy"
	path = /obj/item/clothing/under/vampire/tremere

/datum/gear/uniform/suit/formal_burgundy_skirt
	display_name = "plain suitskirt, burgundy"
	path = /obj/item/clothing/under/vampire/tremere/female

/datum/gear/uniform/suit/plain_black
	display_name = "plain suit, black"
	path = /obj/item/clothing/under/vampire/suit

/datum/gear/uniform/suit/plain_black_skirt
	display_name = "plain suitskirt, black"
	path = /obj/item/clothing/under/vampire/suit/female

/datum/gear/uniform/suit/plain_red
	display_name = "plain suit, red"
	path = /obj/item/clothing/under/vampire/sheriff

/datum/gear/uniform/suit/plain_red_skirt
	display_name = "plain suitskirt, red"
	path = /obj/item/clothing/under/vampire/sheriff/female

/datum/gear/uniform/suit/plain_blue
	display_name = "plain suit, blue"
	path = /obj/item/clothing/under/vampire/clerk

/datum/gear/uniform/suit/plain_blue_skirt
	display_name = "plain suitskirt, blue"
	path = /obj/item/clothing/under/vampire/clerk/female

/datum/gear/uniform/suit/plain_brown
	display_name = "plain suit, brown"
	description = "Some business clothes." // Consistency
	path = /obj/item/clothing/under/vampire/archivist

/datum/gear/uniform/suit/plain_brown_skirt
	display_name = "plain suitskirt, brown"
	description = "Some business clothes." // Consistency!
	path = /obj/item/clothing/under/vampire/archivist/female

/datum/gear/uniform/suit/prince
	display_name = "prince suit"
	path = /obj/item/clothing/under/vampire/prince
	allowed_roles = list("Prince")

/datum/gear/uniform/suit/prince_skirt
	display_name = "prince suitskirt"
	path = /obj/item/clothing/under/vampire/prince/female
	allowed_roles = list("Prince")

// Skirt
/datum/gear/uniform/skirt
	subtype_path = /datum/gear/uniform/skirt

/datum/gear/uniform/skirt/pentagram
	display_name = "outfit, skirt pentagram"
	description = "A red pentagram on a black t-shirt." // Shortened, as we don't want to bloat the menu with long descriptions
	path = /obj/item/clothing/under/vampire/baali/female

// Turtleneck
/datum/gear/uniform/turtleneck
	subtype_path = /datum/gear/uniform/turtleneck

/datum/gear/uniform/turtleneck/black
	display_name = "turtleneck, black"
	description = "A black turtleneck" // Consistency!
	path = /obj/item/clothing/under/vampire/turtleneck_black

/datum/gear/uniform/turtleneck/navy
	display_name = "turtleneck, navy"
	path = /obj/item/clothing/under/vampire/turtleneck_navy

/datum/gear/uniform/turtleneck/red
	display_name = "turtleneck, red"
	path = /obj/item/clothing/under/vampire/turtleneck_red

/datum/gear/uniform/turtleneck/white
	display_name = "turtleneck, white"
	description = "A white turtleneck" // Consistency!
	path = /obj/item/clothing/under/vampire/turtleneck_white

// Pants
/datum/gear/uniform/pants
	subtype_path = /datum/gear/uniform/pants
	cost = 2

/datum/gear/uniform/pants/leather
	display_name = "pants, leather"
	path = /obj/item/clothing/under/vampire/leatherpants

/datum/gear/uniform/pants/grimey
	display_name = "pants, grimey"
	path = /obj/item/clothing/under/vampire/malkavian

// Misc
/datum/gear/uniform/dress
	display_name = "dress, black"
	path = /obj/item/clothing/under/vampire/business

/datum/gear/uniform/dress_red
	display_name = "dress, red"
	path = /obj/item/clothing/under/vampire/primogen_toreador/female

/datum/gear/uniform/black_overcoat
	display_name = "overcoat, black"
	path = /obj/item/clothing/under/vampire/rich

/datum/gear/uniform/flamboyant
	display_name = "outfit, flamboyant"
	path = /obj/item/clothing/under/vampire/toreador

/datum/gear/uniform/flamboyant_female
	display_name = "outfit, flamboyant female"
	description = "	Some sexy clothes." // Consistency!
	path = /obj/item/clothing/under/vampire/toreador/female

/datum/gear/uniform/sexy
	display_name = "outfit, purple and black"
	path = /obj/item/clothing/under/vampire/sexy

/datum/gear/uniform/slickback
	display_name = "jacket, slick"
	path = /obj/item/clothing/under/vampire/slickback

/datum/gear/uniform/tracksuit
	display_name = "tracksuit"
	path = /obj/item/clothing/under/vampire/sport

/datum/gear/uniform/schoolgirl
	display_name = "outfit, goth schoolgirl"
	path = /obj/item/clothing/under/vampire/malkavian/female

/datum/gear/uniform/gothic
	display_name = "outfit, gothic"
	path = /obj/item/clothing/under/vampire/gothic

/datum/gear/uniform/punk
	display_name = "outfit, punk"
	path = /obj/item/clothing/under/vampire/brujah

/datum/gear/uniform/punk_female
	display_name = "outfit, punk female"
	path = /obj/item/clothing/under/vampire/brujah/female

/datum/gear/uniform/pentagram
	display_name = "outfit, pentagram"
	description = "A red pentagram on a black t-shirt." // Shortened, as we don't want to bloat the menu with long descriptions
	path = /obj/item/clothing/under/vampire/baali

/datum/gear/uniform/emo
	display_name = "outfit, emo"
	path = /obj/item/clothing/under/vampire/emo

/datum/gear/uniform/hipster
	display_name = "outfit, red hipster"
	path = /obj/item/clothing/under/vampire/red

/datum/gear/uniform/messy
	display_name = "outfit, messy shirt"
	path = /obj/item/clothing/under/vampire/bouncer

/datum/gear/uniform/overalls
	display_name = "overalls"
	path = /obj/item/clothing/under/vampire/mechanic

/datum/gear/uniform/black_grunge
	display_name = "outfit, black grunge"
	path = /obj/item/clothing/under/vampire/black

/datum/gear/uniform/gimp
	display_name = "outfit, gimp"
	path = /obj/item/clothing/under/vampire/nosferatu

/datum/gear/uniform/gimp_female
	display_name = "outfit, gimp female"
	path = /obj/item/clothing/under/vampire/nosferatu/female

/datum/gear/uniform/gangrel
	display_name = "outfit, rugged"
	path = /obj/item/clothing/under/vampire/gangrel

/datum/gear/uniform/gangrel_female
	display_name = "outfit, rugged female"
	path = /obj/item/clothing/under/vampire/gangrel/female

/datum/gear/uniform/sleeveless_yellow
	display_name = "outfit, yellow shirt"
	path = /obj/item/clothing/under/vampire/larry

/datum/gear/uniform/sleeveless_white
	display_name = "outfit, white shirt"
	path = /obj/item/clothing/under/vampire/bandit

/datum/gear/uniform/biker
	display_name = "outfit, biker"
	path = /obj/item/clothing/under/vampire/biker

/datum/gear/uniform/burlesque
	display_name = "outfit, burlesque"
	path = /obj/item/clothing/under/vampire/burlesque

/datum/gear/uniform/daisyd
	display_name = "daisy dukes"
	path = /obj/item/clothing/under/vampire/burlesque/daisyd

/datum/gear/uniform/maid
	display_name = "maid costume"
	cost = 4 // And your dignity.
	path = /obj/item/clothing/under/costume/maid

/datum/gear/uniform/redeveninggown
	display_name = "evening gown, red"
	path = /obj/item/clothing/under/dress/redeveninggown

/datum/gear/uniform/baron
	display_name = "red shirt"
	path = /obj/item/clothing/under/vampire/bar
	allowed_roles = list("Baron")

/datum/gear/uniform/baron_female
	display_name = "red skirt"
	path = /obj/item/clothing/under/vampire/bar/female
	allowed_roles = list("Baron")

/datum/gear/uniform/scenepink
	display_name = "popular outfit"
	path = /obj/item/clothing/under/vampire/scenepink

/datum/gear/uniform/scenemoody
	display_name = "moody attire"
	path = /obj/item/clothing/under/vampire/scenemoody

/datum/gear/uniform/sceneleopard
	display_name = "revealing outfit"
	path = /obj/item/clothing/under/vampire/sceneleopard

/datum/gear/uniform/scenezim
	display_name = "pim attire"
	path = /obj/item/clothing/under/vampire/scenezim
