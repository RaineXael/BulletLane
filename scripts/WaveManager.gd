class_name WaveManager
extends Node
@export var starting_wave = 0
var current_wave_index = 0	
var current_wave_node = null
var inter_wave_timer:Timer
@export var waves : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inter_wave_timer = Timer.new()
	inter_wave_timer.wait_time = 0.5
	inter_wave_timer.one_shot = true
	inter_wave_timer.connect('timeout', begin_game)
	add_child(inter_wave_timer)
	
	#begin_game()

func begin_game():
	
	current_wave_node = load(waves[current_wave_index]).instantiate()
	current_wave_node.connect('on_wave_complete', next_wave)
	get_parent().add_child.call_deferred(current_wave_node)
func next_wave():
	current_wave_index += 1
	if current_wave_index > waves.size()-1:
		current_wave_index = 0
	inter_wave_timer.start()


func _on_button_pressed() -> void:
	begin_game()
	$"../CanvasLayer".queue_free()
	$"../mus".play()
