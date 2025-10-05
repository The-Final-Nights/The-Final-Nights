/obj/item/charcoal_stick
    name = "charcoal stick"
    desc = "A piece of burnt charcoal."
    icon = 'icons/obj/crayons.dmi'
    icon_state = "crayonblack"
    w_class = WEIGHT_CLASS_SMALL

/obj/item/charcoal_stick/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || (!isgarou(user) && !iskinfolk(user)))
		return

	if(!GLOB.glyph_list.len)
		to_chat(user, span_notice("There are no glyphs available."))
		return

	if(!istype(target, /turf/open/floor))
		return

	var/list/glyph_names = list()

	for(var/glyph in GLOB.glyph_list)
		glyph_names += glyph

	var/choice = tgui_input_list(user, "Select a glyph to draw.", "Glyph Selection", glyph_names)
	if(choice)
		var/obj/effect/decal/garou_glyph/drawn_glyph = GLOB.glyph_list[choice]
		if(drawn_glyph)
			user.visible_message(span_notice("[user] starts to scrape a glyph into the ground..."), \
			span_notice("You begin to etch the spirals and lines of your chosen glyph..."))

			if(do_after(user, 5 SECONDS, target))
				new drawn_glyph.type(target)
				user.visible_message(span_notice("[user] finishes up their rune."), \
				span_notice("You put the finishing touches on your rune, as it marks the ground before you."))
			else
				user.visible_message(span_notice("[user] slips, smduges and ruins their glyph."), \
				span_notice("You mess it up, the glyph turning into nothing more than a smear upon the ground."))
	. = ..()

/obj/effect/decal/garou_glyph
    name = "odd glyph"
    desc = "An odd collection of symbols drawn in what seems to be charcoal."
    var/garou_name = "Basic Glyph"
    var/garou_desc = "a basic glyph with no meaning." // This is shown to werewolves who examine the glyph in order to determine its true meaning.
    anchored = TRUE
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "garou"
    color = "#000000"
    resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
    layer = SIGIL_LAYER

/obj/effect/decal/garou_glyph/examine(mob/user)
    . = ..()
    if(isgarou(user) || iswerewolf(user) || iskinfolk(user)) // If they're a werewolf or kinfolk, show them the true meaning of the glyph.
        . += "<b>Name:</b> [garou_name]\n" + \
        "<b>Description:</b> [garou_desc]\n"

/obj/effect/decal/garou_glyph/wyrm
    name = "creepy glyph"
    garou_name = "Wyrm Glyph"
    garou_desc = "A glyph that represents the Wyrm, a force of corruption and destruction."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "wyrm"
    color = "#000000"

/obj/effect/decal/garou_glyph/vampire
    name = "weird glyph"
    garou_name = "Vampire Glyph"
    garou_desc = "A glyph that represents the Kindred, leeches of the Weaver and Wyrm."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "vampire"
    color = "#000000"

/obj/effect/decal/garou_glyph/kinfolk
    name = "uncanny glyph"
    garou_name = "Kinfolk Glyph"
    garou_desc = "A glyph that represents the Kinfolk, the human relatives of the Garou."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "kinfolk"
    color = "#000000"

/obj/effect/decal/garou_glyph/dance
    name = "funky glyph"
    garou_name = "Dancing Glyph"
    garou_desc = "A glyph that represents the spiritual dancing of the Garou."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "dance"
    color = "#000000"

/obj/effect/decal/garou_glyph/caern
    name = "eerie glyph"
    garou_name = "Caern Glyph"
    garou_desc = "A glyph that represents the Caern, a sacred location that naturally flows with spiritual energy."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "caern"
    color = "#000000"

/obj/effect/decal/garou_glyph/danger
    name = "peculiar glyph"
    garou_name = "Danger Glyph"
    garou_desc = "A glyph that represents danger! Proceed with caution."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "danger"
    color = "#000000"

/obj/effect/decal/garou_glyph/garou
    name = "freakish glyph"
    garou_name = "Garou Glyph"
    garou_desc = "A glyph that represents the Garou, the warriors of Gaia."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "garou"
    color = "#000000"

/obj/effect/decal/garou_glyph/conceal
    name = "mysterious glyph"
    garou_name = "Conceal Glyph"
    garou_desc = "A glyph that represents the obfuscation of something. What may be hidden from you?"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "conceal"
    color = "#000000"

/obj/effect/decal/garou_glyph/hive
    name = "outlandish glyph"
    garou_name = "Hive Glyph"
    garou_desc = "A glyph that represents a Hive, the foul home of a Black Spiral Dancer pack."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "hive"
    color = "#000000"

/obj/effect/decal/garou_glyph/howl
    name = "unusual glyph"
    garou_name = "Howling Glyph"
    garou_desc = "A glyph that represents the natural song of the Garou, the howl."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "howl"
    color = "#000000"

/obj/effect/decal/garou_glyph/remembrance
    name = "morose glyph"
    garou_name = "Remembrance Glyph"
    garou_desc = "A glyph that represents the mourning and remembrance of the fallen."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "remembrance"
    color = "#000000"

/obj/effect/decal/garou_glyph/watch
    name = "odd glyph"
    garou_name = "Watch Glyph"
    garou_desc = "A glyph that marks something as in need of monitoring"
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "watch"
    color = "#000000"

/obj/effect/decal/garou_glyph/toxic
    name = "foul glyph"
    garou_name = "Toxic Glyph"
    garou_desc = "A glyph that represents toxicity, the material corruption of the Wyrm on the Earth."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "toxic"
    color = "#000000"

/obj/effect/decal/garou_glyph/dancers
    name = "alien glyph"
    garou_name = "Black Spiral Dancer Glyph"
    garou_desc = "A glyph that represents the tribe of the Black Spiral Dancers."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "black_spiral_dancers"
    color = "#000000"

/obj/effect/decal/garou_glyph/glasswalkers
    name = "quirky glyph"
    garou_name = "Glasswalkers Glyph"
    garou_desc = "A glyph that represents the Glasswalkers tribe."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "glasswalkers"
    color = "#000000"

/obj/effect/decal/garou_glyph/galestalkers
    name = "abnormal glyph"
    garou_name = "Younger Brother Glyph"
    garou_desc = "A glyph that represents the Galestalkers tribe."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "younger_brother"
    color = "#000000"

/obj/effect/decal/garou_glyph/war_against_wyrm
    name = "terrifying glyph"
    garou_name = "War Against Wyrm Glyph"
    garou_desc = "A glyph that represents the apocalyptic war of the Garou against the Wyrm."
    icon = 'code/modules/wod13/icons.dmi'
    icon_state = "war_against_wyrm"
    color = "#000000"
