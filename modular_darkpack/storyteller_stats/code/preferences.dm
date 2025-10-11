/datum/preferences
	var/datum/storyteller_stats/storyteller_stat_holder = new /datum/storyteller_stats()

/datum/preferences/proc/add_virtue_stats()
	var/list/dat = list()
	if(pref_species.id == "kindred")
		dat += "<table align='center' width='100%'>"
		var/datum/st_stat/virtue_stat = storyteller_stat_holder.get_stat_datum(STAT_VIRTUE)
		dat += "<h1>[make_font_cool("Virtues")] - Points remaining: [virtue_stat.points]</h1>"
		dat += "<tr>"
		var/newvirtueline = 0 //Purely used just so it doesn't overflow from the amount.
		for(var/datum/st_stat/virtue/stat as anything in subtypesof(/datum/st_stat/virtue))
			dat += "<td>"
			dat += "<div title=\"[stat.description]\">[stat.name]: [storyteller_stat_holder.build_attribute_score(stat)] - [storyteller_stat_holder.get_stat(stat)] ([storyteller_stat_holder.get_stat(stat)])</div>"
			if(!slotlocked)
				dat += "<a href='byond://?_src_=prefs;preference=attributes;task=increase_stat;stat=[stat]'>+</a>"
				dat += "<a href='byond://?_src_=prefs;preference=attributes;task=decrease_stat;stat=[stat]'>-</a><br>"
			dat += "</td>"

			newvirtueline++
			if(newvirtueline == 4)
				dat += "</tr>"
				dat += "<tr>"
				newvirtueline = 0
		dat += "</tr>"
		dat += "</table>"
		return dat

	if(pref_species.id == "human" || pref_species.id == "ghoul")
		dat += "<table align='center' width='100%'>"
		var/datum/st_stat/virtue_stat = storyteller_stat_holder.get_stat_datum(STAT_VIRTUE)
		dat += "<h1>[make_font_cool("Virtues")] - Points remaining: [virtue_stat.points]</h1>"
		dat += "<tr>"
		var/newvirtueline = 0 //Purely used just so it doesn't overflow from the amount.
		var/list/virtues_list = list(STAT_SELF_CONTROL, STAT_CONSCIENCE, STAT_COURAGE)
		for(var/datum/st_stat/virtue/stat as anything in virtues_list)
			dat += "<td>"
			dat += "<div title=\"[stat.description]\">[stat.name]: [storyteller_stat_holder.build_attribute_score(stat)] - [storyteller_stat_holder.get_stat(stat)] ([storyteller_stat_holder.get_stat(stat)])</div>"
			if(!slotlocked)
				dat += "<a href='byond://?_src_=prefs;preference=attributes;task=increase_stat;stat=[stat]'>+</a>"
				dat += "<a href='byond://?_src_=prefs;preference=attributes;task=decrease_stat;stat=[stat]'>-</a><br>"
			dat += "</td>"

			newvirtueline++
			if(newvirtueline == 4)
				dat += "</tr>"
				dat += "<tr>"
				newvirtueline = 0
		dat += "</tr>"
		dat += "</table>"
		return dat
	return dat
