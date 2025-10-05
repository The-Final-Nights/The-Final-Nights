/obj/machinery/mineral/equipment_vendor/fastfood/illegal	// PSEUDO_M make this restricted and only available for Axes
	prize_list = list(
		new /datum/data/mining_equipment("lighter",		/obj/item/lighter/greyscale,	10),
		new /datum/data/mining_equipment("zippo lighter",	/obj/item/lighter,	20),
		new /datum/data/mining_equipment("Bailer", /obj/item/bailer, 20),
		new /datum/data/mining_equipment("Weed Seed", /obj/item/weedseed, 20),
		new /datum/data/mining_equipment("cannabis puff",		/obj/item/clothing/mask/cigarette/rollie/cannabis,	40),
		new /datum/data/mining_equipment("bong",	/obj/item/bong,		50),
		new /datum/data/mining_equipment("lockpick",	/obj/item/vamp/keys/hack, 50),
		new /datum/data/mining_equipment("Handcuffs", /obj/item/restraints/handcuffs, 50),
		new /datum/data/mining_equipment("Black bag", /obj/item/clothing/head/vampire/blackbag, 50),
		new /datum/data/mining_equipment("LSD pill bottle",		/obj/item/storage/pill_bottle/lsd,	50),
		new /datum/data/mining_equipment("knife",	/obj/item/melee/vampirearms/knife,	85),
		new /datum/data/mining_equipment("switchblade",	/obj/item/melee/vampirearms/knife/switchblade, 85),
		new /datum/data/mining_equipment("stake",	/obj/item/vampire_stake,	100),
		new /datum/data/mining_equipment("Surgery dufflebag", /obj/item/storage/backpack/duffelbag/med/surgery, 100),
		new /datum/data/mining_equipment("snub-nose revolver",	/obj/item/gun/ballistic/vampire/revolver/snub,	100),
		new /datum/data/mining_equipment("pliers",	/obj/item/wirecutters/pliers/bad_pliers,	200),
		new /datum/data/mining_equipment("beretta magazine", /obj/item/ammo_box/magazine/semi9mm, 200),
		new /datum/data/mining_equipment("9mm ammo box", /obj/item/ammo_box/vampire/c9mm, 300),
		new /datum/data/mining_equipment("cannabis package",		/obj/item/weedpack,	700),
		new /datum/data/mining_equipment("morphine syringe",	/obj/item/reagent_containers/syringe/contraband/morphine,	800),
		new	/datum/data/mining_equipment("meth package",	/obj/item/reagent_containers/food/drinks/meth,	800),
		new	/datum/data/mining_equipment("cocaine package",	/obj/item/reagent_containers/food/drinks/meth/cocaine,	800),
		new	/datum/data/mining_equipment("beretta handgun", /obj/item/gun/ballistic/automatic/vampire/beretta, 1200),
		new	/datum/data/mining_equipment("box of 9mm Silver ammo", /obj/item/ammo_box/vampire/c9mm/silver, 10000)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/pharmacy
	prize_list = list(
		new /datum/data/mining_equipment("dropper", /obj/item/reagent_containers/dropper, 25),
		new /datum/data/mining_equipment("gauze wrap", /obj/item/stack/medical/gauze, 50),
		new /datum/data/mining_equipment("bruise pack", /obj/item/stack/medical/bruise_pack, 100),
		new /datum/data/mining_equipment("burn ointment", /obj/item/stack/medical/ointment, 100),
		new /datum/data/mining_equipment("potassium iodide pill bottle", /obj/item/storage/pill_bottle/potassiodide, 100),
		new /datum/data/mining_equipment("surgical tape", /obj/item/stack/sticky_tape/surgical, 100),
		new /datum/data/mining_equipment("sutures", /obj/item/stack/medical/suture, 100),
		new /datum/data/mining_equipment("latex gloves", /obj/item/clothing/gloves/vampire/latex, 150),
		new /datum/data/mining_equipment("iron pill bottle", /obj/item/storage/pill_bottle/iron, 150),
		new /datum/data/mining_equipment("ephedrine pill bottle", /obj/item/storage/pill_bottle/ephedrine, 200),
		new /datum/data/mining_equipment("straight jacket", /obj/item/clothing/suit/straight_jacket, 200),
		new /datum/data/mining_equipment("box of syringes", /obj/item/storage/box/syringes, 300),
		new /datum/data/mining_equipment("organ transport container", /obj/item/storage/organbox, 500)
	)


/obj/machinery/mineral/equipment_vendor/fastfood/smoking
	prize_list = list(
		new /datum/data/mining_equipment("lighter",		/obj/item/lighter/greyscale,	10),
		new /datum/data/mining_equipment("zippo lighter",	/obj/item/lighter,	20),
		new /datum/data/mining_equipment("newport",		/obj/item/storage/fancy/cigarettes/cigpack_xeno,	30),
		new /datum/data/mining_equipment("camel",	/obj/item/storage/fancy/cigarettes/dromedaryco,	30),
		new /datum/data/mining_equipment("carp classic",	/obj/item/storage/fancy/cigarettes/cigpack_carp,	30),
		new /datum/data/mining_equipment("malboro",	/obj/item/storage/fancy/cigarettes/cigpack_robust,	50),
		new /datum/data/mining_equipment("robust gold", /obj/item/storage/fancy/cigarettes/cigpack_robustgold, 100),
		new /datum/data/mining_equipment("cigar ", /obj/item/storage/fancy/cigarettes/cigars, 100),
		new /datum/data/mining_equipment("havana cigar", /obj/item/storage/fancy/cigarettes/cigars/havana, 100),
		new /datum/data/mining_equipment("cohiba cigar", /obj/item/storage/fancy/cigarettes/cigars/cohiba, 100)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/gas
	prize_list = list(new /datum/data/mining_equipment("full gas can",	/obj/item/gas_can/full,	250),
		new /datum/data/mining_equipment("tire iron",		/obj/item/melee/vampirearms/tire,	50),
		new /datum/data/mining_equipment("Spray Paint",		/obj/item/toy/crayon/spraycan,		25),
		new /datum/data/mining_equipment("Hair Spray",		/obj/item/dyespray,		10),
	)

/obj/machinery/mineral/equipment_vendor/fastfood/library
	owner_needed = FALSE
	prize_list = list(
		new /datum/data/mining_equipment("black pen",	/obj/item/pen,  5),
		new /datum/data/mining_equipment("folder",	/obj/item/folder,  5),
		new /datum/data/mining_equipment("four-color pen",	/obj/item/pen/fourcolor,  10),
		new /datum/data/mining_equipment("box of crayons", /obj/item/storage/crayons, 10),
		new /datum/data/mining_equipment("fountain pen",	/obj/item/pen/fountain,  15),
		new /datum/data/mining_equipment("canvas (19x19)", /obj/item/canvas/nineteen_nineteen, 19),
		new /datum/data/mining_equipment("canvas (23x19)", /obj/item/canvas/twentythree_nineteen, 23),
		new /datum/data/mining_equipment("canvas (23x23)", /obj/item/canvas/twentythree_twentythree, 23),
		new /datum/data/mining_equipment("canvas (24x24)", /obj/item/canvas/twentyfour_twentyfour, 24),
		new /datum/data/mining_equipment("canvas (36x24)", /obj/item/canvas/thirtysix_twentyfour, 36),
		new /datum/data/mining_equipment("canvas (45x27)", /obj/item/canvas/fortyfive_twentyseven, 45),
		new /datum/data/mining_equipment("paper bin", /obj/item/paper_bin, 20),
		new /datum/data/mining_equipment("paint palette", /obj/item/paint_palette, 20),
		new /datum/data/mining_equipment("Bible",	/obj/item/storage/book/bible,  20),
		new /datum/data/mining_equipment("Quran",	/obj/item/vampirebook/quran,  20),
		new /datum/data/mining_equipment("Torah", /obj/item/vampirebook/torah, 20),
		new /datum/data/mining_equipment("spray paint", /obj/item/toy/crayon/spraycan, 25)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/antique
	prize_list = list(
		new /datum/data/mining_equipment("katana", /obj/item/melee/vampirearms/katana, 1000),
		new /datum/data/mining_equipment("rapier", /obj/item/storage/belt/vampire/sheathe/rapier, 1200),
		new /datum/data/mining_equipment("sabre", /obj/item/storage/belt/vampire/sheathe/sabre, 1400),
		new /datum/data/mining_equipment("longsword", /obj/item/storage/belt/vampire/sheathe/longsword, 1600)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/camping
	prize_list = list(
		new /datum/data/mining_equipment("camera film", /obj/item/camera_film, 30),
		new /datum/data/mining_equipment("hunting knife", /obj/item/melee/vampirearms/knife, 85),
		new /datum/data/mining_equipment("tent stake", /obj/item/vampire_stake, 100),
		new /datum/data/mining_equipment("shovel", /obj/item/melee/vampirearms/shovel, 150),
		new /datum/data/mining_equipment("fishing rod",		/obj/item/fishing_rod,	200),
		new /datum/data/mining_equipment("hunting rifle magazine, 5.56",/obj/item/ammo_box/magazine/vamp556/hunt,	200),
		new /datum/data/mining_equipment("pepperspray", /obj/item/reagent_containers/spray/pepper, 200),
		new /datum/data/mining_equipment("SNEKTEK Handheld Taser", /obj/item/melee/baton/handtaser, 200),
		new /datum/data/mining_equipment("beretta magazine", /obj/item/ammo_box/magazine/semi9mm, 200),
		new /datum/data/mining_equipment("binoculars", /obj/item/binoculars, 300),
		new /datum/data/mining_equipment("camera", /obj/item/camera, 300),
		new /datum/data/mining_equipment("9mm ammo box", /obj/item/ammo_box/vampire/c9mm, 300),
		new /datum/data/mining_equipment("12ga shotgun shells, buckshot",/obj/item/ammo_box/vampire/c12g/buck,	400),
		new /datum/data/mining_equipment("machete", /obj/item/melee/vampirearms/machete, 500),
		new /datum/data/mining_equipment("hunting shotgun", /obj/item/gun/ballistic/shotgun/vampire, 1000),
		new	/datum/data/mining_equipment("beretta handgun", /obj/item/gun/ballistic/automatic/vampire/beretta, 1200),
		new /datum/data/mining_equipment("rescue fireaxe", /obj/item/melee/vampirearms/fireaxe, 1800),
		new /datum/data/mining_equipment("chainsaw", /obj/item/melee/vampirearms/chainsaw, 2000),
		new /datum/data/mining_equipment("hunting rifle", /obj/item/gun/ballistic/automatic/vampire/huntrifle, 2000),
		new /datum/data/mining_equipment("5.56 ammo",	/obj/item/ammo_box/vampire/c556,	2000),
	)

/obj/machinery/mineral/equipment_vendor/fastfood/music
	prize_list = list(
		new /datum/data/mining_equipment("accordian", /obj/item/instrument/accordion, 200),
		new /datum/data/mining_equipment("electric guitar", /obj/item/instrument/eguitar, 200),
		new /datum/data/mining_equipment("accoustic guitar", /obj/item/instrument/guitar, 200),
		new /datum/data/mining_equipment("hands free harmonica", /obj/item/instrument/harmonica, 200),
		new /datum/data/mining_equipment("saxophone", /obj/item/instrument/saxophone, 200),
		new /datum/data/mining_equipment("trombone", /obj/item/instrument/trombone, 200),
		new /datum/data/mining_equipment("violin", /obj/item/instrument/violin, 200),
		new /datum/data/mining_equipment("banjo", /obj/item/instrument/banjo, 200),
		new /datum/data/mining_equipment("electronic synth", /obj/item/instrument/piano_synth, 200),
		new /datum/data/mining_equipment("recorder", /obj/item/instrument/recorder, 200),
		new /datum/data/mining_equipment("glockeenspiel", /obj/item/instrument/glockenspiel, 200)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/general
	prize_list = list(
		new /datum/data/mining_equipment("damp cleaning rag", /obj/item/reagent_containers/glass/rag, 5),
		new /datum/data/mining_equipment("cassette tapes", /obj/item/tape, 10),
		new /datum/data/mining_equipment("flashlight", /obj/item/flashlight, 10),
		new /datum/data/mining_equipment("cleaning mop", /obj/item/mop, 20),
		new /datum/data/mining_equipment("plastic bucket", /obj/item/reagent_containers/glass/bucket, 20),
		new /datum/data/mining_equipment("push broom", /obj/item/pushbroom, 20),
		new /datum/data/mining_equipment("plastic trash bags", /obj/item/storage/bag/trash, 20),
		new /datum/data/mining_equipment("screwdriver", /obj/item/screwdriver, 20),
		new /datum/data/mining_equipment("crowbar", /obj/item/crowbar, 20),
		new /datum/data/mining_equipment("wrench", /obj/item/wrench, 20),
		new /datum/data/mining_equipment("wirecutters", /obj/item/wirecutters, 20),
		new /datum/data/mining_equipment("handheld welder", /obj/item/weldingtool, 20),
		new /datum/data/mining_equipment("toner cartridge", /obj/item/toner/large, 30),
		new /datum/data/mining_equipment("construction hard hat", /obj/item/clothing/head/vampire/hardhat, 50),
		new /datum/data/mining_equipment("shaving razor", /obj/item/razor, 50),
		new /datum/data/mining_equipment("tape recorder", /obj/item/taperecorder, 50),
		new /datum/data/mining_equipment("baseball bat", /obj/item/melee/vampirearms/baseball, 50),
		new /datum/data/mining_equipment("prepaid cell phone", /obj/item/vamp/phone, 100),
		new /datum/data/mining_equipment("box of light bulbs", /obj/item/wirecutters, 100),
		new /datum/data/mining_equipment("insulated gloves", /obj/item/clothing/gloves/color/yellow, 200),
	)
