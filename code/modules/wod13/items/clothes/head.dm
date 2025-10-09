//HATS

//HATS

//HATS

/obj/item/clothing/head/vampire
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE

/obj/item/clothing/head/vampire/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 10, "headwear", FALSE)

/obj/item/clothing/head/vampire/malkav
	name = "weirdo hat"
	desc = "Can look dangerous or sexy despite the circumstances. Provides some kind of protection."
	icon_state = "malkav_hat"
	armor = list(MELEE = 25, BULLET = 25, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/bandana
	name = "brown bandana"
	desc = "A stylish bandana."
	icon_state = "bandana"

/obj/item/clothing/head/vampire/bandana/red
	name = "red bandana"
	icon_state = "bandana_red"

/obj/item/clothing/head/vampire/bandana/black
	name = "black bandana"
	icon_state = "bandana_black"

/obj/item/clothing/head/vampire/baseballcap
	name = "baseball cap"
	desc = "A soft hat with a rounded crown and a stiff bill projecting in front. Giants baseball, there's nothing like it!"
	icon_state = "baseballcap"

/obj/item/clothing/head/vampire/ushanka
	name = "ushanka"
	desc = "A heavy fur cap with ear-covering flaps."
	icon_state = "ushanka"

/obj/item/clothing/head/vampire/beanie
	name = "beanie"
	desc = "A stylish beanie."
	icon_state = "hat"

/obj/item/clothing/head/vampire/beanie/black
	name = "black beanie"
	icon_state = "hat_black"

/obj/item/clothing/head/vampire/beanie/homeless
	name = "raggedy beanie"
	icon_state = "hat_homeless"

/obj/item/clothing/head/vampire/wizard/blue
	name = "blue wizard hat"
	desc = "A watery-looking wizard hat."
	icon_state = "wizardhat_blue"

/obj/item/clothing/head/vampire/wizard/black
	name = "black wizard hat"
	desc = "A sinister-looking wizard hat."
	icon_state = "wizardhat_black"

/obj/item/clothing/head/vampire/wizard/darkred
	name = "dark red wizard hat"
	desc = "A zealous-looking wizard hat."
	icon_state = "wizardhat_darkred"

/obj/item/clothing/head/vampire/wizard/green
	name = "green wizard hat"
	desc = "An earthy looking wizard hat."
	icon_state = "wizardhat_green"

/obj/item/clothing/head/vampire/wizard/grey
	name = "grey wizard hat"
	desc = "A somber-looking wizard hat."
	icon_state = "wizardhat_grey"

/obj/item/clothing/head/vampire/wizard/purple
	name = "purple wizard hat"
	desc = "An elegant-looking wizard hat."
	icon_state = "wizardhat_purple"

/obj/item/clothing/head/vampire/wizard/red
	name = "red wizard hat"
	desc = "A furious-looking wizard hat."
	icon_state = "wizardhat_red"

/obj/item/clothing/head/vampire/wizard/white
	name = "white wizard hat"
	desc = "An angelic-looking wizard hat."
	icon_state = "wizardhat_white"

/obj/item/clothing/head/vampire/wizard/yellow
	name = "yellow wizard hat"
	desc = "A happy-looking wizard hat."
	icon_state = "wizardhat_yellow"

/obj/item/clothing/head/vampire/cowboy
	name = "cowboy hat"
	desc = "Looks cool anyway. Provides some kind of protection."
	icon_state = "cowboy"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/cowboy/armorless
	name = "cowboy hat"
	desc = "Yee, and I do not often say this, haw."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/head/vampire/british
	name = "british police hat"
	desc = "Want some tea? Provides some kind of protection."
	icon_state = "briish"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/napoleon
	name = "french admiral hat"
	desc = "Dans mon esprit tout divague, je me perds dans tes yeux... Je me noie dans la vague de ton regard amoureux..."
	icon_state = "french"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/head/vampire/top
	name = "top hat"
	desc = "Want some tea? Provides some kind of protection."
	icon_state = "top"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 0)

