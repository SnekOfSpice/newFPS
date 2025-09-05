extends CharacterBody3D

var movement_speed: float = 2.0
var movement_target_position: Vector3 #= Vector3(-3.0,0.0,2.0)

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

func set_movement_target(movement_target: Vector3):
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
