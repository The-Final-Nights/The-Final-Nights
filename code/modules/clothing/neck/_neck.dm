/obj/item/clothing/neck
	name = "necklace"
	icon = 'icons/obj/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40

/obj/item/clothing/neck/worn_overlays(isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(body_parts_covered & HEAD)
			if(damaged_clothes)
				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
			if(HAS_BLOOD_DNA(src))
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood")

/obj/item/clothing/neck/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	inhand_icon_state = ""	//no inhands
	w_class = WEIGHT_CLASS_SMALL
	custom_price = PAYCHECK_EASY

/obj/item/clothing/neck/tie/blue
	name = "blue tie"
	icon_state = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/neck/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/neck/tie/detective
	name = "loose tie"
	desc = "A loosely tied necktie, a perfect accessory for the over-worked detective."
	icon_state = "detective"

/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] puts \the [src] to [user.p_their()] chest! It looks like [user.p_they()] won't hear much!</span>")
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)

			var/heart_strength = "<span class='danger'>no</span>"
			var/lung_strength = "<span class='danger'>no</span>"

			var/obj/item/organ/heart/heart = M.getorganslot(ORGAN_SLOT_HEART)
			var/obj/item/organ/lungs/lungs = M.getorganslot(ORGAN_SLOT_LUNGS)

			if(!(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH))))
				if(heart && istype(heart))
					heart_strength = "<span class='danger'>an unstable</span>"
					if(heart.beating)
						heart_strength = "a healthy"
				if(lungs && istype(lungs))
					lung_strength = "<span class='danger'>strained</span>"
					if(!(M.failed_last_breath || M.losebreath))
						lung_strength = "healthy"

			var/diagnosis = (body_part == BODY_ZONE_CHEST ? "You hear [heart_strength] pulse and [lung_strength] respiration." : "You faintly hear [heart_strength] pulse.")
			user.visible_message("<span class='notice'>[user] places [src] against [M]'s [body_part] and listens attentively.</span>", "<span class='notice'>You place [src] against [M]'s [body_part]. [diagnosis]</span>")
			return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf
	name = "scarf"
	icon_state = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#EEEEEE#EEEEEE"
	greyscale_config = /datum/greyscale_config/scarf
	greyscale_config_worn = /datum/greyscale_config/scarf_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/scarf/black
	name = "black scarf"
	greyscale_colors = "#4A4A4B#4A4A4B"

/obj/item/clothing/neck/scarf/pink
	name = "pink scarf"
	greyscale_colors = "#F699CD#F699CD"

/obj/item/clothing/neck/scarf/red
	name = "red scarf"
	greyscale_colors = "#D91414#D91414"

/obj/item/clothing/neck/scarf/green
	name = "green scarf"
	greyscale_colors = "#5C9E54#5C9E54"

/obj/item/clothing/neck/scarf/darkblue
	name = "dark blue scarf"
	greyscale_colors = "#1E85BC#1E85BC"

/obj/item/clothing/neck/scarf/purple
	name = "purple scarf"
	greyscale_colors = "#9557C5#9557C5"

/obj/item/clothing/neck/scarf/yellow
	name = "yellow scarf"
	greyscale_colors = "#E0C14F#E0C14F"

/obj/item/clothing/neck/scarf/orange
	name = "orange scarf"
	greyscale_colors = "#C67A4B#C67A4B"

/obj/item/clothing/neck/scarf/cyan
	name = "cyan scarf"
	greyscale_colors = "#54A3CE#54A3CE"

/obj/item/clothing/neck/scarf/zebra
	name = "zebra scarf"
	greyscale_colors = "#333333#EEEEEE"

/obj/item/clothing/neck/scarf/christmas
	name = "christmas scarf"
	greyscale_colors = "#038000#960000"


/obj/item/clothing/neck/large_scarf
	name = "large scarf"
	icon_state = "large_scarf"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	greyscale_colors = "#C6C6C6#EEEEEE"
	greyscale_config = /datum/greyscale_config/large_scarf
	greyscale_config_worn = /datum/greyscale_config/large_scarf_worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/neck/large_scarf/red
	name = "large red scarf"
	greyscale_colors = "#8A2908#A06D66"

