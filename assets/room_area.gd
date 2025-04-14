extends Node2D

var registered_lights: Array[Node2D] = []

func register_light(light: Node2D) -> void:
	if light.has_method("turn_on"):
		registered_lights.append(light)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		for light in registered_lights:
			light.turn_on()
