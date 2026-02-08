/**
 * Web based Newspapers hosted at https://thefinalnights.com/newspaper/
 * Designed to replace physical newspapers in TFN.
 */
/obj/item/newspaper
	desc = "An issue of The San Francisco Chronicle."
	var/datum/tgui_window/newspaper

/obj/item/newspaper/attack_self(mob/living/user)
	if(newspaper)
		newspaper.close()
	var/list/verbs = list("skimming through", "reading", "browsing", "looking over", "flipping through")
	to_chat(user, span_notice("You start [verbs[rand(1, length(verbs))]] the newspaper..."))
	if(!do_after(usr, 3 SECONDS))
		return
	newspaper = new(user.client, "newspaper")
	newspaper.initialize(inline_html = "<div class='container'><iframe src='https://thefinalnights.com/newspaper/' width='100%' height='100%' frameborder='0'></iframe></div>",
	inline_css = "html, body {width: 100%;height: 100%;margin: 0;padding: 0;overflow: hidden;} .container {width: 100%;height: 100%;display: flex;justify-content: center;align-items: center;} iframe {width: 100%;height: 100%;}"
	)
	winset(user.client, "newspaper", "size=1200x900;icon=icons/obj/service/bureaucracy.dmi;icon_state=newspaper")
