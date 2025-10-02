/obj/item/clothing/under/vampire
	desc = "Some clothes."
	name = "clothes"
	icon_state = "error"
	has_sensor = NO_SENSORS
	random_sensor = FALSE
	can_adjust = FALSE
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 15)
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_worn = TRUE
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/vampire/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 10, "undersuit", FALSE)

/obj/item/clothing/under/vampire/brujah
	name = "punk attire"
	desc = "A rugged, short sleeved shirt with some grimy pants."
	icon_state = "brujah_m"

/obj/item/clothing/under/vampire/brujah/female
	desc = "A sports bra and some black sweat pants. Classy."
	icon_state = "brujah_f"

/obj/item/clothing/under/vampire/gangrel
	name = "Rugged attire"
	desc = "Some hobo clothes."
	icon_state = "gangrel_m"

/obj/item/clothing/under/vampire/gangrel/female
	icon_state = "gangrel_f"

/obj/item/clothing/under/vampire/malkavian
	name = "Grimey pants"
	desc = "Some macho-man pants."
	icon_state = "malkavian_m"

/obj/item/clothing/under/vampire/malkavian/female
	name = "schoolgirl attire"
	icon_state = "malkavian_f"

/obj/item/clothing/under/vampire/nosferatu
	name = "gimp outfit"
	desc = "Bring Out the Gimp."
	icon_state = "nosferatu_m"

/obj/item/clothing/under/vampire/nosferatu/female
	name = "feminine gimp outfit"
	icon_state = "nosferatu_f"

/obj/item/clothing/under/vampire/toreador
	name = "flamboyant outfit"
	desc = "Some sexy clothes."
	icon_state = "toreador_m"

/obj/item/clothing/under/vampire/toreador/female
	name = "dancer's offwear"
	desc = "Do I look like your girlfriend?"
	icon_state = "toreador_f"

/obj/item/clothing/under/vampire/tremere
	name = "burgundy suit"
	desc = "Some weirdly tidy clothing."
	icon_state = "tremere_m"

/obj/item/clothing/under/vampire/tremere/female
	name = "burgundy suit skirt"
	icon_state = "tremere_f"

/obj/item/clothing/under/vampire/ventrue
	name = "brown luxury shirt"
	desc = "Some rich clothes."
	icon_state = "ventrue_m"

/obj/item/clothing/under/vampire/ventrue/female
	name = "brown luxury suit skirt"
	icon_state = "ventrue_f"

/obj/item/clothing/under/vampire/baali
	name = "edgy outfit"
	desc = "A red pentagram on a black t-shirt. If this doesn't protect your virginity, nothing will."
	icon_state = "baali_m"

/obj/item/clothing/under/vampire/baali/female
	icon_state = "baali_f"

/obj/item/clothing/under/vampire/salubri
	name = "grey attire"
	desc = "Some very neutral clothes without much bright colors."
	icon_state = "salubri_m"

/obj/item/clothing/under/vampire/salubri/female
	icon_state = "salubri_f"

/obj/item/clothing/under/vampire/punk
	name = "punk rocker outfit"
	desc = "A white, sweat stained shirt with a giant black skull on the front, it makes a statement. Maybe 'I don't use deoderant' but, a statement nontheless."
	icon_state = "dirty"

/obj/item/clothing/under/vampire/turtleneck_white
	name = "white turtleneck"
	desc = "For me, it's always like this."
	icon_state = "turtleneck_white"

/obj/item/clothing/under/vampire/turtleneck_black
	name = "black turtleneck"
	desc = "By those in the know, it's called the Tactleneck, the premier clothing for secret agents."
	icon_state = "turtleneck_black"

/obj/item/clothing/under/vampire/turtleneck_red
	name = "red turtleneck"
	desc = "A red turtleneck"
	icon_state = "turtleneck_red"

/obj/item/clothing/under/vampire/turtleneck_navy
	name = "navy turtleneck"
	desc = "A navy turtleneck"
	icon_state = "turtleneck_navy"

/obj/item/clothing/under/vampire/napoleon
	name = "french emperor suit"
	desc = "Some oddly historical clothes."
	icon_state = "napoleon"

/obj/item/clothing/under/vampire/military_fatigues
	name = "military fatigues"
	desc = "Some military clothes."
	icon_state = "milfatigues"

/obj/item/clothing/under/vampire/sceneleopard
	name = "revealing outfit"
	desc = "You never thought you needed spaghetti straps."
	icon_state = "scenetop_leopard"

