extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
const CATCH_CHANCE = 20




var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_fishing = false
var can_fish = false
var facing_left = false
var has_hooked = false


var fish_animation_finished = false
var hook_animation_finished = false


@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_water = $RayCastWater
@onready var ray_cast_ground = $RayCastGround
@onready var player = $"."
@onready var fishing_timer = $"Fishing Timer"
@onready var catch_timer = $"Catch Timer"
@onready var hooked_fish = $HookedFish


const FISH = preload("res://scenes/fish.tscn")

func _ready():
	pass

func _process(delta):
	checkIfCanFish()
	
	if can_fish: 
		if Input.is_action_just_pressed("fish"):
			if is_fishing:
				fishing_timer.stop()
				animated_sprite.play("hook")
				
				if has_hooked:
					catchFish()
			else:
				fishing_timer.start()
				animated_sprite.play("fish")
				is_fishing = true
				
			fish_animation_finished = false
		elif is_fishing and fish_animation_finished:
			animated_sprite.play("fishing")
	
func _physics_process(delta):
	
	if is_fishing:
		return
	
	addGravity(delta)
	handleJump()

	var direction = Input.get_axis("move_left", "move_right")

	handleAnimations(direction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#Aux Functions

func addGravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handleJump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handleAnimations(direction):
	if is_fishing:
		return
		
	if direction > 0:
		animated_sprite.play("walk")
		if facing_left:
			facing_left = false
			scale.x *= -1	
	elif direction < 0:
		animated_sprite.play("walk")
		if not facing_left:
			scale.x *= -1
			facing_left = true
	else:
		animated_sprite.play("idle")
	
func checkIfCanFish():
	if ray_cast_water.is_colliding() and not ray_cast_ground.is_colliding() and not has_node("Fish"):
		can_fish = true
	else:
		can_fish = false

func catchFish():
	
	var fishCatched = FISH.instantiate()
	fishCatched.position = Vector2(25,20)
	
	self.add_child(fishCatched)
	
	

	

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "fish":
		fish_animation_finished = true
	elif animated_sprite.animation == "hook":
		hook_animation_finished = true
		is_fishing = false

func _on_catch_timer_timeout():
	has_hooked = false

func _on_fishing_timer_timeout():
	if not is_fishing:return
	
	var rand = randi() % 100
	if rand < CATCH_CHANCE:
		has_hooked = true
		hooked_fish.play()
		catch_timer.start()
	else: print("Não fisgou!")

