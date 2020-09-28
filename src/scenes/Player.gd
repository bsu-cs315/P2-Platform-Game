extends KinematicBody2D


export var gravity: float = 9.8
export var drag: float = 0.95
export var movement_speed: float = 250.0
export var movement_speed_max: float = 500.0
export var jump_force: float = 10.0
export var reset_height: float = 300.0

var airborne: bool = false
var velocity_horizontal: float = 0.0
var velocity_vertical: float = 0.0
var movement_dir: Vector2 = Vector2(0.0, 0.0)

onready var start_pos: Vector2 = position


func _physics_process(delta: float) -> void:
	check_airborne()
	get_input()
	calculate_velocity(delta)
	var _velocity: Vector2 = move_and_slide(movement_dir * movement_speed, Vector2(0, -1))
	if position.y > reset_height:
		reset_position()
	set_animation()


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
			

func set_animation() -> void:
	$PlayerSprite.play()
	if airborne:
		$PlayerSprite.animation = "air"
	else:
		$PlayerSprite.animation = "walk"
	if movement_dir.x == 0.0 && $PlayerSprite.animation == "walk":
		$PlayerSprite.frame = 0
		$PlayerSprite.stop()
		
		
func check_airborne() -> void:
	if is_on_floor():
		airborne = false
		velocity_vertical = 0.0
	else:
		airborne = true
	if is_on_wall():
		velocity_horizontal = 0.0
		
		
func calculate_velocity(delta: float) -> void:
	velocity_horizontal += movement_dir.x * movement_speed * delta
	movement_dir.x = clamp(velocity_horizontal * delta, -movement_speed_max, movement_speed_max)
	if velocity_horizontal > 0:
		velocity_horizontal = floor(velocity_horizontal * drag)
	if velocity_horizontal < 0:
		velocity_horizontal = ceil(velocity_horizontal * drag)
	velocity_vertical += gravity * delta
	movement_dir.y += velocity_vertical * delta
	
	
func reset_position() -> void:
	velocity_horizontal = 0
	velocity_vertical = 0
	position = start_pos
