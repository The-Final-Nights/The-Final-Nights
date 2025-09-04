/datum/crafting_recipe/typhon_brew
	name = "Thyphon's Brew"
	reqs = list(/obj/item/reagent_containers/food/drinks/beer/vampire = 1, /datum/reagent/blood/vitae = 200)
	result = /obj/item/reagent_containers/food/drinks/beer/vampire/typhon
	time = 1 SECONDS
	category = CAT_DRUGS
	always_available = FALSE

/datum/crafting_recipe/food/meatbread
	name = "Meat bread"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/meat/cutlet/plain = 3,
		/obj/item/food/cheesewedge = 3
	)
	result = /obj/item/food/bread/meat
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/banananutbread
	name = "Banana nut bread"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/boiledegg = 3,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/bread/banana
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/creamcheesebread
	name = "Cream cheese bread"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/bread/plain = 1,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/bread/creamcheese
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/garlicbread
	name = "Garlic Bread"
	time = 40
	reqs = list(/obj/item/food/grown/garlic = 1,
				/obj/item/food/breadslice/plain = 1,
				/obj/item/food/butter = 1
	)
	result = /obj/item/food/garlicbread
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/butterbiscuit
	name = "Butter Biscuit"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/butterbiscuit
	subcategory = CAT_BREAD

/datum/crafting_recipe/food/burger
	name = "Burger"
	reqs = list(
			/obj/item/food/meat/steak/plain = 1,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/plain
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/fishburger
	name = "Fish burger"
	reqs = list(
		/obj/item/food/fishmeat = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/fish
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/baconburger
	name = "Bacon Burger"
	reqs = list(
			/obj/item/food/meat/bacon = 3,
			/obj/item/food/bun = 1
	)

	result = /obj/item/food/burger/baconburger
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/ribburger
	name = "McRib"
	reqs = list(
			/obj/item/food/bbqribs = 1, //The sauce is already included in the ribs
			/obj/item/food/onion_slice = 1, //feel free to remove if too burdensome.
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/rib
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/chickenburger
	name = "Chicken Sandwich"
	reqs = list(
			/obj/item/food/meat/steak/chicken = 1,
			/datum/reagent/consumable/mayonnaise = 5,
			/obj/item/food/bun = 1
	)
	result = /obj/item/food/burger/chicken
	subcategory = CAT_BURGER

/datum/crafting_recipe/food/carrotcake
	name = "Carrot cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/carrot = 2
	)
	result = /obj/item/food/cake/carrot
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/chocolatecake
	name = "Chocolate cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/cake/chocolate
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/birthdaycake
	name = "Birthday cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/candle = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/caramel = 2
	)
	result = /obj/item/food/cake/birthday
	subcategory = CAT_CAKE

/datum/crafting_recipe/food/donut
	time = 15
	name = "Donut"
	reqs = list(
		/datum/reagent/consumable/sugar = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/plain
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/donut/choco
	name = "Chocolate Donut"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/choco

/datum/crafting_recipe/food/friedegg
	name = "Fried egg"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/food/egg = 1
	)
	result = /obj/item/food/friedegg
	subcategory = CAT_EGG

/datum/crafting_recipe/food/omelette
	name = "Omelette"
	reqs = list(
		/obj/item/food/egg = 2,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/omelette
	subcategory = CAT_EGG

/datum/crafting_recipe/food/fishandchips
	name = "Fish and chips"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/fishandchips
	subcategory = CAT_MEAT

/datum/crafting_recipe/food/fishfingers
	name = "Fish fingers"
	reqs = list(
		/datum/reagent/consumable/flour = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/fishmeat = 1
	)
	result = /obj/item/food/fishfingers
	subcategory = CAT_MEAT

/*
/datum/crafting_recipe/food/loadedbakedpotato
	name = "Loaded baked potato"
	time = 40
	reqs = list(
		/obj/item/food/grown/potato = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/loaded_baked_potato
	subcategory = CAT_MISCFOOD
*/

/datum/crafting_recipe/food/cheesyfries
	name = "Cheesy fries"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/cheesyfries
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/food/ricepudding
	name = "Rice pudding"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/salad/boiledrice = 1
	)
	result = /obj/item/food/salad/ricepudding
	subcategory = CAT_MISCFOOD

/*
/datum/crafting_recipe/food/onigiri
	name = "Onigiri"
	reqs = list(
		/obj/item/food/grown/seaweed/sheet = 1,
		/obj/item/food/salad/boiledrice = 1
	)
	result = /obj/item/food/onigiri
	subcategory = CAT_MISCFOOD
*/

/datum/crafting_recipe/food/waffles
	time = 15
	name = "Waffles"
	reqs = list(
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/waffles
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/pancakes
	name = "Pancake"
	reqs = list(
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/pancakes
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/muffin
	time = 15
	name = "Muffin"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/muffin
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/berrymuffin
	name = "Berry muffin"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/muffin/berry
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/poppypretzel
	time = 15
	name = "Poppy pretzel"
	reqs = list(
		/obj/item/seeds/poppy = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/poppypretzel
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/bananacreampie
	name = "Banana cream pie"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/pie/cream
	subcategory = CAT_PIE

/datum/crafting_recipe/food/meatpie
	name = "Meat pie"
	reqs = list(
		/datum/reagent/consumable/blackpepper = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/steak/plain = 1
	)
	result = /obj/item/food/pie/meatpie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/pumpkinpie
	name = "Pumpkin pie"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin = 1
	)
	result = /obj/item/food/pie/pumpkinpie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/grapetart
	name = "Grape tart"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/grapes = 3
	)
	result = /obj/item/food/pie/grapetart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/berrytart
	name = "Berry tart"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 3
	)
	result = /obj/item/food/pie/berrytart
	subcategory = CAT_PIE

/datum/crafting_recipe/food/applepie
	name = "Apple pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/pie/applepie
	subcategory = CAT_PIE

/datum/crafting_recipe/food/nachos
	name ="Nachos"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/tortilla = 1
	)
	result = /obj/item/food/nachos
	subcategory = CAT_MEXICAN

/datum/crafting_recipe/food/taco
	name ="Classic Taco"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/meat/cutlet = 1,
		/obj/item/food/grown/cabbage = 1,
	)
	result = /obj/item/food/taco
	subcategory = CAT_MEXICAN

/datum/crafting_recipe/food/tacoplain
	name ="Plain Taco"
	reqs = list(
		/obj/item/food/tortilla = 1,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/meat/cutlet = 1,
	)
	result = /obj/item/food/taco/plain
	subcategory = CAT_MEXICAN

/datum/crafting_recipe/food/enchiladas
	name = "Enchiladas"
	reqs = list(
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/chili = 2,
		/obj/item/food/tortilla = 2
	)
	result = /obj/item/food/enchiladas
	subcategory = CAT_MEXICAN

//Sandwiches
/datum/crafting_recipe/food/sandwich
	name = "Sandwich"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/cheesewedge = 1
	)
	result = /obj/item/food/sandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/grilledcheesesandwich
	name = "Cheese sandwich"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/grilled_cheese_sandwich
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/blt
	name = "BLT"
	reqs = list(
		/obj/item/food/breadslice/plain = 2,
		/obj/item/food/meat/bacon = 2,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/blt
	subcategory = CAT_SANDWICH

/datum/crafting_recipe/food/hotdog
	name = "Hotdog"
	reqs = list(
		/obj/item/food/bun = 1,
		/obj/item/food/sausage = 1,
		/datum/reagent/consumable/ketchup = 5
	)
	result = /obj/item/food/hotdog
	subcategory = CAT_SANDWICH
