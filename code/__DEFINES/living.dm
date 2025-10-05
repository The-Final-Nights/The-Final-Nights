// living_flags
/// Simple mob trait, indicating it may follow continuous move actions controlled by code instead of by user input.
#define MOVES_ON_ITS_OWN (1<<0)

/// Getter for a mob/living's lying angle, otherwise protected
#define GET_LYING_ANGLE(mob) (UNLINT(mob.lying_angle))