/obj/item/clothing/under/vampire/scenemoody
	name = "moody attire"
	desc = "A classic My Laboratory Romance top."
	icon_state = "scenetop_moody"

/obj/item/clothing/under/vampire/scenezim
	name = "pim attire"
	desc = "A top from your favorite show, Intruder Pim"
	icon_state = "scenetop_zim"

/obj/item/clothing/under/vampire/scenepink
	name = "popular Outfit"
	desc = "It almost makes you feel like a mean girl"
	icon_state = "scenetop_pink"

//FOR NPC

//GANGSTERS AND BANDITS

/obj/item/clothing/under/vampire/larry
	name = "yellow tanktop"
	desc = "I know I got a weight problem an' I just don't give a fuck!"
	icon_state = "larry"

/obj/item/clothing/under/vampire/bandit
	name = "white tanktop"
	desc = "An oddly wornout tanktop."
	icon_state = "bandit"

/obj/item/clothing/under/vampire/biker
	name = "biker attire"
	desc = "Some dirty clothes."
	icon_state = "biker"

//USUAL

/obj/item/clothing/under/vampire/mechanic
	name = "blue overalls"
	desc = "A blue set of overalls. It's just screaming for a Capt. Kirk mask."
	icon_state = "mechanic"

/obj/item/clothing/under/vampire/sport
	name = "red tracksuit"
	desc = "Cheeki Breeki!"
	icon_state = "sport"

/obj/item/clothing/under/vampire/office
	name = "white shirt"
	desc = "Fuck off clean shirt."
	icon_state = "office"

/obj/item/clothing/under/vampire/sexy
	name = "purple outfit"
	desc = "Some usual clothes."
	icon_state = "sexy"

/obj/item/clothing/under/vampire/slickback
	name = "slick suit"
	desc = "Some slick-looking clothes."
	icon_state = "slickback"

/obj/item/clothing/under/vampire/burlesque
	name = "burlesque outfit"
	desc = "Some burlesque clothes."
	icon_state = "burlesque"

/obj/item/clothing/under/vampire/burlesque/daisyd
	name = "daisy dukes"
	desc = "Some short shorts."
	icon_state = "daisyd"

/obj/item/clothing/under/vampire/emo
	name = "uncolorful attire"
	desc = "Some usual clothes."
	icon_state = "emo"

//WOMEN

/obj/item/clothing/under/vampire/black
	name = "black croptop"
	desc = "Some usual clothes."
	icon_state = "black"

/obj/item/clothing/under/vampire/red
	name = "red croptop"
	desc = "Some usual clothes."
	icon_state = "red"

/obj/item/clothing/under/vampire/gothic
	name = "gothic getup"
	desc = "Torn jeans and a black sweatshirt. Goth. Apparently."
	icon_state = "gothic"

//PATRICK BATEMAN (High Society)

/obj/item/clothing/under/vampire/rich
	desc = "Some rich clothes."
	name = "rich suit"
	icon_state = "rich"

/obj/item/clothing/under/vampire/business
	name = "black dress"
	desc = "Lesson number one, spelling the word business."
	icon_state = "business"

//Homeless

/obj/item/clothing/under/vampire/homeless
	name = "dirty attire"
	desc = "Some hobo clothes."
	icon_state = "homeless_m"

/obj/item/clothing/under/vampire/homeless/female
	icon_state = "homeless_f"

//Guards

/obj/item/clothing/under/vampire/guard
	name = "security guard uniform"
	desc = "Never let the stale, spongy cake of life keep you from getting to the tasty cream filling of success."
	icon_state = "guard"

//JOBS

/obj/item/clothing/under/vampire/janitor
	name = "janitorial uniform"
	desc = "Another night, another mess to clean."
	icon_state = "janitor"

/obj/item/clothing/under/vampire/nurse
	name = "nurse scrubs"
	desc = "Some sterile clothes."
	icon_state = "nurse"

/obj/item/clothing/under/vampire/nurse/nurseb
	name = "black nurse scrubs"
	desc = "Some sterile clothes."
	icon_state = "nurseb"

/obj/item/clothing/under/vampire/nurse/nurseg
	name = "green nurse scrubs"
	desc = "Some sterile clothes."
	icon_state = "nurseg"

/obj/item/clothing/under/vampire/nurse/nursep
	name = "pink nurse scrubs"
	desc = "Some sterile clothes."
	icon_state = "nursep"

