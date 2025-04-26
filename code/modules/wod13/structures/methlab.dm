/obj/structure/methlab
	name = "chemical laboratory"
	desc = "\"Jesse... It's not about style, it's about science... I forgor in what order... But you should mix gasoline, 2 potassium iodide pills or mix of full coffee cup and vodka bottle... then add 3-4 ephedrine pills and mix it... May your ass not be blown off...\""
	icon = 'code/modules/wod13/32x48.dmi'
	icon_state = "methlab"
	anchored = TRUE
	density = TRUE
	var/troll_explode = FALSE	//HE FAILED THE ORDER (
	var/added_ephed = 0		//we need to add 3 pills each
	var/added_iod = 0		//gonna be 2 iod pills or coffee+vodka
	var/added_gas = FALSE	//fill it up boi
	var/reacting = FALSE

/obj/structure/methlab/movable
	name = "movable chemical lab"
	desc = "Not an RV, but it moves..."
	anchored = FALSE
	var/health = 20

/obj/structure/methlab/movable/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to [anchored ? "un" : ""]secure [src] [anchored ? "from" : "to"] the ground.")

	if(health == 20)
		. += span_notice("[src] is in good condition.")
	else if(health > 16)
		. += span_notice("[src] is lightly damaged.")
	else if(health > 10)
		. += span_warning("[src] has sustained some damage.")
	else if(health > 6)

		. += span_warning("[src] is close to breaking!")
	else
		. += span_warning("[src] is about to fall apart!")

/obj/structure/methlab/AltClick(mob/user)
	if(!user.Adjacent(src))
		return
	to_chat(user, span_notice("You start [anchored ? "unsecuring" : "securing"] [src] [anchored ? "from" : "to"] the ground."))
	if(do_after(user, 15))
		if(anchored)
			to_chat(user, span_notice("You unsecure [src] from the ground."))
			anchored = FALSE
			return
		else
			to_chat(user, span_notice("You secure [src] to the ground."))
			anchored = TRUE
			return

/obj/structure/methlab/movable/attackby(obj/item/used_item, mob/user, params)
	. = ..()
	if(!.)
		return

	if(reacting && !troll_explode)
		health -= 1
		if(health <= 0)
			troll_explode = TRUE
			return
		if(health > 16)
			return
		var/probability = 0
		if(health >= 10)
			probability = 5
		else if(health >= 6)
			probability = 10
		else
			probability = 20
		if(prob(probability))
			troll_explode = TRUE

/obj/structure/methlab/attackby(obj/item/used_item, mob/user, params)
	if(reacting)
		return FALSE
	if(istype(used_item, /obj/item/reagent_containers/pill/ephedrine))
		added_ephed += 1
		to_chat(user, span_notice("You [pick("insert", "add", "mix")] [added_ephed] [used_item] in [src]."))
		qdel(used_item)
		. = TRUE
	else if(istype(used_item, /obj/item/reagent_containers/pill/potassiodide))
		if(added_ephed != 3)
			troll_explode = TRUE
		added_iod += 1
		to_chat(user, span_notice("You [pick("insert", "add", "mix")] [added_iod] [used_item] in [src]."))
		if(prob(20))
			to_chat(user, span_warning("Reagents start to react strangely..."))
		qdel(used_item)
		. = TRUE
	else if(istype(used_item, /obj/item/reagent_containers/food/drinks/coffee/vampire))
		if(added_iod != 0)
			troll_explode = TRUE
		added_iod += 1
		to_chat(user, span_notice("You [pick("throw", "blow", "spit")] [used_item] in [src]."))
		if(prob(20))
			to_chat(user, span_warning("Reagents start to react strangely..."))
		qdel(used_item)
		. = TRUE
	else if(istype(used_item, /obj/item/reagent_containers/food/drinks/bottle/vodka))
		if(added_iod != 1)
			troll_explode = TRUE
		added_iod += 1
		to_chat(user, span_notice("You [pick("throw", "blow", "spit")] [used_item] in [src]."))
		if(prob(20))
			to_chat(user, span_warning("Reagents start to react strangely..."))
		qdel(used_item)
		. = TRUE
	else if(istype(used_item, /obj/item/gas_can))
		var/obj/item/gas_can/gas_can = used_item
		if(added_gas || gas_can.stored_gasoline < 100)
			return ..()
		gas_can.stored_gasoline -= 100
		playsound(loc, 'code/modules/wod13/sounds/gas_fill.ogg', 25, TRUE)
		to_chat(user, span_warning("You [pick("spill", "add", "blender")] [used_item] in [src]."))
		added_gas = TRUE
		if(prob(20))
			to_chat(user, span_warning("Something may be going wrong, or may not..."))
		. = TRUE
	else
		return ..()
	if(added_gas && added_ephed != 0 && added_iod != 0)
		reacting = TRUE
		playsound(src, 'code/modules/wod13/sounds/methcook.ogg', 50, TRUE)
		addtimer(CALLBACK(src, PROC_REF(chemical_reaction)), 3 SECONDS)

/obj/structure/methlab/proc/chemical_reaction()
	playsound(src, 'code/modules/wod13/sounds/methcook.ogg', 100, TRUE)
	var/should_cook = (added_ephed == 3 && added_iod == 2)
	added_ephed = 0
	added_iod = 0
	added_gas = FALSE
	reacting = FALSE

	if(troll_explode)
		troll_explode = FALSE
		explosion(loc,0,1,3,4)
		return
	if(!should_cook)
		new /obj/effect/decal/cleanable/chem_pile(get_turf(src))
		return
#define METH_AMOUNT_PRODUCED 4
	for(var/i = 1 to METH_AMOUNT_PRODUCED)
		new /obj/item/reagent_containers/food/drinks/meth(get_turf(src))
#undef METH_AMOUNT_PRODUCED
