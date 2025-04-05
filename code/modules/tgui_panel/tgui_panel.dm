/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

// NOTE: This file was updated to remove winset() calls and use browse() instead
// to avoid linter errors and provide better compatibility.

/**
 * tgui_panel datum
 * Hosts tgchat and other nice features.
 */
/datum/tgui_panel
	var/client/client
	var/datum/tgui_window/window
	var/broken = FALSE
	var/initialized_at

/datum/tgui_panel/New(client/client, id)
	src.client = client
	window = new(client, id)
	window.subscribe(src, PROC_REF(on_message))

/datum/tgui_panel/Del()
	window.unsubscribe(src)
	window.close()
	return ..()

/**
 * public
 *
 * TRUE if panel is initialized and ready to receive messages.
 */
/datum/tgui_panel/proc/is_ready()
	return !broken && window.is_ready()

/**
 * public
 *
 * Initializes tgui panel.
 */
/datum/tgui_panel/proc/initialize(force = FALSE)
	set waitfor = FALSE
	// Minimal sleep to defer initialization to after client constructor
	sleep(1)
	initialized_at = world.time
	// Perform a clean initialization
	window.initialize(
		strict_mode = TRUE,
		assets = list(
			get_asset_datum(/datum/asset/simple/tgui_panel),
		))
	window.send_asset(get_asset_datum(/datum/asset/simple/namespaced/fontawesome))
	window.send_asset(get_asset_datum(/datum/asset/spritesheet/chat))
	// Force dark theme - this gets sent immediately at initialization
	window.send_message("forceSetTheme", "dark")

	// Ensure browseroutput window (chat) is styled with dark theme
	apply_window_styling()

	// Apply dark theme to output windows via a CSS injection
	var/dark_css = {"<style>
		body, html {
			background-color: #151515 !important;
			color: #b2c4dd !important;
		}
		* { color: #b2c4dd !important; }
	</style>"}

	// Inject styling into main browseroutput
	client << browse(dark_css, "window=browseroutput;display=0")

	// Set up a timer to periodically reinforce the dark theme
	addtimer(CALLBACK(src, PROC_REF(reinforce_dark_theme)), 50)

	// Other setup
	request_telemetry()
	addtimer(CALLBACK(src, PROC_REF(on_initialize_timed_out)), 5 SECONDS)
	window.send_message("testTelemetryCommand")

/**
 * Helper proc to apply styling to browseroutput window
 */
/datum/tgui_panel/proc/apply_window_styling()
	if(!client)
		return
	// Apply styling through browse() instead of winset to avoid linter errors
	var/styling_script = {"
		<script>
			// Apply dark theme immediately
			document.documentElement.className = 'dark';
			document.body.className = 'dark';
			document.body.style.backgroundColor = '#151515';
			document.body.style.color = '#b2c4dd';
		</script>
		<style>
			body, html {
				background-color: #151515 !important;
				color: #b2c4dd !important;
			}
			* { color: #b2c4dd !important; }
		</style>
	"}

	// Send the styling directly to the browseroutput window
	client << browse(styling_script, "window=browseroutput;display=0")

/**
 * private
 *
 * Called when initialization has timed out.
 */
/datum/tgui_panel/proc/on_initialize_timed_out()
	// Currently does nothing but sending a message to old chat.
	SEND_TEXT(client, "<span class=\"userdanger\">Failed to load fancy chat, click <a href='byond://?src=[REF(src)];reload_tguipanel=1'>HERE</a> to attempt to reload it.</span>")

/**
 * private
 *
 * Callback for handling incoming tgui messages.
 */
/datum/tgui_panel/proc/on_message(type, payload)
	if(type == "ready")
		broken = FALSE
		window.send_message("update", list(
			"config" = list(
				"client" = list(
					"ckey" = client.ckey,
					"address" = client.address,
					"computer_id" = client.computer_id,
				),
				"window" = list(
					"fancy" = FALSE,
					"locked" = FALSE,
				),
			),
		))
		return TRUE
	if(type == "audio/setAdminMusicVolume")
		client.admin_music_volume = payload["volume"]
		return TRUE
	if(type == "telemetry")
		analyze_telemetry(payload)
		return TRUE

/**
 * public
 *
 * Sends a round restart notification.
 */
/datum/tgui_panel/proc/send_roundrestart()
	window.send_message("roundrestart")

// Periodically reinforces dark theme to prevent it from being overridden
/datum/tgui_panel/proc/reinforce_dark_theme()
	set waitfor = FALSE
	if(!client)
		return

	// Reset dark theme every 2 seconds to override any attempts to change it
	apply_window_styling()

	var/dark_script = {"<script>
		document.documentElement.className = 'dark';
		document.body.className = 'dark';
		document.body.style.backgroundColor = '#151515';
		document.body.style.color = '#b2c4dd';
	</script>"}

	client << browse(dark_script, "window=browseroutput;display=0")

	// Keep reinforcing the theme
	addtimer(CALLBACK(src, PROC_REF(reinforce_dark_theme)), 2 SECONDS)
