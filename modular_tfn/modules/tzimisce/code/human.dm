//Not a fan of this approach, but I've been told it won't get merged unless it's done like this.
/mob/living/carbon/human/proc/revert_to_cursed_form()
	set_body_sprite()
	to_chat(src, span_warning("Your cursed appearance reasserts itself!"))
