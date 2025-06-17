#define CLINIC_ACCESS_BASIC 1 // Basic, non-medical supplies
#define CLINIC_ACCESS_MEDICAL 2 // Medical supplies, non-controlled meds
#define CLINIC_ACCESS_FULL 3 // All meds, controlled substances
#define CLINIC_ACCESS_ADMIN 4 // Full access, admin functions

// Category string defines
#define CLINIC_CATEGORY_CONTROLLED "Controlled Substances"
#define CLINIC_CATEGORY_MEDICAL "Medical Supplies"
#define CLINIC_CATEGORY_MEDICATIONS "Medications"
#define CLINIC_CATEGORY_STAFF "Staff Equipment"
#define CLINIC_CATEGORY_CLEANING "Cleaning Supplies"
#define CLINIC_CATEGORY_OFFICE "Office Supplies"

// Global lists
GLOBAL_LIST_INIT(CLINIC_stock, init_CLINIC_stock())
GLOBAL_LIST_INIT(CLINIC_reasons, list(
	"Routine Care",
	"Emergency Treatment",
	"Surgery Preparation",
	"Pain Management",
	"Critical Care",
	"Restock",
	"Other (Specify in Notes)"
))

// Job access levels
GLOBAL_LIST_INIT(CLINIC_job_access, list(
	"Medical Student" = CLINIC_ACCESS_BASIC,
	"Intern" = CLINIC_ACCESS_BASIC,

	"Nurse" = CLINIC_ACCESS_MEDICAL,
	"Paramedic" = CLINIC_ACCESS_MEDICAL,
	"EMT" = CLINIC_ACCESS_MEDICAL,

	"Resident" = CLINIC_ACCESS_FULL,
	"General Practitioner" = CLINIC_ACCESS_FULL,
	"Surgeon" = CLINIC_ACCESS_FULL,
	"Physician" = CLINIC_ACCESS_FULL,
	"Doctor" = CLINIC_ACCESS_FULL,

	"Clinic Director" = CLINIC_ACCESS_ADMIN,
	"Malkavian Primogen" = CLINIC_ACCESS_ADMIN
))

// Category access levels
GLOBAL_LIST_INIT(CLINIC_category_access, list(
	CLINIC_CATEGORY_CLEANING = CLINIC_ACCESS_BASIC,
	CLINIC_CATEGORY_OFFICE = CLINIC_ACCESS_BASIC,
	CLINIC_CATEGORY_STAFF = CLINIC_ACCESS_BASIC,

	CLINIC_CATEGORY_MEDICATIONS = CLINIC_ACCESS_MEDICAL,
	CLINIC_CATEGORY_MEDICAL = CLINIC_ACCESS_MEDICAL,

	CLINIC_CATEGORY_CONTROLLED = CLINIC_ACCESS_FULL
))

