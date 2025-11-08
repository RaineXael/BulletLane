class_name AttackPattern
extends Node
var timer:Timer
var attacks:Array
@export var time_until_next_attack = 1.0
@export var loop_count:= 1
var current_loop_count:int
signal on_pattern_complete

var parent_node:Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent_node = get_parent().parent_node
	attacks = get_children()
	timer = Timer.new()
	parent_node.add_child.call_deferred(timer)
	timer.one_shot = true
	timer.wait_time = time_until_next_attack
	timer.connect('timeout',on_timer_runout)
	
func enter_attack():
	current_loop_count = loop_count
	do_attacks()
	
func do_attacks():
	for attack in attacks:
		attack.spawn_attack(parent_node.global_position)
	timer.start()
#foreach pattern spawn it and wait accortdingly
#when done fire a custom signal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_timer_runout():
	print('the time, is , out, on the pa pap sap asp sap asp as')
	#go to the next pattern
	#timer.start()
	current_loop_count -= 1
	if current_loop_count == 0:
		on_pattern_complete.emit()
	else:
		do_attacks()