/obj/item/clothing/under/vampire/nurse/nursec
	name = "cyan nurse scrubs"
	desc = "Some sterile clothes."
	icon_state = "nursec"

/obj/item/clothing/under/vampire/graveyard
	desc = "There'll be some GRAVE consequences for taking this off!"
	icon_state = "graveyard"

/obj/item/clothing/under/vampire/suit
	name = "suit"
	desc = "Some business clothes."
	icon_state = "suit"

/obj/item/clothing/under/vampire/suit/female
	name = "suitskirt"
	icon_state = "suit_f"

/obj/item/clothing/under/vampire/sheriff
	name = "red suit"
	desc = "Some business clothes."
	icon_state = "sheriff"

/obj/item/clothing/under/vampire/sheriff/female
	name = "red suitskirt"
	icon_state = "sheriff_f"

/obj/item/clothing/under/vampire/clerk
	name = "blue suit"
	desc = "Some business clothes."
	icon_state = "clerk"

/obj/item/clothing/under/vampire/clerk/female
	name = "blue suitskirt"
	icon_state = "clerk_f"

/obj/item/clothing/under/vampire/prince
	name = "fancy black suit"
	desc = "It's not enough to attain power, one must also maintain power."
	icon_state = "prince"

/obj/item/clothing/under/vampire/prince/female
	name = "fancy black suitskirt"
	icon_state = "prince_f"

/obj/item/clothing/under/vampire/hound
	name = "scruffy black suit"
	desc = "Sorry, nobody down here but the FBI's most unwanted."
	icon_state = "agent"

/obj/item/clothing/under/vampire/archivist
	name = "brown and red suit"
	desc = "I sure hope that a silly, poorly written series of events doesn't cause the Pyramid to blow up!"
	icon_state = "archivist"

/obj/item/clothing/under/vampire/archivist/female
	name = "brown and red suitskirt"
	icon_state = "archivist_f"

/obj/item/clothing/under/vampire/bar
	name = "red shirt"
	desc = "Some maid clothes."
	icon_state = "bar"

/obj/item/clothing/under/vampire/bar/female
	name = "red skirt"
	icon_state = "bar_f"

/obj/item/clothing/under/vampire/bouncer
	name = "loose shirt"
	desc = "Rough night, then?"
	icon_state = "bouncer"

/obj/item/clothing/under/vampire/supply
	name = "cargo jumpsuit"
	desc = "Caine lives? Nonono. Cargonia lives."
	icon_state = "supply"

//PRIMOGEN

/obj/item/clothing/under/vampire/primogen_malkavian
	name = "stark white pants"
	desc = "The outfit of the truly insane. Who wears white pants? Especially in this shithole."
	icon_state = "malkav_pants"

/obj/item/clothing/under/vampire/voivode
	name = "blue windbreaker"
	desc = "Some fancy clothes."
	icon_state = "voivode"

/obj/item/clothing/under/vampire/bogatyr
	name = "blue shirt"
	desc = "Some nice clothes."
	icon_state = "bogatyr"

/obj/item/clothing/under/vampire/bogatyr/female
	name = "blue skirt"
	desc = "Some nice clothes."
	icon_state = "bogatyr_f"

/obj/item/clothing/under/vampire/primogen_malkavian/female
	name = "catsuit"
	desc = "Loosely inspired by the 'hit' 2004 film."
	icon_state = "malkav_suit"

/obj/item/clothing/under/vampire/primogen_toreador
	name = "white suit"
	desc = "Say good night to the bad guy!."
	icon_state = "toreador_male"

/obj/item/clothing/under/vampire/primogen_toreador/female
	name = "crimson red dress"
	desc = "Some sexy rich lady clothes."
	icon_state = "toreador_female"

/obj/item/clothing/under/vampire/fancy_gray
	name = "fancy red suit"
	desc = "A suit for a real business."
	icon_state = "fancy_gray"

/obj/item/clothing/under/vampire/fancy_red
	name = "Fancy grey suit"
	desc = "A suit for a real business."
	icon_state = "fancy_red"

/obj/item/clothing/under/vampire/leatherpants
	name = "leather pants"
	desc = "A suit for a TRULY REAL business."
	icon_state = "leather_pants"


/obj/item/clothing/under/vampire/bacotell
	name = "bacotell uniform"
	desc = "Some BacoTell clothes."
	icon_state = "bacotell"

