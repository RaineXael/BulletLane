class_name AttackPatternManager
extends Node

@export var parent_node:Node2D

var current_pattern = 0
var timer:Timer

@export var initial_spawn = 2.0

var patterns: = []
var first_timer_done = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	patterns = get_children()
	for child in patterns:
		child.parent_node = parent_node
		child.connect('on_pattern_complete',on_pattern_complete)
		#attatch a 'on-complete-pattern' signal to a fn
	
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = initial_spawn
	timer.connect('timeout',on_timer_runout)
	add_child(timer)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_timer_runout():
	print('the time, is , out,')
	#go to the next pattern
	current_pattern += 1
	if current_pattern > patterns.size() - 1:
		current_pattern = 0
	patterns[current_pattern].enter_attack()

func on_pattern_complete():
	timer.time = patterns[current_pattern].time_until_next_attack
	timer.start()
