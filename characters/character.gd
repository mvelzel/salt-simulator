extends CharacterBody2D


@export var SPEED = 300.0

func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	
@export var indicator_node: Node2D
const INDICATOR_DISTANCE = 150
	
func _process(_delta: float) -> void:
	var mouse_position = get_local_mouse_position()
	indicator_node.position = mouse_position.normalized() * INDICATOR_DISTANCE
	indicator_node.rotation = Vector2.ZERO.direction_to(mouse_position).angle()