/obj/item/clothing/under/vampire/bubway
	name = "bubway uniform"
	desc = "Some Bubway clothes."
	icon_state = "bubway"

/obj/item/clothing/under/vampire/gummaguts
	name = "gummaguts uniform"
	desc = "Some Gumma Guts clothes."
	icon_state = "gummaguts"


//PENTEX
/obj/item/clothing/under/pentex
	desc = "Some clothes."
	name = "clothes"
	icon_state = "error"
	has_sensor = NO_SENSORS
	random_sensor = FALSE
	can_adjust = FALSE
	icon = 'code/modules/wod13/clothing.dmi'
	worn_icon = 'code/modules/wod13/worn.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 0, ACID = 0, WOUND = 15)
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	body_worn = TRUE
	fitted = NO_FEMALE_UNIFORM

/obj/item/clothing/under/pentex/Initialize()
	. = ..()
	AddComponent(/datum/component/selling, 10, "undersuit", FALSE)

/obj/item/clothing/under/pentex/pentex_janitor
	name = "Ardus Enterprises custodian jumpsuit"
	desc = "An Ardus Enterprises custodian's uniform."
	icon_state = "pentex_janitor"
	armor = list(BIO = 100, ACID = 15, RAD = 5)

/obj/item/clothing/under/pentex/pentex_shortsleeve
	name = "Endron polo-shirt"
	desc = "An Endron International employee uniform. This one is a nice polo!"
	icon_state = "pentex_shortsleeve"

/obj/item/clothing/under/pentex/pentex_longleeve
	name = "Endron shirt"
	desc = "An Endron International employee uniform. This one has sleeves!"
	icon_state = "pentex_longsleeve"

/obj/item/clothing/under/pentex/pentex_turtleneck
	name = "Endron turtleneck"
	desc = "An Endron International employee uniform. This one is a nice turtleneck!"
	icon_state = "pentex_turtleneck"

/obj/item/clothing/under/pentex/pentex_suit
	name = "Endron suit"
	desc = "A nice suit with a green dress-shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_suit"

/obj/item/clothing/under/pentex/pentex_suitskirt
	name = "Endron suitskirt"
	desc = "A nice suitskirt with a green dress-shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_suitskirt"

/obj/item/clothing/under/pentex/pentex_executive_suit
	name = "Endron executive suit"
	desc = "A  white designer suit with a green dress shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_executivesuit"

/obj/item/clothing/under/pentex/pentex_executiveskirt
	name = "Endron executive suitskirt"
	desc = "A white designer suitskirt with a green dress shirt. This one has an Endron International tag on it!"
	icon_state = "pentex_executiveskirt"

/obj/item/clothing/under/vampire/hightrousers
	name = "high-waisted trousers"
	desc = "A waistline this high is just made for ripping bodices, swashing buckles, or - just occasionally - sucking blood."
	icon_state = "gayvampire"

/obj/item/clothing/under/vampire/highskirt
	name = "high-waisted skirt"
	desc = "A waistline this high is just made for ripping bodices, swashing buckles, or - just occasionally - sucking blood."
	icon_state = "gayvampireskirt"

/obj/item/clothing/under/vampire/rippedpunk
	name = "ripped punk jeans"
	desc = "Black ripped jeans and a fishnet top. How punk."
	icon_state = "rippedpunk"

/obj/item/clothing/under/vampire/suitslacks
	name = "grey suit slacks"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks."
	icon_state = "greysuit"

/obj/item/clothing/under/vampire/suit/waistcoat
	name = "white shirt and waistcoast"
	desc = "A rumpled white dress shirt paired with well-worn grey slacks, complete with a blue striped tie, faux-gold tie clip, and waistcoat."
	icon_state = "greysuit_waistcoat"

/obj/item/clothing/under/vampire/suit/tanshirt
	name = "tan dress shirt"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks."
	icon_state = "tanshirtsuit"

/obj/item/clothing/under/vampire/suit/tanshirtwaistcoat
	name = "tan shirt and waistcoat"
	desc = "A serious-looking tan dress shirt paired with freshly-pressed black slacks, complete with a red striped tie and waistcoat."
	icon_state = "tanshirt_waistcoat"

/obj/item/clothing/under/vampire/suit/greyskirt
	name = "grey suit skirt"
	desc = "A serious-looking white blouse paired with a formal grey pencil skirt."
	icon_state = "greyskirt"

