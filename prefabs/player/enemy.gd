class_name Enemy
extends Node2D

@export_file("*.tscn") var pattern_manager_prefab:String

@export var health = 10.0

var original_pos
var spawned = false

@onready var spr = $AnimatedSprite2D

var spawn_anim = 0.0

@export var point_worth = 100
var appear_timer:Timer
#probably really bad but idc
@onready var player:Player = get_node('/root/master_scene/Player')
const RANDOM_APPIRATION_FACTOR = 0.3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	appear_timer = Timer.new()
	appear_timer.wait_time = randf_range(0.001, RANDOM_APPIRATION_FACTOR)
	appear_timer.one_shot = true
	appear_timer.connect('timeout', on_spawn_timeout)
	add_child(appear_timer)
	var loaded_path = load(pattern_manager_prefab).instantiate()
	loaded_path.parent_node = self
	add_child(loaded_path)
	original_pos = global_position
	global_position.y = -999
	appear_timer.start()
func on_spawn_timeout():
	spawned = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	spr.flip_h = player.global_position.x - global_position.x <= 0
	if spawned:
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
	player.add_score(point_worth)
	queue_free()
