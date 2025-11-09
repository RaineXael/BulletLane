class_name RegularBulletAttack
extends Attack

@onready var prefab = load("res://prefabs/player/bullet.tscn")

@export var angle = 0.0
@export var speed = 150.0

func spawn_attack(pos:Vector2):
	var a = prefab.instantiate()
	a.speed = speed
	a.angle = deg_to_rad(angle)
	a.type = 'enemy'
	
	print('super spawn the boolet!')
	a.global_position = pos
	get_node("/root/master_scene").add_child(a)
