https://github.com/The-Final-Nights/The-Final-Nights/pull/687

## Storyteller stats

Module ID: STORYTELLER_STATS <!-- Uppercase, UNDERSCORE_CONNECTED name of your module, that you use to mark files. This is so people can case-sensitive search for your edits, if any. -->

### Description:

Not to be confused with TG traits; A stat system based heavily on WoD.

https://hackmd.io/-dkDQrjuTLOImoTIHr_RBA

<!-- Here, try to describe what your PR does, what features it provides and any other directly useful information. -->

### TG Proc/File Changes:

- [code/modules/mob/living/living.dm](/code/modules/mob/living/living.dm):
	- `/mob/living/Initialize(mapload)`
<!-- If you edited any core procs, you should list them here. You should specify the files and procs you changed.
E.g:
- `code/modules/mob/living.dm`: `proc/overriden_proc`, `var/overriden_var`
  -->

### Modular Overrides:

- [modular_darkpack/master_files/code/modules/mob/living/living_defines.dm](/modular_darkpack/master_files/code/modules/mob/living/living_defines.dm): `var/datum/storyteller_stats/storyteller_stat_holder`
- [modular_darkpack/master_files/code/modules/mob/living/living.dm](/modular_darkpack/master_files/code/modules/mob/living/living.dm): `storyteller_stat_holder = new()`

### Defines:

- [code/\_\_DEFINES/~darkpack/storyteller_stats.dm](/code/__DEFINES/~darkpack/storyteller_stats.dm):
	- `STAT_###` Im not going to list all of them, but one for every trait following this format.

### Included files that are not contained in this module:

- [code/__DEFINES/~darkpack/storyteller_stats.dm](code/__DEFINES/~darkpack/storyteller_stats.dm)
<!-- Likewise, be it a non-modular file or a modular one that's not contained within the folder belonging to this specific module, it should be mentioned here. Good examples are icons or sounds that are used between multiple modules, or other such edge-cases. -->

### Credits:

<!-- Here go the credits to you, dear coder, and in case of collaborative work or ports, credits to the original source of the code. -->
