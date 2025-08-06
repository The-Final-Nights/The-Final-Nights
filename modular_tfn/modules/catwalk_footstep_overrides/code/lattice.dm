/obj/structure/lattice/catwalk/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/footstep_override, footstep = FOOTSTEP_CATWALK)

/obj/structure/lattice/grate/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/footstep_override, footstep = FOOTSTEP_CATWALK)