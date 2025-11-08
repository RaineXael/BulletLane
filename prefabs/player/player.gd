class_name Player
extends CharacterBody2D

@onready var bullet_prefab = load("res://prefabs/player/bullet.tscn")
@onready var anim = $AnimatedSprite2D
const SPEED = 200.0
const FOCUS_SPEED = 80.0
const JUMP_VELOCITY = -400.0
var lives = 3

const DODGE_TIME = 0.07
const DODGE_COOLDOWN = 1.0
const DODGE_SPEED = 800.0
var prev_direction = 1.0
@export var bullet_speed = 300.0

var dodge_time = 0.0
var dodge_cooldown = 0.0
var dodging = false
var shot_timer = 0.0
@export var shot_time = 0.1
func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	if dodge_time > 0:
		dodge_time -= delta
	else:
		if dodging:
			dodging = false
			dodge_cooldown = DODGE_COOLDOWN
		
	if dodge_cooldown > 0:
		dodge_cooldown -= delta

	#print(dodging)

	if Input.is_action_pressed('dodge'):
		if not dodging and dodge_cooldown <= 0:
			dodging = true
			print('dodgeing')
			dodge_time = DODGE_TIME
	
		
	if Input.is_action_just_pressed('fire'):
		shot_timer = 0.0
		
	if Input.is_action_pressed("fire"):
		shot_timer -= delta
		if shot_timer <= 0:
			shot_timer = shot_time
			spawn_bullet_to_cursor()
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dodging:
		velocity.x = prev_direction * DODGE_SPEED
	else:
		
		var direction := Input.get_axis("left", "right")
		
			
		if direction:
			if Input.is_action_pressed('focus'):
				velocity.x = direction * FOCUS_SPEED
			else:
				velocity.x = direction * SPEED
			prev_direction = direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()
	
func on_hit_with_bullet():
	if not dodging:
		lives -= 1
		if lives <= 0:
			print('Your game is over!!! DIE!!!!!')
		
	print('The plkayer is fuckign dead!!!!! ')


func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area is Bullet:
		if area.type != 'player':
			on_hit_with_bullet()
func spawn_bullet_to_cursor():
	var bullet = bullet_prefab.instantiate()
	bullet.type = 'player'
	print(get_parent())
	get_parent().add_child(bullet)
	bullet.speed = bullet_speed
	bullet.global_position = global_position
	var dirvec = (get_mouse_world_pos()- global_position).normalized()
	
	bullet.angle = atan2(dirvec.y,dirvec.x)
	
func get_mouse_world_pos() -> Vector2:
	return get_viewport().get_mouse_position()
