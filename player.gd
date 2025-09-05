extends CharacterBody3D
class_name Player



var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed := 2.0
var step_bob := 0.04
var step_fov_change := 5.0
var mouse_sensitivity = 0.002

@onready var camera : Camera3D = find_child("Camera3D")

@onready var camera_base_position : Vector3 = camera.position
@onready var camera_base_fov : float = camera.fov

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_CAPTURED:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		else:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	
	if event.is_action("ui_up"):
		queue_step()
	
var step_strength := 0.0
var left_foot := false

func queue_step():
	if step_strength > 0: return
	
	var t = create_tween()
	
	if left_foot: # left foot
		t.tween_property(self, "step_strength", 1, 0.6).set_ease(Tween.EASE_IN_OUT)
		t.tween_property(self, "step_strength", 0.2, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		t.tween_property(self, "step_strength", 0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	else:
		t.tween_property(self, "step_strength", 0.4, 0.3).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
		t.tween_property(self, "step_strength", 0.2, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		t.tween_property(self, "step_strength", 0, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
	
	#t.finished.connect(on_end_step)
	
	left_foot = not left_foot

#func on_end_step():
	#if Input.is_action_pressed("ui_up"):
		#queue_step()

var input: Vector2

func _physics_process(delta):
	%TextureRect.texture = camera.get_viewport().get_texture()
	velocity.y += -gravity * delta
	var raw_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if step_strength == 0:
		input = raw_input
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed * step_strength
	velocity.z = movement_dir.z * speed * step_strength
	
	#velocity.z = speed * movement_dir.z
	
	

	move_and_slide()
	#if is_on_floor() and Input.is_action_just_pressed("jump"):
		#velocity.y = jump_speed
	
	camera.position = camera_base_position + Vector3.UP * step_strength * step_bob
	camera.fov = camera_base_fov + step_strength * step_fov_change

#func _unhandled_input(event: InputEvent) -> void:
	
