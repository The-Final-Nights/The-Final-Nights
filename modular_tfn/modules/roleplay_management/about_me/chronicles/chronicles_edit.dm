// ==============================================================================
// CHRONICLE — EDIT (chronicle_edit.dm)
// Persistence-only mutations. Sanitize inputs at UI boundaries.
// ==============================================================================

/datum/chronicle/proc/set_title(t)
	title = "[t]"
	touch()

/datum/chronicle/proc/set_desc(d)
	desc = "[d]"
	touch()

/datum/chronicle/proc/set_status(s)
	status = "[s]"
	touch()

/datum/chronicle/proc/add_tag(tag)
	if (!tag) return
	//if (!(tag in tags)) tags += tag
	touch()

/datum/chronicle/proc/remove_tag(tag)
	//tags -= tag
	touch()

/datum/chronicle/proc/remove_entry(memory_id)
	if (!memory_id) return
	//entries -= memory_id
	touch()