/obj/item/clothing/under/vampire/suit/black
	name = "black suit slacks"
	desc = "A professional-looking white shirt with black slacks."
	icon_state = "blacksuit"

/obj/item/clothing/under/vampire/suit/blackskirt
	name = "black suit skirt"
	desc = "A professional-looking white shirt with a black pencil skirt"
	icon_state = "blackskirt"

/obj/item/clothing/under/vampire/suit/purple
	name = "purple suit slacks"
	desc = "A white shirt with a vest and purple slacks. Quite the fashion statement."
	icon_state = "lawyer_purp"

/obj/item/clothing/under/vampire/suit/charcoal
	name = "charcoal suit slacks"
	desc = "A professional-looking white shirt with charcoal slacks."
	icon_state = "charcoalsuit"

/obj/item/clothing/under/vampire/suit/navy
	name = "navy suit slacks"
	desc = "A professional-looking white shirt with navy slacks."
	icon_state = "navysuit"

/obj/item/clothing/under/vampire/suit/burgundy
	name = "burgundy suit slacks"
	desc = "A professional-looking white shirt with burgundy slacks."
	icon_state = "burgundysuit"

/obj/item/clothing/under/vampire/suit/blue
	name = "blue suit slacks"
	desc = "A professional-looking white shirt with blue slacks."
	icon_state = "bluesuit"

/obj/item/clothing/under/vampire/suit/checkered
	name = "checkered suit slacks"
	desc = "A professional-looking white shirt with checkered slacks."
	icon_state = "checkeredsuit"

/obj/item/clothing/under/vampire/suit/tan
	name = "tan suit slacks"
	desc = "A professional-looking white shirt with tan slacks."
	icon_state = "tansuit"

/obj/item/clothing/under/vampire/suit/purpleskirt
	name = "purple suit skirt"
	desc = "A white shirt with a vest and purple skirt. Quite the fashion statement."
	icon_state = "lawyer_purp_skirt"

/obj/item/clothing/under/vampire/suit/charcoalskirt
	name = "charcoal suit skirt"
	desc = "A professional-looking white shirt with a charcoal skirt."
	icon_state = "charcoalskirt"

/obj/item/clothing/under/vampire/suit/navyskirt
	name = "navy suit skirt"
	desc = "A professional-looking white shirt with a navy skirt."
	icon_state = "navyskirt"

/obj/item/clothing/under/vampire/suit/burgundyskirt
	name = "burgundy suit skirt"
	desc = "A professional-looking white shirt with a burgundy skirt."
	icon_state = "burgundyskirt"

/obj/item/clothing/under/vampire/suit/blueskirt
	name = "blue suit skirt"
	desc = "A professional-looking white shirt with a blue skirt."
	icon_state = "blueskirt"

/obj/item/clothing/under/vampire/suit/checkeredskirt
	name = "checkered suit skirt"
	desc = "A professional-looking white shirt with a checkered skirt."
	icon_state = "checkeredskirt"

/obj/item/clothing/under/vampire/suit/tanskirt
	name = "tan suit skirt"
	desc = "A professional-looking white shirt with a tan skirt."
	icon_state = "tanskirt"

/obj/item/clothing/under/vampire/suit/blackfem
	name = "black pantsuit"
	desc = "A sharp black women's suit."
	icon_state = "black_suit_fem"

/obj/item/clothing/under/vampire/dress/black_corset
	name = "black corset"
	desc = "A black corset and skirt for those fancy nights out."
	icon_state = "black_corset"

/obj/item/clothing/under/vampire/dress/darkred
	name = "fancy dark red dress"
	desc = "A short, red dress with a black belt. Fancy."
	icon_state = "darkreddress"
	inhand_icon_state = "darkreddress"

/obj/item/clothing/under/vampire/skirt/outfit
	name = "red skirt"
	desc = "A red skirt with a black jacket, very fancy!"
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	icon_state = "redskirt_jacket"
	inhand_icon_state = "blackskirt"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/under/vampire/skirt/outfit/plaid_blue
	name = "blue plaid skirt"
	desc = "A preppy blue skirt with a white blouse."
	icon_state = "plaid_blue"
	inhand_icon_state = "blue"

/obj/item/clothing/under/vampire/skirt/outfit/plaid_red
	name = "red plaid skirt"
	desc = "A preppy red skirt with a white blouse."
	icon_state = "plaid_red"
	inhand_icon_state = "red"

