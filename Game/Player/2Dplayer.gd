extends KinematicBody2D
const MAX_SPEED = 95
const accel = 500
const fric = 500
const roll_speed = 125
signal place_clone()

#var active = true
enum{
	move,
	roll,
	atk,
	clone
}

var state = move
var velocity = Vector2.ZERO
var roll_vector = Vector2.ZERO

onready var pos = get_node("Position2D")
onready var posSprite = get_node("Position2D/Sprite")
onready var player = true
onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var swordhitbox = $hitboxpivot/swordhitbox

func _ready():
	animationtree.active = true
	swordhitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		move:
			move_(delta)
	
		roll:
			roll_()
	
		atk:
			atk_()
		clone:
			clone_()
	
func move_(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordhitbox.knockback_vector = input_vector
		animationtree.set("parameters/idle/blend_position",input_vector)
		animationtree.set("parameters/run/blend_position",input_vector)
		animationtree.set("parameters/atk/blend_position",input_vector)
		animationtree.set("parameters/roll/blend_position",input_vector)
		animationstate.travel("run")
		velocity = velocity.move_toward(input_vector*MAX_SPEED,accel*delta)
	
	else :
		animationstate.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, fric*delta)
		
	
	if Input.is_action_just_pressed("atk"):
		state = atk
	if Input.is_action_just_pressed("roll"):
		state = roll
	if Input.is_action_just_pressed("shadow clone"):
		state = clone
	
	velocity = move_and_slide(velocity)


func roll_():
	velocity = roll_vector * roll_speed
	animationstate.travel("roll")
	velocity = move_and_slide(velocity)

func atk_():
	velocity = Vector2.ZERO
	animationstate.travel("atk")
	
func atk_finish():
	state = move

func roll_finished():
	state = move
	
func clone_():
	if not player :
		pass
	set_physics_process(false) 
	posSprite.visible=true
	pos.set_physics_process(true)

func _on_Area2D_area_entered(area):
	if(area.name=='quit'):
		get_tree().quit()



func _on_Position2D_relay():
	pos.visible=false
	emit_signal("place_clone",$Position2D.global_position)
