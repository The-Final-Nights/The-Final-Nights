#define CABLE_LAYER_1		1
#define CABLE_LAYER_2		2
#define CABLE_LAYER_3		4

#define MACHINERY_LAYER_1	1

#define SOLAR_TRACK_OFF     0
#define SOLAR_TRACK_TIMED   1
#define SOLAR_TRACK_AUTO    2


///The watt is the standard unit of power for this codebase. Do not change this.
#define WATT 1
///The joule is the standard unit of energy for this codebase. Do not change this.
#define JOULE 1
///The watt is the standard unit of power for this codebase. You can use this with other defines to clarify that it will be multiplied by time.
#define WATTS * WATT
///The joule is the standard unit of energy for this codebase. You can use this with other defines to clarify that it will not be multiplied by time.
#define JOULES * JOULE
