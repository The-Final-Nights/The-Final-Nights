
/// Logging for speech indicators.
/proc/log_subtle(text, list/data)
	GLOB.logger.Log(LOG_CATEGORY_GAME_SUBTLE, text, data)


/// Logging for speech indicators.
/proc/log_subtler(text, list/data)
	GLOB.logger.Log(LOG_CATEGORY_GAME_SUBTLER, text, data)