/obj/item/clothing/head/vampire/skull
	name = "skull helmet"
	desc = "Damn... Provides some kind of protection."
	icon_state = "skull"
	armor = list(MELEE = 20, BULLET = 20, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/helmet
	name = "police helmet"
	desc = "Looks dangerous. Provides good protection."
	icon_state = "helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	clothing_flags = NO_HAT_TRICKS|SNUG_FIT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 20, BIO = 0, RAD = 0, FIRE = 20, ACID = 40, WOUND = 25)
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = TRUE

/obj/item/clothing/head/vampire/helmet/egorium
	name = "strange mask"
	desc = "Looks mysterious. Provides good protection."
	icon_state = "masque"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/helmet/spain
	name = "spain helmet"
	desc = "Concistador! Provides good protection."
	icon_state = "spain"
	flags_inv = HIDEEARS
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 20, BIO = 0, RAD = 0, FIRE = 20, ACID = 40, WOUND = 25)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/army
	name = "army helmet"
	desc = "Looks dangerous. Provides great protection against blunt force."
	icon_state = "viet"
	flags_inv = HIDEEARS|HIDEHAIR
	clothing_flags = NO_HAT_TRICKS|SNUG_FIT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list(MELEE = 60, BULLET = 60, LASER = 60, ENERGY = 60, BOMB = 40, BIO = 0, RAD = 0, FIRE = 20, ACID = 40, WOUND = 25)
	masquerade_violating = TRUE

/obj/item/clothing/head/vampire/hardhat
	name = "construction helmet"
	desc = "A thermoplastic hard helmet used to protect the head from injury."
	icon_state = "hardhat"
	armor = list(MELEE = 20, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 5, ACID = 0, WOUND = 15)

/obj/item/clothing/head/vampire/eod
	name = "EOD helmet"
	desc = "Looks dangerous. Provides best protection against nearly everything."
	icon_state = "bomb"
	armor = list(MELEE = 70, BULLET = 70, LASER = 90, ENERGY = 90, BOMB = 100, BIO = 0, RAD = 0, FIRE = 50, ACID = 90, WOUND = 40)
	heat_protection = HEAD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	clothing_flags = NO_HAT_TRICKS|SNUG_FIT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY
	masquerade_violating = TRUE

/obj/item/clothing/head/vampire/bogatyr
	name = "Bogatyr helmet"
	desc = "A regal helmet made of what some would seem to be unknown materials. In truth, the Voivodes know well how to mold flesh and bone."
	icon_state = "bogatyr_helmet"
	armor = list(MELEE = 55, BULLET = 50, LASER = 60, ENERGY = 60, BOMB = 20, BIO = 0, RAD = 0, FIRE = 40, ACID = 70, WOUND = 30)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	clothing_flags = NO_HAT_TRICKS|SNUG_FIT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/head/vampire/bahari_mask
	name = "Dark mother's mask"
	desc = "When I first tasted the fruit of the Trees,\
			felt the seeds of Life and Knowledge, burn within me, I swore that day I would not turn back..."
	icon_state = "bahari_mask"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/straw_hat
	name = "straw hat"
	desc = "A straw hat."
	icon_state = "strawhat"

/obj/item/clothing/head/vampire/hijab
	name = "hijab"
	desc = "A traditional headscarf worn by Muslim women."
	icon_state = "hijab"
	flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/vampire/taqiyah
	name = "taqiyah"
	desc = "A traditional hat worn by Muslim men."
	icon_state = "taqiyah"

/obj/item/clothing/head/vampire/noddist_mask
	name = "Noddist mask"
	desc = "Shine black the sun! Shine blood the moon! Gehenna is coming soon."
	icon_state = "noddist_mask"
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)

/obj/item/clothing/head/vampire/kalimavkion
	name = "Kalimavkion"
	desc = "A traditional hat worn by Orthodox priests."
	icon_state = "kalimavkion"

/obj/item/clothing/head/vampire/prayer_veil
	name = "Prayer veil"
	desc = "A traditional veil."
	icon_state = "prayer_veil"
	flags_inv = HIDEEARS|HIDEHAIR
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

