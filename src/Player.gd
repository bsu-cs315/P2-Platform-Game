extends KinematicBody2D


export var gravity: float = 9.8
export var drag: float = 0.95
export var movement_speed: float = 250.0
export var movement_speed_max: float = 500.0
export var jump_force: float = 10.0
export var reset_height: float = 300.0

var airborne: bool = false
var landed: bool = false
var landing: bool = false
var landing_juice_t: float = 0.0
var jumping_juice_t: float = 0.0
var velocity_horizontal: float = 0.0
var velocity_vertical: float = 0.0
var movement_dir: Vector2 = Vector2(0.0, 0.0)
var jump_sounds: Array = [load("res://assets/jump1.wav"), load("res://assets/jump2.wav"), load("res://assets/jump3.wav")]
var death_sound: AudioStreamSample = load("res://assets/death.wav")
var coin_sound: AudioStreamSample = load("res://assets/money.wav")

onready var start_pos: Vector2 = position


func _process(delta):
	if landing:
		play_landing_juice(landing_juice_t)
		landing_juice_t += delta * 5
		if landing_juice_t >= 1:
			landing = false
			$PlayerSprite.scale.y = 1
	if airborne:
		play_jumping_juice(jumping_juice_t)
		jumping_juice_t += delta * 5
		if jumping_juice_t >= 1:
			$PlayerSprite.scale.y = 1
	

func _physics_process(delta: float) -> void:
	check_airborne()
	get_input()
	calculate_velocity(delta)
	var _velocity: Vector2 = move_and_slide(movement_dir * movement_speed, Vector2(0, -1))
	if position.y > reset_height:
		reset_position()
		play_death_sound()
	set_animation()
		
		
func play_landing_juice(t: float) -> void:
	$PlayerSprite.scale.y = 1 - (spike(t) * 0.25)
	
	
func play_jumping_juice(t: float) -> void:
	$PlayerSprite.scale.y = 1 + (spike(t) * 0.5)
	

func ease_in(t: float) -> float:
	return t * t
	

func flip(t: float) -> float:
	return 1 - t
	

func ease_out(t: float) -> float:
	return flip(flip(t) * flip(t))
	
	
func spike(t: float) -> float:
	if t <= 0.5:
		return ease_in(t / 0.5)
	return ease_out(t / 0.5)
	

func get_input() -> void:
	movement_dir = Vector2(0.0, 0.0)
	if Input.is_action_pressed("ui_left"):
		movement_dir.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		movement_dir.x += 1.0
	if Input.is_action_pressed("ui_up"):
		if !airborne:
			airborne = true
			jumping_juice_t = 0.0
			velocity_vertical = -jump_force
			play_jump_sound()
	
			
func play_jump_sound() -> void:
	var random_int: int = randi() % 3
	$PlayerAudio.stream = jump_sounds[random_int]
	$PlayerAudio.play()
	
	
func play_death_sound() -> void:
	$PlayerAudio.stream = death_sound
	$PlayerAudio.play()
	

func play_coin_sound() -> void:
	$PlayerAudio.stream = coin_sound
	$PlayerAudio.play()
			

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
		if !landed:
			landed = true
			landing = true
			landing_juice_t = 0.0
		airborne = false
		velocity_vertical = 0.0
	else:
		landed = false
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


func _on_PlayerArea_area_entered(area):
	if "Coin" in area.name:
		Score.score += 1
		play_coin_sound()
		area.queue_free()

