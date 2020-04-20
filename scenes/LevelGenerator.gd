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
		2: [GOBLIN.rider,GOBLIN.rider]
	},{
		0: [GOBLIN.flyer],
		10: [GOBLIN.flyer],
		12: [GOBLIN.rider,GOBLIN.rider]
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
