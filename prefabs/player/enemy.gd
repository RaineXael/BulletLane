class_name Enemy
extends Node2D


@export var health = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hitbox_area_entered(area: Area2D) -> void:
	print(area)
	if area is Bullet:
		if area.type == 'player':
			take_damage(area.damage)
			area.queue_free()
			
func take_damage(dmg:float):
	health -= dmg
	if health <= 0:
		on_kill()
		
func on_kill():
	queue_free()
