extends KinematicBody2D

export var gravity: float = 9.8
export var movement_speed: float = 250.0
export var jump_force: float = 10.0

var airborne: bool = false
var velocity_vertical: float = 0.0
var movement_dir: Vector2 = Vector2(0.0, 0.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	check_airborne()
	get_input()
	apply_gravity(delta)
	move_and_slide(movement_dir * movement_speed, Vector2(0, -1))


func get_input() -> void:
	movement_dir = Vector2(0.0, 0.0)
	if Input.is_action_pressed("ui_left"):
		movement_dir.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		movement_dir.x += 1.0
	if Input.is_action_pressed("ui_up"):
		if !airborne:
			airborne = true
			velocity_vertical = -jump_force
		
		
func check_airborne() -> void:
	if is_on_floor():
		airborne = false
		velocity_vertical = 0.0
	else:
		airborne = true
		
func apply_gravity(delta: float) -> void:
	if(airborne):
		velocity_vertical += gravity * delta
		movement_dir.y += velocity_vertical * delta
