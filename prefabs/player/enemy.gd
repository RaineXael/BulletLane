class_name Enemy
extends Node2D


@export var health = 10.0

var original_pos

var spawn_anim = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_pos = global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_anim < PI/2:
		spawn_anim += delta*2
		global_position = original_pos - Vector2(0,80*cos(spawn_anim))
	elif spawn_anim < 3*PI/2:
		spawn_anim += delta*12
		global_position = original_pos - Vector2(0,10*cos(spawn_anim))
		
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
