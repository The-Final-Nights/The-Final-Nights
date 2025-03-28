// Sex interaction system
// This file contains code for handling erotic roleplay interactions between characters

/// List of basic interaction verbs for the menu
GLOBAL_LIST_INIT(basic_sex_interactions, list(
	"Kiss" = "kisses",
	"Hug" = "hugs",
	"Caress" = "caresses",
	"Touch" = "touches",
	"Stroke" = "strokes",
	"Fondle" = "fondles",
	"Cuddle" = "cuddles with",
	"Massage" = "massages",
	"Spank" = "spanks",
	"Bite" = "bites",
	"Lick" = "licks",
	"Suck" = "sucks",
	"Grope" = "gropes"
))

/// More intimate interaction verbs
GLOBAL_LIST_INIT(intimate_sex_interactions, list(
	"Penetrate" = "penetrates",
	"Pleasure" = "pleasures",
	"Straddle" = "straddles",
	"Ride" = "rides",
	"Grind" = "grinds against",
	"Tongue" = "uses tongue on",
	"Finger" = "fingers"
))

/**
 * Displays a radial menu of sex interaction options when one sprite is middle-mouse dragged onto another
 *
 * @param user The mob initiating the interaction
 * @param target The mob being interacted with
 */
/proc/show_sex_interaction_menu(mob/living/user, mob/living/target)
	if(!user || !target || user == target)
		return

	if(!ishuman(user) || !ishuman(target))
		return

	// Create the list of choices for the radial menu
	var/list/choices = list()
	var/list/tooltips = list()

	// Add basic interactions
	for(var/interaction in GLOB.basic_sex_interactions)
		var/action_name = interaction
		choices[action_name] = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_normal")
		tooltips[action_name] = "Perform a [lowertext(action_name)]"

	// Add intimate interactions
	for(var/interaction in GLOB.intimate_sex_interactions)
		var/action_name = interaction
		choices[action_name] = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_combat")
		tooltips[action_name] = "Perform [lowertext(action_name)]"

	// Show the radial menu to the user
	var/selected_interaction = show_radial_menu(user, target, choices, custom_check = CALLBACK(src, .proc/check_menu, user), tooltips = tooltips)
	if(!selected_interaction)
		return

	// Perform the selected interaction
	perform_sex_interaction(user, target, selected_interaction)

/**
 * Checks if the menu can still be used
 */
/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/**
 * Performs the selected sex interaction between two mobs
 *
 * @param user The mob initiating the interaction
 * @param target The mob being interacted with
 * @param interaction The selected interaction verb
 */
/proc/perform_sex_interaction(mob/living/user, mob/living/target, interaction)
	if(!user || !target || !interaction)
		return

	var/action_verb = ""

	if(interaction in GLOB.basic_sex_interactions)
		action_verb = GLOB.basic_sex_interactions[interaction]
	else if(interaction in GLOB.intimate_sex_interactions)
		action_verb = GLOB.intimate_sex_interactions[interaction]
	else
		return

	// Display the interaction message
	user.visible_message(
		span_notice("<b>[user]</b> [action_verb] <b>[target]</b>."),
		span_notice("You [action_verb] <b>[target]</b>."),
		span_notice("You hear subtle movement."),
		ignored_mobs = list(target)
	)

	target.show_message(span_notice("<b>[user]</b> [action_verb] you."), MSG_VISUAL)

	// Add some basic effects
	playsound(get_turf(user), 'sound/effects/bodyfall3.ogg', 5, TRUE, -5)
	user.do_attack_animation(target, ATTACK_EFFECT_DISARM)

	// You could add consent mechanics, arousal tracking, or other features here
