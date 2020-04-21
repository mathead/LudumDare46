extends Node

var next_time = 0
var level = 0
var max_level = 0

enum GOBLIN{
	normal,
	rider,
	flyer,
	bomb
}

var levels = [
	{
		0: [GOBLIN.normal],
		5: [GOBLIN.normal],
		10: [GOBLIN.normal],
		15: [GOBLIN.normal],
		25: [GOBLIN.normal],
		35: [GOBLIN.bomb],
		39: "Look out, it's a bomber goblin!",
		40: 2, # bagpipes
		40.1: "You need to change you musical style againts those. Pick up the bagpipes using spacebar and hit my knights with them to use their shield.",
		50: [GOBLIN.bomb],
		65: [GOBLIN.normal],
		75: [GOBLIN.normal]
	},{
		0: [GOBLIN.normal],
		10: [GOBLIN.bomb],
		20: [GOBLIN.bomb],
		30: [GOBLIN.normal],
		32: 0, # harp
		32.1: "Use the harp to heal and revive fallen knights.",
		40: [GOBLIN.normal],
		50: [GOBLIN.normal],
		60: [GOBLIN.bomb],
		70: [GOBLIN.bomb],
		80: [GOBLIN.normal],
		90: [GOBLIN.bomb],
		100: [GOBLIN.bomb],
		110: [GOBLIN.bomb],
		120: [GOBLIN.normal],
		130: [GOBLIN.normal],
		140: [GOBLIN.bomb],
		150: [GOBLIN.normal],
		160: [GOBLIN.bomb],
		170: [GOBLIN.normal],
		180: [GOBLIN.normal]
	},{
		5: [GOBLIN.normal],
		10: [GOBLIN.normal],
		15: [GOBLIN.bomb],
		25: [GOBLIN.bomb],
		30: [GOBLIN.normal],
		40: [GOBLIN.bomb],
		45: [GOBLIN.bomb],
		55: [GOBLIN.bomb],
		65: [GOBLIN.normal],
		70: [GOBLIN.normal],
		80: [GOBLIN.bomb],
		85: [GOBLIN.normal],
		90: [GOBLIN.bomb],
		100: [GOBLIN.normal],
		111: [GOBLIN.normal]
	},{
		0: [GOBLIN.normal],
		5: [GOBLIN.bomb],
		15: [GOBLIN.normal],
		25: [GOBLIN.rider],
		27: 4, # trumpet
		27.1: "Use the trumpet against those fast riders.",
		40: [GOBLIN.normal],
		50: [GOBLIN.normal],
		65: [GOBLIN.rider],
		80: [GOBLIN.bomb],
		100: [GOBLIN.normal],
		115: [GOBLIN.rider],
		130: [GOBLIN.rider]
	},{
		0: [GOBLIN.normal],
		5: [GOBLIN.bomb],
		15: [GOBLIN.normal],
		25: [GOBLIN.rider],
		35: [GOBLIN.rider],
		40: [GOBLIN.normal],
		50: [GOBLIN.rider],
		60: [GOBLIN.bomb],
		70: [GOBLIN.normal],
		85: [GOBLIN.rider],
		95: [GOBLIN.rider],
		100: [GOBLIN.normal],
		110: [GOBLIN.rider],
		120: [GOBLIN.normal],
		130: [GOBLIN.normal],
		140: [GOBLIN.rider],
		150: [GOBLIN.bomb],
		160: [GOBLIN.normal],
		170: [GOBLIN.rider],
		180: [GOBLIN.rider]
	},{
		0: [GOBLIN.bomb],
		5: [GOBLIN.bomb],
		10: [GOBLIN.rider],
		20: [GOBLIN.rider],
		25: [GOBLIN.normal],
		35: [GOBLIN.normal],
		40: [GOBLIN.rider],
		50: [GOBLIN.bomb],
		55: [GOBLIN.normal],
		60: [GOBLIN.rider],
		70: [GOBLIN.rider],
		75: [GOBLIN.normal],
		90: [GOBLIN.rider],
		95: [GOBLIN.bomb],
		100: [GOBLIN.rider],
		110: [GOBLIN.normal],
		115: [GOBLIN.normal],
		125: [GOBLIN.rider],
		130: [GOBLIN.bomb],
		140: [GOBLIN.rider]
	},{
		0: [GOBLIN.flyer],
		5: [GOBLIN.flyer],
		7: 3, # lute
		7.1: "Play the lute to switch to bows.",
		10: [GOBLIN.rider],
		20: [GOBLIN.rider],
		25: [GOBLIN.flyer],
		35: [GOBLIN.normal],
		40: [GOBLIN.rider],
		50: [GOBLIN.normal],
		55: [GOBLIN.normal],
		60: [GOBLIN.flyer],
		70: [GOBLIN.rider],
		75: [GOBLIN.normal],
		90: [GOBLIN.rider],
		95: [GOBLIN.normal],
		100: [GOBLIN.rider],
		110: [GOBLIN.flyer],
		115: [GOBLIN.normal],
		125: [GOBLIN.rider],
		130: [GOBLIN.flyer],
		140: [GOBLIN.rider]
	}
]

func _ready():
	max_level = len(levels)
	next_time = _calc_next_event_time()

func get_level():
	if level >= max_level:
		return -1
	return level

func get_goblin_spawns(time):
	if level >= max_level:
		return []
		
	if time > next_time:
		var goblin_array = levels[level][next_time]
		levels[level].erase(next_time)
		next_time = _calc_next_event_time()
		return goblin_array
	return []

func _calc_next_event_time():
	if level >= max_level:
		return -1
	var keys = levels[level].keys()
	keys.sort()
	var ret = keys.front()
	if ret == null: 
		level += 1
		return _calc_next_event_time()
	return ret 
