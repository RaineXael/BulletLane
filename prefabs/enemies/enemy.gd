class_name Enemy
extends Node2D

@export_file("*.tscn") var pattern_manager_prefab:String

@export var health = 10.0

@export var moving_length = 0
@export var moving_speed = 100.0

@export_enum('bee','bubble') var anim_type = 'bee'

@onready var kill_sfx = $KillSFX

var original_pos
var spawned = false

@onready var spr = $AnimatedSprite2D
var active = true

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
	if anim_type == 'bee':
		spr.play('default')
	else:
		spr.play('bubble')
	
func on_spawn_timeout():
	spawned = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		if anim_type == 'bee':
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
	if area is Bullet and active:
		if area.type == 'player':
			take_damage(area.damage)
			area.queue_free()
			
func take_damage(dmg:float):
	health -= dmg
	if health <= 0:
		on_kill()
		
func on_kill():
	if anim_type == 'bee':
		kill_sfx.stream = preload("res://audio/kill_enemy.wav")
	elif anim_type == 'bubble':
		kill_sfx.stream = preload("res://audio/bubble_pop.wav")
	kill_sfx.play()
	player.add_score(point_worth)
	active = false
	var a = Timer.new()
	a.autostart = true
	a.one_shot = true
	a.connect('timeout', on_kill_anim_play)
	a.wait_time = 0.3
	add_child(a)
	spr.play("death")
	on_death.emit(self)
func on_kill_anim_play():
	
	queue_free()
signal on_death(ref:Enemy)


func _on_animated_sprite_2d_animation_finished() -> void:
	if spr.animation == 'bubblehit':
		spr.play('')
