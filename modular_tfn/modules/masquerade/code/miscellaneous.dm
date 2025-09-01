/proc/CheckZoneMasquerade(mob/target)
	if(istype(get_area(target), /area/vtm))
		var/area/vtm/V = get_area(target)
		if(V.zone_type != "masquerade")
			return FALSE
		else
			return TRUE
