extends Node

# https://github.com/dolph/dictionary


const MIN_LENGTH_OF_WORDS = 4
const MAX_LENGTH_OF_WORDS = 4



# All of the available words, in sub arrays ordered by word length
var corpus: Array = []
# Subset of words currently being used by some UI node somewhere
var active_words: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_corpus()
	corpus.append([])
	corpus.append([])
	corpus.append([])
	corpus.append([])
	corpus.append([
		"boat", "word", "corn", "wrap", "need", "cans", "beep",
		"cram", "bark", "drum", "pink", "rake", "turn", "sort", "must", "bind", "quit", "ween",
		"drip", "soap", "soup", "reap", "yelp", "ouch", "yuck", "hugs", "duck", "stir", "pour", 
		"near", "from", "four", "grow", "line", "aqua", "able", "aces", "anew", "asks",
		"back", "band", "bask", "begs", "bias", "beta", "bill", "blot", "bomb", "boot", "born", "brew",
		"bulb", "buzz", "cafe", "cake", "cane", "cats", "dogs", "chad", "chew", "clan", "clap",
		"clip", "club", "cold", "cook", "conk", "coup", "cows", "crow", "dark", "deep", "demo", "deny",
		"desk", "dime", "dine", "disc", "doll", "draw", "dump", "dust", "eats", "eels", "emit", "eves",
		"eyes", "fact", "fair", "fare", "farm", "feat", "fist", "five", "flat", "flop", "flux", "foul",
		"fowl", "fret", "fuel", "gags", "gain", "gala", "gate", "gift", "give", "gist", "glad", "gods",
		"goes", "gold", "gram", "grew", "grid", "hair", "harp", "hash", "have", "hawk", "heat", "hero",
		"hill", "hint", "hole", "honk", "hose", "hour", "hung", "hurt", "idol", "inky", "jack", "jean",
		"join", "jump", "junk", "kelp", "kick", "kiln", "kiss", "knee", "knob", "know", "lace", "lads",
		"lady", "lame", "land", "lurk", "last", "lawn", "leaf", "leak", "lens", "lids", "lieu", "life",
		"lime", "lion", "lock", "look", "loop", "love", "luck", "lynx", "mace", "mail", "male", "mare",
		"mark", "math", "maul", "menu", "mine", "mitt", "moot", "nail", "name", "neck", "neon", "nose",
		"oats", "obey", "ones", "only", "onto", "oven", "pace", "pack", "papa", "past", "peck", "pens",
		"perm", "pile", "pill", "pity", "plea", "plug", "plum", "pond", "pray", "prey", "prop", "pure",
		"quiz", "race", "rage", "rain", "ream", "rear", "redo", "reed", "reef", "rein", "rely", "rent",
		"rest", "rift", "risk", "rock", "rook", "rope", "rule", "sage", "safe", "sail", "said", "salt", 
		"saws", "scab", "seas", "self", "ship", "shin", "sick", "sink", "slew", "slob", "soil", "soul",
		"sold", "sour", "stat", "stun", "suds", "swap", "swan", "tail", "take", "tank", "teal", "teen",
		"tent", "test", "text", "then", "tilt", "time", "toad", "toll", "tear", "tree", "trip", "twin",
		"urge", "user", "vain", "veil", "very", "vine", "wand", "wasp", "wavy", "west", "wink", "wish", 
		"yank", "year", "yoga", "yolk", "zeal", "zero", "zest", "zone", "zoom"])


func _load_corpus() -> void:
	# Open File
	
	# Add words to corpus
	pass


func lock_word(length: int) -> String:
	if length < MIN_LENGTH_OF_WORDS || length > MAX_LENGTH_OF_WORDS:
		return ""
	var word: String = ""
	while word == "":
		var options: Array = corpus[length]
		var chosen: String = options[randi() % options.size()]
		if chosen in active_words:
			continue
		active_words.append(chosen)
		word = chosen
	return word


func release_word(word: String) -> void:
	active_words.erase(word)

