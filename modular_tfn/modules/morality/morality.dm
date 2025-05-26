/datum/morality
	var/name = ""
	var/desc = ""
	/// Humanity or Enlightenment
	var/alignment
	/// The bearing of the path's ethos
	var/bearing
	/// The current dot score of the path
	var/score = 7

/datum/morality/humanity
	name = "Humanity"
	desc = "Humanity is a measure of how closely a vampire clings to the morality and values of mortal life, and consequently how well they are able to resist the urges of the Beast."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_MUNDANE

/datum/morality/power
	name = "Path of Power and the Inner Voice"
	desc = "The Path of Power and the Inner Voice is a Path of Enlightenment that controls the Beast through rigorous determination and the amassing of worldly power. Adherents are called Unifiers."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_COMMAND

/datum/morality/heaven
	name = "Path of Heaven"
	desc = "Followers of Via Caeli attempt to control their Beast through religious devotion. They are frequently referred to as Noddists or the Faithful."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_HOLINESS

/datum/morality/metamorphosis
	name = "Path of Metamorphosis"
	desc = "The Path of Metamorphosis is a Path of Enlightenment that controls the Beast by studying its limits and the limits of vampirism in general. The Path is the result of the earlier Road of Metamorphosis and it is practiced mostly by the Tzimisce clan."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_INHUMANITY

/datum/morality/assamite
	name = "Path of Blood"
	desc = "The Path of Blood is a Path of Enlightenment common among the Assamites. Its followers fight the Beast with rigorous devotion to the cause of Haqim. Adherents are called Dervishes or Assassins."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_RESOLVE

/datum/morality/hive
	name = "Path of the Hive"
	desc = "Via Hyron, more commonly called Road of the Hive or Path of the Hive, is a minor Road that is followed almost exclusively by the Baali. Adherents are called Abelenes."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_JUSTICE

/datum/morality/kings
	name = "Road of Kings"
	desc = "Via Regalis, commonly called the Road of Kings. Followers of Via Regalis control their Beast by ruling over others. Mortals are inferior, promises will be fulfilled, and power is everything. Those who follow the Road of Kings are known as Scions."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_COMMAND

/datum/morality/heart
	name = "Path of the Scorched Heart"
	desc = "The Path of the Scorched Heart, originally called the Path of Rathmonicus, is an ancient Path of Enlightenment that originates with the True Brujah. Based on the Book of the Empty Heart by Rathmonicus, it was first disseminated among a few Kindred in the Catholic Church; its scriptures were later reunited and compiled by the True Black Hand. The Path of the Scorched Heart controls the Beast by systematically eradicating every emotion within the vampire's heart. The Path is especially favored among the True Brujah, who already cultivate few emotions. Adherents are called the Unforgiving."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_INTELLECT

/datum/morality/typhon
	name = "Path of Typhon"
	desc = "The Path of Typhon is a Path of Enlightenment that draws heavily on Setite doctrine and the religion around their Antediluvian. Adherents are called Theophidians and Typhonists. Outsiders call them Corruptors."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_DEVOTION

/datum/morality/bones
	name = "Path of Bones"
	desc = "The Path of Bones is a Path of Enlightenment that suppresses the Beast by studying the true nature of death and its relationships with other states of existence. Adherents are called Gravediggers."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_SILENCE

/datum/morality/night
	name = "Road of Night"
	desc = "Via Noctis, commonly called the Road of Night. The Redeemers feel the weight of Caine's curse and their own damnation, even more so than those who follow Via Caeli. Also like the Noddists, the Redeemers seek redemption and forgiveness, and to earn it requires suffering and purification. However, instead of the fairly benign ways of the Noddists, the Redeemers actively go about the world of man, punishing and killing mortal sinners. Some followers of Via Noctis offer penance for lesser deeds, and still others will Embrace irredeemable mortals to help them in their punishment. They also target Cainites who would tempt mortals into corruption, outstanding examples being the Followers of Set and the Baali."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_GUILT

/datum/morality/honor
	name = "Path of Honorable Accord"
	desc = "The Path of Honorable Accord is a Path of Enlightenment that harnesses the Beast through the rigorous practice of honorable and chivalrous behavior. Adherents are called Knights, Patriots, or Canonici."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_DEVOTION

/datum/morality/beast
	name = "Path of the Beast"
	desc = "The Path of the Beast is a Path of Enlightenment practiced especially by members of Clan Gangrel. It controls the Beast by accepting its urges as natural and accepting their role as a hunter among hunters. Adherents are called Bestials or Beasts."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_MENACE

/datum/morality/samiel
	name = "Code of Samiel"
	desc = "The Code of Samiel is a doctrine that formalized the tenets of the Warrior Salubri and of the Path of Retribution. It was designed by Saulot's greatest childe warrior, Samiel himself. Adherents swear to bring retribution to all manner of evil, chief among which are Infernalists, Demons and the Followers of Set. Vengeance, vigilance and righteousness are all held as core virtues."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_JUSTICE //I have no idea what this actually does
