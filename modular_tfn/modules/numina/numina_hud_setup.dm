/// PUT YOUR LOCATION DEFINES HERE
#define ui_faith_hud "WEST-4:19,SOUTH+5:1"

///////////////////////////////////////////////////
////////////// TRUE FAITH HUD SETUP //////////////
///////////////////////////////////////////////////

/atom/movable/screen/faith
	name = "faith"
	icon = 'modular_tfn/modules/numina/icons/faith_hud.dmi'
	icon_state = "faith0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/faith/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/human/BD = usr
		BD.update_faith_hud()
		if(BD.faith > 0)
			to_chat(BD, span_notice("You have [BD.faith] points of <b>FAITH</b>."))
		else
			to_chat(BD, span_warning("You have <b>no</b> points of <b>FAITH</b>!"))
	..()

/mob/living/proc/update_faith_hud()
	if(!client || !hud_used)
		return
	if(hud_used.faith_icon)
		var/mob/living/carbon/human/owner = src
		var/emm = owner.faith
		if(emm > 10)
			hud_used.faith_icon.icon_state = "faith10"
		if(emm < 0)
			hud_used.faith_icon.icon_state = "faith0"
		else
			hud_used.faith_icon.icon_state = "faith[emm]"

///////////////////////////////////////////////////
////////////// TRUE FAITH HUD SETUP //////////////
///////////////////////////////////////////////////




///////////////////////////////////////////////////////////
////////////// UNIVERSAL HUD SETUP FUNCTIONS //////////////
///////////////////////////////////////////////////////////
//// PLEASE READ:
/*
The following functions are used to set up the HUD elements for each numina in a modular way.
If you are adding a new numina, you will need to have it set up as above, and then declare the
variable for it in datum/hud and add it to the Human mob setup in datum/hud/human/New.

What each individual HUD element will/should do will vary depending on what you're using it for,
but the setup below shouldn't usually change all that much. If you want to see how other hud elements
work, they're in \code\_onclick\hud\human.dm

Later on the function below for human/New will probably need to be made into a switch statement so
there isn't 5000morbillion IF-ELSEs, but for right now a simple IF statement will work for just TF.
*/
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

/datum/hud
	var/atom/movable/screen/faith_icon

/datum/hud/human/New(mob/living/carbon/human/owner)
	. = ..()
	if(owner.numina?.name == NUMINA_FAITH)
		faith_icon = new /atom/movable/screen/faith()
		faith_icon.screen_loc = ui_faith_hud //It overlays ontop of the gargoyle things
		faith_icon.hud = src
		infodisplay += faith_icon

/// UNDEFINE YOUR HUD LOCATIONS WHEN YOU'RE DONE WITH THEM
#undef ui_faith_hud
