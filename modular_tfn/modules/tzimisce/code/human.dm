//This is an awful way of doing things, and I hate it, but it won't get merged otherwise. Abandon all hope, all ye who enter here.
/mob/living/carbon/human/proc/revert_to_cursed_form()
	src.set_body_sprite()
	to_chat(src, span_warning("Your cursed appearance reasserts itself!"))
