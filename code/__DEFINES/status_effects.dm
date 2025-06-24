///if it allows multiple instances of the effect
#define STATUS_EFFECT_MULTIPLE 0
///if it allows only one, preventing new instances
#define STATUS_EFFECT_UNIQUE 1
///if it allows only one, but new instances replace
#define STATUS_EFFECT_REPLACE 2
/// if it only allows one, and new instances just instead refresh the timer
#define STATUS_EFFECT_REFRESH 3

/// Use in status effect "duration" to make it last forever
#define STATUS_EFFECT_PERMANENT -1
/// Use in status effect "tick_interval" to prevent it from calling tick()
#define STATUS_EFFECT_NO_TICK -1
/// Use in status effect "tick_interval" to guarantee that tick() gets called on every process()
#define STATUS_EFFECT_AUTO_TICK 0

/// Indicates this status effect is an abstract type, ie not instantiated
/// Doesn't actually do anything in practice, primarily just a marker / used in unit tests,
/// so don't worry if your abstract status effect doesn't actually set this
#define STATUS_EFFECT_ID_ABSTRACT "abstract"

///Processing flags - used to define the speed at which the status will work
/// This is fast - 0.2s between ticks (I believe!)
#define STATUS_EFFECT_FAST_PROCESS 0
/// This is slower and better for more intensive status effects - 1s between ticks
#define STATUS_EFFECT_NORMAL_PROCESS 1
/// Similar speed to STATUS_EFFECT_FAST_PROCESS, but uses a high priority subsystem (SSpriority_effects)
#define STATUS_EFFECT_PRIORITY 2


//several flags for the Necropolis curse status effect
///makes the edges of the target's screen obscured
#define CURSE_BLINDING (1<<0)
///spawns creatures that attack the target only
#define CURSE_SPAWNING (1<<1)
///causes gradual damage
#define CURSE_WASTING (1<<2)
///hands reach out from the sides of the screen, doing damage and stunning if they hit the target
#define CURSE_GRASPING (1<<3)

// Grouped effect sources, see also code/__DEFINES/traits.dm

#define STASIS_MACHINE_EFFECT "stasis_machine"

#define STASIS_ASCENSION_EFFECT "heretic_ascension"