/obj/item/clothing/under/vampire/skirt/outfit/plaid_purple
	name = "blue purple skirt"
	desc = "A preppy purple skirt with a white blouse."
	icon_state = "plaid_purple"
	inhand_icon_state = "purple"

/obj/item/clothing/under/vampire/dress
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/under/vampire/dress/gothic
	name = "gothic dress"
	desc = "A black dress with a sheer mesh over it, tastefully old school goth."
	icon_state = "gothic"

/obj/item/clothing/under/vampire/dress/pentagram
	name = "pentagram dress"
	desc = "A black dress with straps over the chest in the shape of a pentagram."
	icon_state = "pentagram"

/obj/item/clothing/under/vampire/dress/littleblackdress
	name = "little black dress"
	desc = "A little strapless black dress with a red ribbon and flower accessory."
	icon_state = "littleblackdress"

/obj/item/clothing/under/vampire/dress/yellowswoop
	name = "yellow swooped dress"
	desc = "A yellow dress that swoops to the side."
	icon_state = "yellowswoop"

/obj/item/clothing/under/vampire/dress/blacktango
	name = "black tango dress"
	desc = "Filled with Latin fire."
	icon_state = "black_tango"
	inhand_icon_state = "black_tango"

/obj/item/clothing/under/vampire/dress/qipao2
	name = "slim qipao"
	desc = "A traditional Chinese women's garment, typically made from silk. This one is fairly slim."
	icon_state = "qipao"

/obj/item/clothing/under/vampire/dress/stripeddress
	name = "striped dress"
	desc = "Fashion in space."
	icon_state = "striped_dress"

/obj/item/clothing/under/vampire/dress/sailordress
	name = "sailor dress"
	desc = "Formal wear for a leading lady."
	icon_state = "sailor_dress"

/obj/item/clothing/under/vampire/dress/blackfrilly
	name = "black frilly dress"
	desc = "A cute, black dress decorated with white frills and lace. Feels expensive."
	icon_state = "blackfrills"

/obj/item/clothing/under/vampire/dress/wedding_gothic
	name = "gothic wedding dress"
	desc = "A pale white dress that wouldn't go amiss at a wedding."
	icon_state = "wedding_gothic"

/obj/item/clothing/under/vampire/dress/old_wench_dress
	name = "old wench dress"
	desc = "A dress with a fitted corset and a few dangling baubles of jewelry."
	icon_state = "old_wench_dress"

/obj/item/clothing/under/vampire/dress/countess
	name = "countess dress"
	desc = "A fancy, formal dress fit for a queen. Off with their heads!"
	icon_state = "countess"

/obj/item/clothing/under/vampire/dress/goddess
	name = "divine silk dress"
	desc = "A draped blue and orange dress that clings to the form."
	icon_state = "goddess"

/obj/item/clothing/under/vampire/dress/white_dress
	name = "white and black mesh dress"
	desc = "A white dress with black mesh details."
	icon_state = "white_dress"

/obj/item/clothing/under/vampire/dress/sermon
	name = "golden embroidered black dress"
	desc = "A black gown with draping sleeves and golden embroidery."
	icon_state = "sermon"

/obj/item/clothing/under/vampire/dress/chain
	name = "chain dress"
	desc = "A risque yet classy formal gown, made of lace with draping chains. For the modern princess."
	icon_state = "chain_dress"

/obj/item/clothing/under/vampire/dress/modest
	name = "modest dress"
	desc = "A largely unadorned, old-fashioned black dress. For the shy ones."
	icon_state = "dress_modest"

/obj/item/clothing/under/vampire/skater_boy
	name = "skater boy cargo pants"
	desc = "A tank top, tie, and cargo pants. How familiar..."
	icon_state = "skater_boy"

/obj/item/clothing/under/vampire/skater_skirt
	name = "skater skirt"
	desc = "A sporty black skirt and top."
	icon_state = "skater_skirt"

/obj/item/clothing/under/vampire/dress/strawberrylolita
	name = "strawberry lolita dress"
	desc = "A red lolita dress with white polkadots and a stylish pink apron."
	icon_state = "strawberrylolita"

/obj/item/clothing/under/vampire/dress/matron
	name = "matronly dress"
	desc = "An curve-flattering black dress with a plunging neckline and sheer lace sleeves."
	icon_state = "matron"

