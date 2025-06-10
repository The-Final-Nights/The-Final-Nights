
/mob/living/carbon/human/verb/set_custom_examine_text()
	set name = "Set Custom Examine Text"
	set category = "IC"
	set desc = "Set a custom examine message to what your character is doing at the moment."
    
	var/new_text = tgui_input_text(src, "Set your new custom examine text.", "Examine Text", null, MAX_MESSAGE_LEN, TRUE)
    
	custom_examine_message = new_text
