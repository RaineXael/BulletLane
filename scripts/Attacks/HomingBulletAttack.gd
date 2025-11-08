class_name HomingBulletAttack
extends Attack

@export var predict_player := false
@export var angle_deviance = 0.0
@export var speed = 150.0

@onready var player = get_node("/root/master_scene/Player")

@onready var prefab = load("res://prefabs/player/bullet.tscn")

func spawn_attack(pos:Vector2):
	var a = prefab.instantiate()
	a.speed = speed
	
	a.type = 'enemy'
	get_node("/root/master_scene").add_child(a)
	print('super spawn the boolet!')
	a.global_position = pos
	
	if predict_player:
		pass
	var diff = player.global_position - pos
	a.angle = atan2(diff.y, diff.x) + deg_to_rad(angle_deviance)
	
	#get the position of the player and aim
	#towards em with some atan bullshit
	#if tracking is enabled, add movement to that
	#(pos + speed*dir*dist or somewhatever the heck)