/obj/item/clothing/under/vampire/dress/maiden
	name = "maidenly dress"
	desc = "A short gothic dress with draping mesh sleeves."
	icon_state = "maiden"

/obj/item/clothing/under/vampire/novella
	name = "loose open-front silk shirt"
	desc = "A loosely fit, open-front silk shirt in a nice black. Looks a bit like a cover for one of those romance novellas..."
	icon_state = "novella"

/obj/item/clothing/under/vampire/dress/laceblack
	name = "sheer black lace dress"
	desc = "A fancy black, lace dress with lot of sheer mesh to enhance the look."
	icon_state = "laceblack"

/obj/item/clothing/under/vampire/royalredsuit
	name = "royal red suit"
	desc = "A fine looking red suit in a more feminine fashion. For the business-minded."
	icon_state = "royalredsuit"

/obj/item/clothing/under/vampire/bandshirt_dark
	name = "dark band t-shirt"
	desc = "A cool band t-shirt, just in case you needed a conversation starter."
	icon_state = "bandshirt_dark"

/obj/item/clothing/under/vampire/bandshirt_light
	name = "light band t-shirt"
	desc = "A cool band t-shirt, just in case you needed a conversation starter."
	icon_state = "bandshirt_light"

/obj/item/clothing/under/vampire/suspenders
	name = "suspenders outfit"
	desc = "Grey slacks, white button-up, and a pair of old-timey suspenders."
	icon_state = "suspenders"

/obj/item/clothing/under/vampire/suspenders_fancy
	name = "suspenders outfit"
	desc = "Black slacks, white button-up, a pair of old-timey suspenders, and some very fancy gold cuff-links."
	icon_state = "suspenders_fancy"

/obj/item/clothing/under/vampire/buttonup_red
	name = "red button-up"
	desc = "A dark red button-up shirt worn with dark jeans. Hides bloodstains pretty good."
	icon_state = "redbutton"

//Pants and Shorts and Skirts


/obj/item/clothing/under/vampire/pants
	name = "black pants"
	desc = "These pants are dark, like your soul."
	body_parts_covered = GROIN|LEGS
	icon_state = "blackpants"

/obj/item/clothing/under/vampire/pants/baggy
	name = "black baggy pants"
	icon_state = "baggy_blackpants"

/obj/item/clothing/under/vampire/pants/blackjeans
	name = "black jeans"
	desc = "You feel cooler already."
	icon_state = "jeansblack"

/obj/item/clothing/under/vampire/pants/blackjeansbaggy
	name = "baggy black jeans"
	desc = "You feel cooler already."
	icon_state = "baggy_jeansblack"

/obj/item/clothing/under/vampire/pants/blackjeansripped
	name = "ripped black jeans"
	desc = "The holes cost extra."
	icon_state = "jeansblackripped"

/obj/item/clothing/under/vampire/pants/greyjeans
	name = "grey jeans"
	desc = "Only for those who can pull it off."
	icon_state = "jeansgrey"

/obj/item/clothing/under/vampire/pants/greyjeansbaggy
	name = "baggy grey jeans"
	desc = "You feel cooler already."
	icon_state = "baggy_jeansgrey"

/obj/item/clothing/under/vampire/pants/greyjeansripped
	name = "ripped grey jeans"
	desc = "The holes cost extra."
	icon_state = "jeansgreyripped"

/obj/item/clothing/under/vampire/pants/bluejeans
	name = "classic jeans"
	desc = "Classic blue jeans, rugged!"
	icon_state = "jeansclassic"

/obj/item/clothing/under/vampire/pants/bluejeansbaggy
	name = "baggy classic jeans"
	desc = "Classic blue jeans, rugged!"
	icon_state = "baggy_jeansclassic"

/obj/item/clothing/under/vampire/pants/bluejeansripped
	name = "ripped classic jeans"
	desc = "The holes cost extra."
	icon_state = "jeansclassicripped"

/obj/item/clothing/under/vampire/pants/mustangjeans
	name = "stonewashed jeans"
	desc = "Distressing."
	icon_state = "jeansmustang"

/obj/item/clothing/under/vampire/pants/mustangjeansbaggy
	name = "baggy stonewashed jeans"
	desc = "Distressing."
	icon_state = "baggy_jeansmustang"

/obj/item/clothing/under/vampire/pants/mustangjeansripped
	name = "ripped stonewashed jeans"
	desc = "The holes cost extra."
	icon_state = "jeansmustangripped"

