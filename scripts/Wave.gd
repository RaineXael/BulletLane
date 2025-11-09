class_name Wave
extends Node2D

var enemy_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_array = get_children()
	for en:Enemy in enemy_array:
		en.connect('on_death',on_enemy_died)

func on_enemy_died(ref:Enemy):
	enemy_array.erase(ref)
var wave_complete_notified = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_array.size() <= 0 and not wave_complete_notified:
		on_wave_complete.emit()
		wave_complete_notified = true
signal on_wave_complete
