/obj/machinery/mineral/equipment_vendor/fastfood
	name = "Clerk Catalogue"
	desc = "Order some fastfood here."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "menu"
	icon_deny = "menu"
	prize_list = list()
	var/dispenses_dollars = TRUE

/obj/machinery/mineral/equipment_vendor/fastfood/sodavendor
	name = "Drink Vendor"
	desc = "Order drinks here."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "vend_r"
	anchored = TRUE
	density = TRUE
	owner_needed = FALSE
	prize_list = list(new /datum/data/mining_equipment("cola", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola, 10),
		new /datum/data/mining_equipment("soda", /obj/item/reagent_containers/food/drinks/soda_cans/vampiresoda, 5)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/sodavendor/blue
	icon_state = "vend_c"
	prize_list = list(new /datum/data/mining_equipment("cola", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola/blue,10),
		new /datum/data/mining_equipment("soda", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola/blue, 5),
		new /datum/data/mining_equipment("summer thaw", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/summer_thaw, 5),
		new /datum/data/mining_equipment("thaw club soda", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/thaw_club, 7)
	)
/obj/machinery/mineral/equipment_vendor/fastfood/coffeevendor
	name = "Coffee Vendor"
	desc = "For those sleepy mornings."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "vend_g"
	anchored = TRUE
	density = TRUE
	owner_needed = FALSE
	prize_list = list(new /datum/data/mining_equipment("coffee", /obj/item/reagent_containers/food/drinks/coffee/vampire, 10),
		new /datum/data/mining_equipment("strong coffee", /obj/item/reagent_containers/food/drinks/coffee/vampire/robust, 5)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/AltClick(mob/user)
	. = ..()
	if(points && dispenses_dollars)
		for(var/i in 1 to points)
			new /obj/item/stack/dollar(loc)
		points = 0

/obj/machinery/mineral/equipment_vendor/fastfood/snacks
	name = "Snack Vendor"
	desc = "That candy bar better not get stuck this time..."
	icon_state = "vend_b"
	anchored = TRUE
	density = TRUE
	owner_needed = FALSE
	prize_list = list(new /datum/data/mining_equipment("chocolate bar", /obj/item/food/chocolatebar, 3),
		new /datum/data/mining_equipment("chips", /obj/item/food/vampire/crisps, 5)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/bacotell
	prize_list = list(new /datum/data/mining_equipment("square pizza", /obj/item/food/pizzaslice/square, 15),
		new /datum/data/mining_equipment("taco", /obj/item/food/taco, 10),
		new /datum/data/mining_equipment("burger", /obj/item/food/burger/plain, 20),
		new /datum/data/mining_equipment("two liter cola bottle", /obj/item/reagent_containers/food/drinks/bottle/vampirecola, 10),
		new /datum/data/mining_equipment("cola can", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola, 5),
		new /datum/data/mining_equipment("summer thaw", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/summer_thaw, 5),
		new /datum/data/mining_equipment("thaw club soda", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/thaw_club, 8),
	)

/obj/machinery/mineral/equipment_vendor/fastfood/bubway
	prize_list = list(new /datum/data/mining_equipment("donut", /obj/item/food/donut/plain, 5),
		new /datum/data/mining_equipment("burger", /obj/item/food/burger/plain, 10),
		new /datum/data/mining_equipment("coffee", /obj/item/reagent_containers/food/drinks/coffee/vampire, 5),
		new /datum/data/mining_equipment("robust coffee", /obj/item/reagent_containers/food/drinks/coffee/vampire/robust, 10),
		new /datum/data/mining_equipment("thaw club soda", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/thaw_club, 8)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/gummaguts
	prize_list = list(new /datum/data/mining_equipment("five-piece chicken wing box", /obj/item/storage/fancy/nugget_box, 5),
		new /datum/data/mining_equipment("burger", /obj/item/food/burger/plain, 15),
		new /datum/data/mining_equipment("square pizza", /obj/item/food/pizzaslice/square, 10),
		new /datum/data/mining_equipment("two liter cola bottle", /obj/item/reagent_containers/food/drinks/bottle/vampirecola, 10),
		new /datum/data/mining_equipment("cola can", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola, 5)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/products
	desc = "Purchase junkfood and crap."
	prize_list = list(new /datum/data/mining_equipment("chocolate bar", /obj/item/food/chocolatebar, 3),
		new /datum/data/mining_equipment("chips", /obj/item/food/vampire/crisps, 5),
		new /datum/data/mining_equipment("water bottle", /obj/item/reagent_containers/food/drinks/bottle/vampirewater, 3),
		new /datum/data/mining_equipment("soda can", /obj/item/reagent_containers/food/drinks/soda_cans/vampiresoda, 3),
		new /datum/data/mining_equipment("two liter cola bottle", /obj/item/reagent_containers/food/drinks/bottle/vampirecola, 7),
		new /datum/data/mining_equipment("cola can", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola, 5),
		new /datum/data/mining_equipment("summer thaw", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/summer_thaw, 5),
		new /datum/data/mining_equipment("milk", /obj/item/reagent_containers/food/condiment/milk, 5),
		new /datum/data/mining_equipment("beer bottle", /obj/item/reagent_containers/food/drinks/beer/vampire, 10),
		new /datum/data/mining_equipment("blue stripe", /obj/item/reagent_containers/food/drinks/beer/vampire/blue_stripe, 8),
		new /datum/data/mining_equipment("candle pack", /obj/item/storage/fancy/candle_box, 12),
		new /datum/data/mining_equipment("bruise pack", /obj/item/stack/medical/bruise_pack, 100),
		new /datum/data/mining_equipment("respirator", /obj/item/clothing/mask/vampire, 35)
	)

/obj/machinery/mineral/equipment_vendor/fastfood/grocery
	desc = "A small grocery store."
	prize_list = list(
		new /datum/data/mining_equipment("chocolate bar", /obj/item/food/chocolatebar, 3),
		new /datum/data/mining_equipment("chips", /obj/item/food/vampire/crisps, 5),
		new /datum/data/mining_equipment("water bottle", /obj/item/reagent_containers/food/drinks/bottle/vampirewater, 3),
		new /datum/data/mining_equipment("soda can", /obj/item/reagent_containers/food/drinks/soda_cans/vampiresoda, 3),
		new /datum/data/mining_equipment("two liter cola bottle", /obj/item/reagent_containers/food/drinks/bottle/vampirecola, 7),
		new /datum/data/mining_equipment("cola can", /obj/item/reagent_containers/food/drinks/soda_cans/vampirecola, 5),
		new /datum/data/mining_equipment("summer thaw", /obj/item/reagent_containers/food/drinks/bottle/vampirecola/summer_thaw, 5),
		new /datum/data/mining_equipment("milk", /obj/item/reagent_containers/food/condiment/milk, 5),
		new /datum/data/mining_equipment("bread", /obj/item/food/bread/plain, 8),
		new /datum/data/mining_equipment("spaghetti", /obj/item/food/spaghetti, 6),
		new /datum/data/mining_equipment("tomato", /obj/item/food/grown/tomato, 1),
		new /datum/data/mining_equipment("cabbage", /obj/item/food/grown/cabbage, 1),
		new /datum/data/mining_equipment("garlic", /obj/item/food/grown/garlic, 1),
		new /datum/data/mining_equipment("onion", /obj/item/food/grown/onion, 1),
		new /datum/data/mining_equipment("parsnip", /obj/item/food/grown/parsnip, 1),
		new /datum/data/mining_equipment("peas", /obj/item/food/grown/peas, 1),
		new /datum/data/mining_equipment("corn", /obj/item/food/grown/corn, 1),
		new /datum/data/mining_equipment("apple", /obj/item/food/grown/apple, 1),
		new /datum/data/mining_equipment("berries", /obj/item/food/grown/berries, 1),
		new /datum/data/mining_equipment("banana", /obj/item/food/grown/banana, 1),
		new /datum/data/mining_equipment("cooking enzymes", /obj/item/reagent_containers/food/condiment/enzyme, 12),
		new /datum/data/mining_equipment("salt shaker", /obj/item/reagent_containers/food/condiment/saltshaker, 3),
		new /datum/data/mining_equipment("pepper mill", /obj/item/reagent_containers/food/condiment/peppermill, 3),
		//new /datum/data/mining_equipment("bbq sauce", /obj/item/reagent_containers/food/condiment/bbq, 3),
		new /datum/data/mining_equipment("soy sauce", /obj/item/reagent_containers/food/condiment/soysauce, 4),
		new /datum/data/mining_equipment("mayonnaise", /obj/item/reagent_containers/food/condiment/mayonnaise, 3),
		new /datum/data/mining_equipment("stick of butter", /obj/item/food/butter, 1),
		new /datum/data/mining_equipment("egg carton", /obj/item/storage/fancy/egg_box, 3),
		new /datum/data/mining_equipment("flour bag", /obj/item/reagent_containers/food/condiment/flour, 4),
		new /datum/data/mining_equipment("rice bag", /obj/item/reagent_containers/food/condiment/rice, 4),
		new /datum/data/mining_equipment("sugar bag", /obj/item/reagent_containers/food/condiment/sugar, 4),
		new /datum/data/mining_equipment("beer bottle", /obj/item/reagent_containers/food/drinks/beer/vampire, 10),
		new /datum/data/mining_equipment("blue stripe", /obj/item/reagent_containers/food/drinks/beer/vampire/blue_stripe, 8),
		new /datum/data/mining_equipment("candle pack", /obj/item/storage/fancy/candle_box, 12),
		new /datum/data/mining_equipment("bruise pack", /obj/item/stack/medical/bruise_pack, 100),
		new /datum/data/mining_equipment("kitchen knife", /obj/item/kitchen/knife, 26),
		new /datum/data/mining_equipment("rolling pin", /obj/item/kitchen/rollingpin, 8),
		new /datum/data/mining_equipment("mixing bowl", /obj/item/reagent_containers/glass/mixing_bowl, 15),
	)

/obj/machinery/mineral/equipment_vendor/fastfood/deli
	desc = "Meats and cheese!"
	prize_list = list(
		new /datum/data/mining_equipment("deli cut beef", /obj/item/food/meat/slab, 4),
		new /datum/data/mining_equipment("cutlet", /obj/item/food/meat/rawcutlet, 1),
		new /datum/data/mining_equipment("bacon", /obj/item/food/meat/rawbacon, 1),
		new /datum/data/mining_equipment("meatball", /obj/item/food/raw_meatball, 1),
		new /datum/data/mining_equipment("patty", /obj/item/food/raw_patty, 1),
		new /datum/data/mining_equipment("sausage", /obj/item/food/raw_sausage, 1),
		new /datum/data/mining_equipment("salami", /obj/item/food/salami, 1),
		new /datum/data/mining_equipment("chicken breast", /obj/item/food/meat/slab/chicken, 3),
		new /datum/data/mining_equipment("fish fillet", /obj/item/food/fishmeat, 3),
		new /datum/data/mining_equipment("cheese wheel", /obj/item/food/cheesewheel, 12),
		new /datum/data/mining_equipment("sandwich", /obj/item/food/sandwich, 3),
	)
