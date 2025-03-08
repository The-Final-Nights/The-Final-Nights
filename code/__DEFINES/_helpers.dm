// Stuff that is relatively "core" and is used in other defines/helpers

//Returns the hex value of a decimal number
//len == length of returned string
#define num2hex(X, len) num2text(X, len, 16)

//Returns an integer given a hex input, supports negative values "-ff"
//skips preceding invalid characters
#define hex2num(X) text2num(X, 16)

#define span_notice(str) ("<span class='notice'>" + str + "</span>")
#define span_warning(str) ("<span class='warning'>" + str + "</span>")
// TFN EDIT START
#define span_danger(str) ("<span class='danger'>" + str + "</span>")
#define span_userdanger(str) ("<span class='userdanger'>" + str + "</span>")
#define span_nicegreen(str) ("<span class='nicegreen'>" + str + "</span>")
#define span_boldwarning(str) ("<span class='boldwarning'>" + str + "</span>")
#define span_emote(str) ("<span class='emote'>" + str + "</span>")
#define span_subtle(str) ("<span class='subtle'>" + str + "</span>")
#define span_subtler(str) ("<span class='subtler'>" + str + "</span>")
#define span_adminnotice(str) ("<span class='adminnotice'>" + str + "</span>")
// TFN EDIT END