/obj/item/clothing/head/vampire/nun
	name = "Sisterly Wimple"
	desc = "The head covering of a religious sister."
	icon_state = "nun_hood"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/pentex
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	armor = list(MELEE = 10, BULLET = 0, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 0, RAD = 0, FIRE = 0, ACID = 10, WOUND = 10)
	body_worn = TRUE

/obj/item/clothing/head/pentex/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 10, "headwear", FALSE)

/obj/item/clothing/head/pentex/pentex_yellowhardhat
	name = "Endron hardhat"
	desc = "A yellow hardhat. This one has an Endron International logo on it!"
	icon_state = "pentex_hardhat_yellow"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/pentex/pentex_whitehardhat
	name = "Endron hardhat"
	desc = "A white hardhat. This one has an Endron International logo on it!"
	icon_state = "pentex_hardhat_white"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/pentex/pentex_beret
	name = "First Team beret"
	desc = "A black beret with a mysterious golden insigna bearing a spiral."
	icon_state = "pentex_beret"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/vampire/chauffeur
	name = "chauffeur hat"
	desc = "A fine hat like that is well-earned by opening car doors for rich people and driving them around the city."
	icon_state = "chauffeur"

/obj/item/clothing/head/vampire/blackbag
	name = "black bag"
	desc = "Used by kidnappers, sadists, and three letter agencies. Easily fits over the head to obscure vision."
	icon_state = "black_bag"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR
	clothing_flags = NO_HAT_TRICKS|SNUG_FIT
	dynamic_hair_suffix = ""
	dynamic_fhair_suffix = ""

	flash_protect = FLASH_PROTECTION_WELDER
	tint = 3

/obj/item/clothing/head/vampire/blackbag/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/vampire/blackbag/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/vampire/blackbag/attack(mob/living/target, mob/living/user)
	var/obj/item/clothing/head/H = target.get_item_by_slot(ITEM_SLOT_HEAD)
	if(H)
		if(H.clothing_flags & SNUG_FIT)
			to_chat(user, span_warning("You can't fit the blackbag over [target.p_their()] headgear!"))
			return
	if(do_after(user, 0.5 SECONDS, target)) //Mainly to prevent black_bagging mid combat.
		target.visible_message(span_warning("[user] forces [src] onto [target]'s head!"))
		to_chat(target, span_bolddanger("[target] forces [src] onto your head!"))
		target.emote("scream")
		target.Stun(0.5 SECONDS)

		target.dropItemToGround(H)
		target.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD)


/obj/item/clothing/head/vampire/redsoft
	name = "dark red cap"
	desc = "It's a baseball hat in a tasteful dark red colour."
	icon_state = "dredsoft"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/cowboyhat
	name = "brown cowboy hat"
	desc = "The prevailing style of the Old West."
	icon_state = "cowboyhat"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/cowboy_black
	name = "black cowboy hat"
	desc = "For the villainous stranger."
	icon_state = "cowboy_black"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/cowboy_wide
	name = "wide-brimmed cowboy hat"
	desc = "For the nameless stranger."
	icon_state = "cowboy_wide"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/cowboy_white

	name = "white cowboy hat"
	desc = "For the heroic stranger."
	icon_state = "cowboy_white"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/cowboy_white_wide
	name = "white wide cowboy hat"
	desc = "For the jovial stranger."
	icon_state = "cowboy_white_wide"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/gent_cap
	name = "grey flat cap"
	desc = "A checkered gray flat cap woven from tweed."
	icon_state = "gentcap"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/flatcap
	name = "black flat cap"
	desc = "A working man's cap, in black."
	icon_state = "flat_cap_black"
	inhand_icon_state = "detective"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/flatcap/white
	name = "white flat cap"
	desc = "A working man's cap, in white."
	icon_state = "flat_capw"

/obj/item/clothing/head/vampire/fez
	name = "fez"
	desc = "The choice of Moroccan nobles, and men in tiny cars."
	icon_state = "fez"

/obj/item/clothing/head/vampire/feather_trilby
	name = "feathered hat"
	desc = "The modern day dandy."
	icon_state = "feather_trilby"

