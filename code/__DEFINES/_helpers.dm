// Stuff that is relatively "core" and is used in other defines/helpers

/**
 * The game's world.icon_size. \
 * Ideally divisible by 16. \
 * Ideally a number, but it
 * can be a string ("32x32"), so more exotic coders
 * will be sad if you use this in math.
 */
#define ICON_SIZE_ALL 32
/// The X/Width dimension of ICON_SIZE. This will more than likely be the bigger axis.
#define ICON_SIZE_X 32
/// The Y/Height dimension of ICON_SIZE. This will more than likely be the smaller axis.
#define ICON_SIZE_Y 32

//Returns the hex value of a decimal number
//len == length of returned string
#define num2hex(X, len) num2text(X, len, 16)

//Returns an integer given a hex input, supports negative values "-ff"
//skips preceding invalid characters
#define hex2num(X) text2num(X, 16)

#define span_notice(str) ("<span class='notice'>" + str + "</span>")
#define span_warning(str) ("<span class='warning'>" + str + "</span>")
#define span_bold(str) ("<span class='bold'>" + str + "</span>")
// TFN EDIT START
#define span_userdanger(str) ("<span class='userdanger'>" + str + "</span>")
#define span_nicegreen(str) ("<span class='nicegreen'>" + str + "</span>")
#define span_boldwarning(str) ("<span class='boldwarning'>" + str + "</span>")
#define span_emote(str) ("<span class='emote'>" + str + "</span>")
#define span_subtle(str) ("<span class='subtle'>" + str + "</span>")
#define span_subtler(str) ("<span class='subtler'>" + str + "</span>")
#define span_adminnotice(str) ("<span class='adminnotice'>" + str + "</span>")
// TFN EDIT END
#define span_danger(str) ("<span class='danger'>" + str + "</span>")
#define span_alert(str) ("<span class='alert'>" + str + "</span>")
#define span_hear(str) ("<span class='hear'>" + str + "</span>")