/obj/item/clothing/under/vampire/pants/camo
	name = "camo pants"
	desc = "The military is SO in right now."
	icon_state = "camopants"

/obj/item/clothing/under/vampire/pants/camobaggy
	name = "baggy camo pants"
	desc = "The military is SO in right now."
	icon_state = "baggy_camopants"

/obj/item/clothing/under/vampire/pants/white
	name = "white pants"
	desc = "Good luck keeping these clean."
	icon_state = "whitepants"

/obj/item/clothing/under/vampire/pants/whitebaggy
	name = "baggy white pants"
	desc = "Good luck keeping these clean."
	icon_state = "baggy_whitepants"

/obj/item/clothing/under/vampire/pants/red
	name = "red pants"
	desc = "Extremely easy to keep clean."
	icon_state = "redpants"

/obj/item/clothing/under/vampire/pants/redbaggy
	name = "baggy red pants"
	desc = "Extremely easy to keep clean."
	icon_state = "baggy_redpants"

/obj/item/clothing/under/vampire/pants/khaki
	name = "khaki pants"
	desc = "Approaching the height of fashion."
	icon_state = "khaki"

/obj/item/clothing/under/vampire/pants/khakibaggy
	name = "baggy khaki pants"
	desc = "The absolute height of fashion."
	icon_state = "baggy_khaki"

/obj/item/clothing/under/vampire/pants/trackpants
	name = "black trackpants"
	desc = "A pair of track pants, for the athletic."
	icon_state = "trackpants"

/obj/item/clothing/under/vampire/pants/trackpants/blue
	name = "blue trackpants"
	icon_state = "trackpantsblue"

/obj/item/clothing/under/vampire/pants/trackpants/green
	name = "green trackpants"
	icon_state = "trackpantsgreen"

/obj/item/clothing/under/vampire/pants/trackpants/red
	name = "red trackpants"
	icon_state = "trackpantsred"

/obj/item/clothing/under/vampire/pants/trackpants/white
	name = "white trackpants"
	icon_state = "trackpantswhite"


/obj/item/clothing/under/vampire/shorts
	name = "black shorts"
	desc = "Black athletic shorts."
	body_parts_covered = GROIN
	icon_state = "blackshorts"

/obj/item/clothing/under/vampire/shorts/blackshortshort
	name = "black jean short shorts"
	desc = "Jorts, to the connoisseur."
	icon_state = "black_shorts_f"

/obj/item/clothing/under/vampire/shorts/jeanshorts
	name = "blue jean shorts"
	desc = "Jorts, to the connoisseur."
	icon_state = "jeansclassic_shorts"

/obj/item/clothing/under/vampire/shorts/jeanshortshort
	name = "blue jean short shorts"
	desc = "Jorts, to the connoisseur. Janties to the wise."
	icon_state = "jeansclassic_shorts_f"

/obj/item/clothing/under/vampire/shorts/mustangjeanshorts
	name = "stonewashed jean shorts"
	desc = "Jorts, to the connoisseur."
	icon_state = "jeansmustang_shorts"

/obj/item/clothing/under/vampire/shorts/mustangjeanshortshort
	name = "stonewashed jean short shorts"
	desc = "Jorts, to the connoisseur. Janties to the wise."
	icon_state = "jeansmustang_shorts_f"

/obj/item/clothing/under/vampire/shorts/khaki
	name = "khaki shorts"
	desc = "Adventurous!"
	icon_state = "khaki_shorts_f"

/obj/item/clothing/under/vampire/shorts/skirt
	name = "black leather skirt"
	desc = "A leather skirt for a night on the town."
	icon_state = "skirt_short_black"

/obj/item/clothing/under/vampire/shorts/skirtdenim
	name = "short denim skirt"
	desc = "Classic blue jean skirt."
	icon_state = "skirt_short_denim"

/obj/item/clothing/under/vampire/dress/matron_white
	name = "white matronly dress"
	desc = "An curve-flattering white dress with a plunging neckline and sheer lace sleeves."
	icon_state = "matron_white"

/obj/item/clothing/under/vampire/pinup
	name = "pinup skirt"
	desc = "A black skirt and red top fitting for a night on the town."
	icon_state = "pinup"

/obj/item/clothing/under/vampire/maid
	name = "Maid Uniform"
	desc = "An authentic victorian maid uniform. Old fashioned, but nonetheless timeless."
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	icon_state = "maid"
	inhand_icon_state = "maid"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS


