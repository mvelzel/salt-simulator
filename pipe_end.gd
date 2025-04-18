extends Node2D

var pipe_start: Node2D
var can_place = false
var enabled = true
@onready var player = get_tree().get_first_node_in_group("Player")

func stop_pumping():
	$UnconnectedPipe.visible = true
	$ConnectedPipe.visible = false
	enabled = false

func _on_trigger_body_entered(body: Node2D) -> void:
	if enabled and body.is_in_group("Player") and body.has_method("get_pipe"):
		var pipe = body.get_pipe()
		if pipe and not pipe.get_is_pumping():
			can_place = true
			pipe_start = pipe
			$PlaceLabel.visible = true
			body.push_interaction("PLACE", place_pipe)

func _on_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and can_place:
		can_place = false
		$PlaceLabel.visible = false
		body.pop_interaction("PLACE")

func place_pipe():
	pipe_start.start_pumping(self)
	$UnconnectedPipe.visible = false
	$ConnectedPipe.visible = true
	$PlaceLabel.visible = false
	player.pop_interaction("PLACE")