/obj/item/clothing/neck/large_scarf/green
	name = "large green scarf"
	greyscale_colors = "#525629#888674"

/obj/item/clothing/neck/large_scarf/blue
	name = "large blue scarf"
	greyscale_colors = "#20396C#6F7F91"

/obj/item/clothing/neck/petcollar
	name = "pet collar"
	desc = "It's for pets."
	icon_state = "petcollar"
	var/tagname = null

/obj/item/clothing/neck/petcollar/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(ishuman(M))
		return FALSE
	return ..()

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = sanitize_name(stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN))
	name = "[initial(name)] - [tagname]"

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "gold necklace"
	desc = "Damn, it feels good to be a gangster."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"

/obj/item/clothing/neck/necklace/dope/merchant
	desc = "Don't ask how it works, the proof is in the holochips!"
	/// scales the amount received in case an admin wants to emulate taxes/fees.
	var/profit_scaling = 1
	/// toggles between sell (TRUE) and get price post-fees (FALSE)
	var/selling = FALSE

/obj/item/clothing/neck/necklace/dope/merchant/attack_self(mob/user)
	. = ..()
	selling = !selling
	to_chat(user, "<span class='notice'>[src] has been set to [selling ? "'Sell'" : "'Get Price'"] mode.</span>")

/obj/item/clothing/neck/necklace/dope/merchant/afterattack(obj/item/I, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	var/datum/export_report/ex = export_item_and_contents(I, dry_run=TRUE)
	var/price = 0
	for(var/x in ex.total_amount)
		price += ex.total_value[x]

	if(price)
		var/true_price = round(price*profit_scaling)
		to_chat(user, "<span class='notice'>[selling ? "Sold" : "Getting the price of"] [I], value: <b>[true_price]</b> credits[I.contents.len ? " (exportable contents included)" : ""].[profit_scaling < 1 && selling ? "<b>[round(price-true_price)]</b> credit\s taken as processing fee\s." : ""]</span>")
		if(selling)
			new /obj/item/holochip(get_turf(user),true_price)
			for(var/i in ex.exported_atoms_ref)
				var/atom/movable/AM = i
				if(QDELETED(AM))
					continue
				qdel(AM)
	else
		to_chat(user, "<span class='warning'>There is no export value for [I] or any items within it.</span>")


/obj/item/clothing/neck/neckerchief
	icon = 'icons/obj/clothing/masks.dmi' //In order to reuse the bandana sprite
	w_class = WEIGHT_CLASS_TINY
	var/sourceBandanaType

/obj/item/clothing/neck/neckerchief/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/realOverlay = mutable_appearance('icons/mob/clothing/mask.dmi', icon_state)
		realOverlay.pixel_y = -3
		. += realOverlay

/obj/item/clothing/neck/neckerchief/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(ITEM_SLOT_NECK) == src)
			to_chat(user, "<span class='warning'>You can't untie [src] while wearing it!</span>")
			return
		if(user.is_holding(src))
			var/obj/item/clothing/mask/bandana/newBand = new sourceBandanaType(user)
			var/currentHandIndex = user.get_held_index_of_item(src)
			var/oldName = src.name
			qdel(src)
			user.put_in_hand(newBand, currentHandIndex)
			user.visible_message("<span class='notice'>You untie [oldName] back into a [newBand.name].</span>", "<span class='notice'>[user] unties [oldName] back into a [newBand.name].</span>")
		else
			to_chat(user, "<span class='warning'>You must be holding [src] in order to untie it!</span>")

/obj/item/clothing/neck/beads
	name = "plastic bead necklace"
	desc = "A cheap, plastic bead necklace. Show team spirit! Collect them! Throw them away! The posibilites are endless!"
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "beads"
	color = "#ffffff"
	custom_price = PAYCHECK_ASSISTANT * 0.2
	custom_materials = (list(/datum/material/plastic = 500))

/obj/item/clothing/neck/beads/Initialize()
	. = ..()
	color = color = pick("#ff0077","#d400ff","#2600ff","#00ccff","#00ff2a","#e5ff00","#ffae00","#ff0000", "#ffffff")
