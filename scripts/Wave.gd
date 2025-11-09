class_name Wave
extends Node2D

var enemy_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_array = get_children()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
