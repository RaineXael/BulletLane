class_name WaveManager
extends Node
var current_wave_index = 0	
var current_wave_node = null
@export var waves : Array[String]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	begin_game()

func begin_game():
	current_wave_node = load(waves[current_wave_index]).instantiate()
	current_wave_node.connect('on_wave_complete', next_wave)
	get_parent().add_child.call_deferred(current_wave_node)
func next_wave():
	current_wave_index += 1
	if current_wave_index > waves.size()-1:
		current_wave_index = 0
	current_wave_node.queue_free()
	begin_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
