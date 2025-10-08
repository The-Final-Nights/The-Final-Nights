Motorcycles For TFN

Module ID:
motorcycle

Description:
This creates motorcycles for TFN, using vamp cars code as its base.

TG Proc/File Changes:
Overrides slightly; /mob/living/carbon/human/MouseDrop(atom/over_object)
Adds if(istype(over_object, /obj/vehicle/ridden/motorcycle) && get_dist(src, over_object) < 2) logic to MouseDrops.

Modular Overrides:
N/A

Defines:
N/A

Included files that are not contained in this module:
N/A

Credits: MichaelEUkari - (Christopher D. Adams)