// Initialize stock - all of it will be alphabetized by the .jsx
/proc/init_CLINIC_stock()
	var/list/stock = list()

	// Medical Supplies
	stock[CLINIC_CATEGORY_MEDICAL] = list(
		list("name" = "Gauze", "path" = /obj/item/stack/medical/gauze, "stock" = 16, "cost" = 10),
		list("name" = "Burn Ointment", "path" = /obj/item/stack/medical/ointment, "stock" = 16, "cost" = 15),
		list("name" = "Medicated Suture", "path" = /obj/item/stack/medical/suture/medicated, "stock" = 16, "cost" = 20),
		list("name" = "Bruise Pack", "path" = /obj/item/stack/medical/bruise_pack, "stock" = 16, "cost" = 15),
		list("name" = "Regenerative Mesh", "path" = /obj/item/stack/medical/mesh/advanced, "stock" = 16, "cost" = 25),
		list("name" = "Regenerative Mesh, Advanced", "path" = /obj/item/stack/medical/mesh/advanced, "stock" = 8, "cost" = 40),
		list("name" = "Synthflesh Patch", "path" = /obj/item/reagent_containers/pill/patch/synthflesh, "stock" = 8, "cost" = 30),
		list("name" = "Aid Kit, Oxygen", "path" = /obj/item/storage/firstaid/o2, "stock" = 6, "cost" = 50),
		list("name" = "Aid Kit, Toxin", "path" = /obj/item/storage/firstaid/toxin, "stock" = 6, "cost" = 50),
		list("name" = "Aid Kit, Burn", "path" = /obj/item/storage/firstaid/fire, "stock" = 6, "cost" = 50),
		list("name" = "Aid Kit, Brute", "path" = /obj/item/storage/firstaid/brute, "stock" = 6, "cost" = 50),
		list("name" = "Aid Kit, Medical", "path" = /obj/item/storage/firstaid/medical, "stock" = 6, "cost" = 60),
		list("name" = "Aid Kit, Advanced", "path" = /obj/item/storage/firstaid/advanced, "stock" = 6, "cost" = 80),

	)

	// Medications
	stock[CLINIC_CATEGORY_MEDICATIONS] = list(
		list("name" = "Iron Pill Bottle", "path" = /obj/item/storage/pill_bottle/iron, "stock" = 6, "cost" = 20),
		list("name" = "Potassium Iodide Pill Bottle", "path" = /obj/item/storage/pill_bottle/potassiodide, "stock" = 6, "cost" = 25),
		list("name" = "Saline Solution", "path" = /obj/item/reagent_containers/glass/bottle/salglu_solution, "stock" = 6, "cost" = 20),
		list("name" = "Multi-Liver Pill Bottle", "path" = /obj/item/storage/pill_bottle/multiver, "stock" = 6, "cost" = 30),
		list("name" = "Neurine Pill Bottle", "path" = /obj/item/storage/pill_bottle/neurine, "stock" = 6, "cost" = 35),
		list("name" = "Pentetic Acid Pill Bottle", "path" = /obj/item/storage/pill_bottle/penacid, "stock" = 6, "cost" = 40),
		list("name" = "Probital Pill Bottle", "path" = /obj/item/storage/pill_bottle/probital, "stock" = 6, "cost" = 35),

	)

	// Controlled Substances
	stock[CLINIC_CATEGORY_CONTROLLED] = list(
		list("name" = "Morphine Bottle", "path" = /obj/item/reagent_containers/glass/bottle/morphine, "stock" = 6, "cost" = 60),
		list("name" = "Atropine Bottle", "path" = /obj/item/reagent_containers/glass/bottle/atropine, "stock" = 4, "cost" = 70),
		list("name" = "Epinephrine Bottle", "path" = /obj/item/reagent_containers/glass/bottle/epinephrine, "stock" = 4, "cost" = 65),
		list("name" = "Epinephrine Auto-Injector", "path" = /obj/item/reagent_containers/hypospray/medipen, "stock" = 6, "cost" = 30),
		list("name" = "Atropine Auto-Injector", "path" = /obj/item/reagent_containers/hypospray/medipen/atropine, "stock" = 6, "cost" = 45),
		list("name" = "Mannitol Pill Bottle", "path" = /obj/item/storage/pill_bottle/mannitol, "stock" = 4, "cost" = 50),
		list("name" = "O- Blood Pack", "path" = /obj/item/reagent_containers/blood, "stock" = 6, "cost" = 75),
		list("name" = "Pax Pill Bottle (PSYCHIATRIC)", "path" = /obj/item/storage/pill_bottle/paxpsych, "stock" = 2, "cost" = 100),
		list("name" = "Ephedrine Pill Bottle", "path" = /obj/item/storage/pill_bottle/ephedrine, "stock" = 4, "cost" = 45)
	)

	// Staff Equipment
	stock[CLINIC_CATEGORY_STAFF] = list(
		list("name" = "Prayer Beads", "path" = /obj/item/clothing/neck/vampire/prayerbeads, "stock" = 6, "cost" = 25),
		list("name" = "Cross Necklace", "path" = /obj/item/card/id/hunter, "stock" = 6, "cost" = 25),
		list("name" = "Surgical Apron", "path" = /obj/item/clothing/suit/apron/surgical, "stock" = 4, "cost" = 30),
		list("name" = "Pocket Protector", "path" = /obj/item/clothing/accessory/pocketprotector/full, "stock" = 4, "cost" = 15),
		list("name" = "EMT/Paramedic Jacket", "path" = /obj/item/clothing/suit/toggle/labcoat/paramedic, "stock" = 4, "cost" = 40),
		list("name" = "Scrubs, Blue", "path" = /obj/item/clothing/under/vampire/nurse, "stock" = 4, "cost" = 30),
		list("name" = "Scrubs, Black", "path" = /obj/item/clothing/under/vampire/nurse/nurseb, "stock" = 4, "cost" = 30),
		list("name" = "Scrubs, Cyan", "path" = /obj/item/clothing/under/vampire/nurse/nursec, "stock" = 4, "cost" = 30),
		list("name" = "Scrubs, Green", "path" = /obj/item/clothing/under/vampire/nurse/nurseg, "stock" = 4, "cost" = 30),
		list("name" = "Scrubs, Pink", "path" = /obj/item/clothing/under/vampire/nurse/nursep, "stock" = 4, "cost" = 30),
		list("name" = "Latex Gloves", "path" = /obj/item/clothing/gloves/vampire/latex, "stock" = 10, "cost" = 10),
		list("name" = "Defib Batteries", "path" = /obj/item/stock_parts/cell, "stock" = 6, "cost" = 35),
		list("name" = "Radio, Hospital", "path" = /obj/item/p25radio, "stock" = 4, "cost" = 40),
		list("name" = "Syringe", "path" = /obj/item/reagent_containers/syringe, "stock" = 10, "cost" = 5),
		list("name" = "Stethoscope", "path" = /obj/item/clothing/neck/stethoscope, "stock" = 10, "cost" = 20),
		list("name" = "Defibrillator, Compact", "path" = /obj/item/defibrillator/compact, "stock" = 6, "cost" = 90),
		list("name" = "Surgery Duffelbag", "path" = /obj/item/storage/backpack/duffelbag/med/surgery, "stock" = 6, "cost" = 80),
		list("name" = "Roller Bed", "path" = /obj/item/roller, "stock" = 10, "cost" = 30),
		list("name" = "Box of Body Bags", "path" = /obj/item/storage/box/bodybags, "stock" = 3, "cost" = 40),
		list("name" = "Radio, Dispatch Frequency", "path" = /obj/item/police_radio, "stock" = 4, "cost" = 50)
	)

	// Cleaning Supplies
	stock[CLINIC_CATEGORY_CLEANING] = list(
		list("name" = "Cleaner", "path" = /obj/item/reagent_containers/spray/cleaner, "stock" = 4, "cost" = 15)
	)

	// Office Supplies
	stock[CLINIC_CATEGORY_OFFICE] = list(
		list("name" = "Clipboard", "path" = /obj/item/clipboard, "stock" = 4, "cost" = 10),
		list("name" = "Pen", "path" = /obj/item/pen, "stock" = 10, "cost" = 5),
		list("name" = "Paper Stack", "path" = /obj/item/paper_bin, "stock" = 2, "cost" = 15)
	)

	return stock

// Helper to check if a job has sufficient access for a category
/proc/CLINIC_has_category_access(job, category)
	if(!GLOB.CLINIC_job_access[job] || !GLOB.CLINIC_category_access[category])
		return
	return GLOB.CLINIC_job_access[job] >= GLOB.CLINIC_category_access[category]
