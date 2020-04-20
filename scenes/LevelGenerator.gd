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
		12: [GOBLIN.bomb],
		16: "Look out, it's a bomber goblin!",
		17: 2, # bagpipes
		17.1: "You need to change you musical style againts those. Pick up the bagpipes using spacebar and hit my knights with them to pick up their shield.",
		20: [GOBLIN.bomb],
		30: [GOBLIN.bomb],
		40: [GOBLIN.normal],
		45: [GOBLIN.bomb],
		50: [GOBLIN.normal],
		60: [GOBLIN.normal]
	},{
		0: [GOBLIN.normal],
		5: [GOBLIN.bomb],
		10: [GOBLIN.bomb],
		20: [GOBLIN.normal],
		# TODO harp
		25: [GOBLIN.normal],
		30: [GOBLIN.normal],
		35: [GOBLIN.bomb],
		40: [GOBLIN.bomb],
		45: [GOBLIN.normal],
		50: [GOBLIN.bomb],
		60: [GOBLIN.bomb],
		65: [GOBLIN.bomb],
		70: [GOBLIN.normal],
		75: [GOBLIN.normal],
		90: [GOBLIN.bomb],
		95: [GOBLIN.normal],
		100: [GOBLIN.bomb],
		105: [GOBLIN.normal],
		110: [GOBLIN.normal],
	},{
		0: [GOBLIN.normal],
		10: [GOBLIN.bomb],
		15: [GOBLIN.normal],
		# TODO trumpet
		30: [GOBLIN.rider],
		40: [GOBLIN.normal],
		50: [GOBLIN.normal],
		60: [GOBLIN.rider],
		65: [GOBLIN.bomb],
		80: [GOBLIN.normal],
		90: [GOBLIN.rider],
		100: [GOBLIN.rider],
	},
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
