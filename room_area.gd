extends Area2D

var registered_nodes: Array[Node2D] = []

var registered = false
func _physics_process(_delta: float) -> void:
	if not registered:
		call_deferred("register_areas")

func register_areas():
	for area in get_overlapping_areas():
		registered = true
		var parent = area.get_parent()
		if parent.has_method("turn_on"):
			registered_nodes.append(area.get_parent())
			
			if parent.has_method("turn_off"):
				parent.turn_off()
	for body in get_overlapping_bodies():
		registered = true
		if body.has_method("turn_on"):
			registered_nodes.append(body)
			
			if body.has_method("turn_off"):
				body.turn_off()

func register_node(node: Node2D) -> void:
	if node.has_method("turn_on"):
		registered_nodes.append(node)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		for node in registered_nodes:
			if is_instance_valid(node):
				node.turn_on()
