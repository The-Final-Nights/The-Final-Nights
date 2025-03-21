/datum/job
	var/list/alt_titles = list()

/datum/job/vamp/citizen
	alt_titles = list(
		"Private Investigator",
		"Private Security",
		"Tourist",
		"Visitor",
		"Entertainer",
		"Entrepreneur",
		"Contractor",
		"Fixer",
		"Lawyer",
		"Attorney",
		"Paralegal",
	)

/datum/job/vamp/vdoctor
	alt_titles = list(
		"Medical Student",
		"Intern",
		"Nurse",
		"Resident",
		"General Practitioner",
		"Surgeon",
		"Physician",
		"Paramedic",
		"EMT",
	)

/datum/job/vamp/police_officer
	alt_titles = list(
		"Police Cadet",
		"Senior Police Officer",
	)

/datum/job/vamp/police_sergeant
	alt_titles = list(
		"Police Supervisor",
		"Training Officer",
		"Detective",
	)

/datum/job/vamp/priest
	alt_titles = list(
		"Imam",
		"Monk",
		"Reverend",
		"Preacher",
		"Rabbi",
	)
