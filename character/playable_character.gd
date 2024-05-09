extends CharacterBody2D


const speed = 400
const acceleration = 8

var key_is_pressed = false
var key_x_is_pressed = false
var key_y_is_pressed = false

const JUMP_VELOCITY = -400.0
@onready var character_sprite = $CharacterSprite


var starting_run = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#print(delta)
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
	#print(velocity.x)
	if (velocity.x > 1):
		if(!key_x_is_pressed and !key_y_is_pressed):
			character_sprite.play("forward_decelerate")
	elif (velocity.x < -1):
		if(!key_x_is_pressed and !key_y_is_pressed):
			character_sprite.play("decelerate")
	elif (velocity.y > 1):
		if(!key_x_is_pressed and !key_y_is_pressed):
			character_sprite.play("decelerate")
	elif (velocity.y < -1):
		if(!key_x_is_pressed and !key_y_is_pressed):
			character_sprite.play("decelerate")
	else:
		if(!key_x_is_pressed and !key_y_is_pressed):
			character_sprite.play("idle")
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	
	if (Input.is_action_pressed("ui_right")):
		key_x_is_pressed = true
		if velocity.x < 0: velocity.x = 0
		character_sprite.play("move_forward")
		velocity.x = min(velocity.x + acceleration, speed)
	elif (Input.is_action_pressed("ui_left")):
		key_x_is_pressed = true
		if velocity.x > 0: velocity.x = 0
		character_sprite.play("move_backward")
		velocity.x = max(velocity.x - acceleration, -speed)
	else:
		key_x_is_pressed = false
		velocity.x = lerp(velocity.x,0.0,0.2)
	
	
	if (Input.is_action_pressed("ui_up")):
		key_y_is_pressed = true
		if(!key_x_is_pressed):
			character_sprite.play("move_up")
		velocity.y = max(velocity.y - acceleration, -speed)
	elif (Input.is_action_pressed("ui_down")):
		key_y_is_pressed = true
		if(!key_x_is_pressed):
			character_sprite.play("move_down")
		velocity.y = min(velocity.y + acceleration, speed)
	else:
		key_y_is_pressed = false
		velocity.y = lerp(velocity.y,0.0,0.2)
	
	#print(direction)
	#if(starting_run):
		#if direction:
			#velocity.x = direction * speed
		#else:
			#velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()


func _on_character_sprite_animation_looped():
	var animation = character_sprite.animation
	var list_animations = ["move_forward","move_backward","move_up","move_down","forward_decelerate"]
	if(animation in list_animations):
		starting_run = true
		character_sprite.frame = character_sprite.sprite_frames.get_frame_count(character_sprite.animation)
