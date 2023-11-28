extends KinematicBody

var jump = 7
var speed = 10
var gravity = 9.8 * 2
var cameraAcc = 50
var sens = 0.3

var snap
var direction = Vector3()
var velocity = Vector3()
var gravelocity = Vector3()
var movement = Vector3()

onready var head = $head
onready var camera = $head/Camera

func _input(event):
	if event is InputEventScreenDrag:
		rotate_y(deg2rad(-event.relative.x) * sens)
		head.rotate_x(deg2rad(-event.relative.y) * sens)
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	direction = Vector3.ZERO
	var HorizontalRotation = global_transform.basis.get_euler().y
	var Forwardinput = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var Horizontalinput = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction = Vector3(Horizontalinput, 0, Forwardinput).rotated(Vector3.UP, HorizontalRotation).normalized()
	
	
	if is_on_floor():
		snap = -get_floor_normal()
		gravelocity = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		gravelocity += Vector3.DOWN * gravity * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		snap = Vector3.DOWN
		gravelocity = Vector3.UP * jump
	
	velocity = velocity.linear_interpolate(direction * speed, delta)
	movement = velocity + gravelocity
	
	move_and_slide_with_snap(movement, snap, Vector3.UP)
