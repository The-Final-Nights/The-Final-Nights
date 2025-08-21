/client/proc/redact_word()
	set category = "Admin.Events"
	set name = "Redact Word"
	set desc = "Redacts a word from everyone in the game, replacing it with noise."

	if(!check_rights(R_ADMIN))
		return

	var/redacted_word = SSredaction.add_word(usr)

	if(!redacted_word)
		return

	log_admin("[key_name(usr)] redacted the word: [redacted_word]")
	message_admins("[key_name_admin(usr)] redacted the word: [redacted_word]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Redacted the word: [redacted_word]") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/allow_word()
	set category = "Admin.Events"
	set name = "Allow Word"
	set desc = "Allows a word to be spoken by everyone in the game."

	if(!check_rights(R_ADMIN))
		return

	if(!length(SSredaction.redacted_words))
		return

	var/allowed_word = SSredaction.remove_word(usr)

	log_admin("[key_name(usr)] allowed the word: [allowed_word]")
	message_admins("[key_name_admin(usr)] allowed the word: [allowed_word]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Allowed the word: [allowed_word]") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
