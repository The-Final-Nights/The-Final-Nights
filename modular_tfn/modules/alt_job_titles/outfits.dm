// TOWER ROLES BEGIN HERE

/datum/outfit/job/towerwork/towercleaner
	name = "Tower Employee (Tower Cleaner)"
	uniform = /obj/item/clothing/under/vampire/janitor
	suit = null
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	gloves = /obj/item/clothing/gloves/vampire/cleaning

/datum/outfit/job/towerwork/towerassistant
	name = "Tower Employee (Tower Assistant)"
	uniform = /obj/item/clothing/under/vampire/office
	gloves = null
	suit = null
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/clipboard=1, /obj/item/pen=1, /obj/item/folder/blue=1)

/datum/outfit/job/towerwork/towersecurityguard
	name = "Tower Employee (Tower Security Guard)"
	uniform = /obj/item/clothing/under/vampire/guard
	shoes = /obj/item/clothing/shoes/vampire
	gloves = null
	suit = null
	belt = /obj/item/gun/ballistic/automatic/vampire/m1911
	backpack_contents = list(/obj/item/flashlight=1, /obj/item/vamp/creditcard=1,/obj/item/food/vampire/donut=5, /obj/item/cockclock=1)

/datum/outfit/job/towerwork/towerpersonaldriver
	name = "Tower Employee (Tower Personal Driver)"
	uniform = /obj/item/clothing/under/vampire/suit
	suit = null
	head = /obj/item/clothing/head/vampire/chauffeur
	gloves = /obj/item/clothing/gloves/vampire/white

/datum/outfit/job/towerwork/towerpersonaldriver/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female

/datum/outfit/job/towerwork/towerpersonalattendant
	name = "Tower Employee (Tower Personal Attendant)"
	uniform = /obj/item/clothing/under/vampire/suit
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1, /obj/item/clipboard=1, /obj/item/pen=1, /obj/item/folder/red=1)

/datum/outfit/job/towerwork/towerpersonalattendant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		uniform = /obj/item/clothing/under/vampire/suit/female
		shoes = /obj/item/clothing/shoes/vampire/heels

// TOWER ROLES END HERE