/obj/item/clothing/head/vampire/fedora
	name = "journalist's fedora"
	desc = "The cornerstone of a reporter's style, or a poor attempt at looking cool."
	icon_state = "fedora"

/obj/item/clothing/head/vampire/beret_grey
	name = "grey beret"
	desc = "A grey beret, perfect for war veterans and morally ambiguous mimes."
	icon_state = "beret_grey"

/obj/item/clothing/head/vampire/beret_white
	name = "white beret"
	desc = "A white beret, perfect for redeemed mimes."
	icon_state = "beret_white"

/obj/item/clothing/head/vampire/mariner
	name = "mariner's cap"
	desc = "For sailors, fiddlers, and revolutionaries."
	icon_state = "mariner"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/greenutil
	name = "green utility cap"
	desc = "A green camoflague cap, common in the military."
	icon_state = "greenutility"

/obj/item/clothing/head/vampire/tanutil
	name = "tan utility cap"
	desc = "A tan camoflague cap, common in the military."
	icon_state = "tanutility"

/obj/item/clothing/head/vampire/whitepeakcap
	name = "white peaked cap"
	desc = "A formal cap worn by soldiers, sailors, firefighters, milkmen, and the president of the local yacht club."
	icon_state = "whitepeakcap"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/biker
	name = "biker cap"
	desc = "So masculine, so... Finnish."
	icon_state = "bikercap"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/captain
	name = "captain's hat"
	desc = "A formal hat for seafarers."
	icon_state = "sailorcap"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/cowboy_small
	name = "small cowboy hat"
	desc = "This town ain't tiny enough for the two of us."
	icon_state = "cowboy_small"

/obj/item/clothing/head/vampire/panama
	name = "panama hat"
	desc = "A stylish straw hat originating in - you guessed it - Ecuador."
	icon_state = "panama"

/obj/item/clothing/head/vampire/fuzzy
	name = "fuzzy monster hat"
	desc = "ZOMG! Rawr!"
	icon_state = "siffet"

/obj/item/clothing/head/vampire/tank
	name = "tank helmet"
	desc = "So alternative, so protected from concussions!"
	icon_state = "tank"

/obj/item/clothing/head/vampire/buckethat
	name = "bucket hat"
	desc = "Music festival high fashion."
	icon_state = "buckethat"
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/vampire/boater_hat
	name = "boater hat"
	desc = "Few dare wear this cheerful straw hat past September 15."
	icon_state = "boater_hat"

/obj/item/clothing/head/vampire/beaver_hat
	name = "beaver hat"
	desc = "The felt is soft and elegant. You can see why the beaver misses it."
	icon_state = "beaver_hat"

/obj/item/clothing/head/vampire/woolhat
	name = "white wool hat"
	desc = "Knitted for those chilly nights."
	icon_state = "woolhat"

/obj/item/clothing/head/vampire/woolhat_blue
	name = "blue and white wool hat"
	desc = "Knitted for those chilly nights."
	icon_state = "woolhat_blue"

/obj/item/clothing/head/vampire/picture_hat
	name = "picture hat"
	desc = "An old-fashioned black hat with a low enough brim to cover your eyes."
	icon_state = "picture"
	flags_cover = HEADCOVERSEYES
	dynamic_hair_suffix = ""

/obj/item/clothing/head/vampire/picture_red
	name = "picture hat, red"
	desc = "An old-fashioned red hat with a low enough brim to cover your eyes."
	icon_state = "picture_red"
	flags_cover = HEADCOVERSEYES
	dynamic_hair_suffix = ""

//OTHER
/obj/item/clothing/head/pagecap
	name = "Page's cap"
	icon_state = "hopcap"
	desc = "The symbol of true bureaucratic micromanagement."
	dog_fashion = /datum/dog_fashion/head/hop

/obj/item/clothing/head/vampire/frillyheadband
	name = "frilly headband"
	desc = "A headband made of white frills, and black bows. Maidenly!"
	icon_state = "frilly_headband"

/obj/item/clothing/head/vampire/black_headdress
	name = "black headdress"
	desc = "A fancy black headdress. Mysterious!"
	icon_state = "blackngoldheaddress"
