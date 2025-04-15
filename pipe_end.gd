extends Node2D

var pipe_start: Node2D
var can_place = false
var enabled = true

func stop_pumping():
	$UnconnectedPipe.visible = true
	$ConnectedPipe.visible = false
	enabled = false

func _on_trigger_body_entered(body: Node2D) -> void:
	if enabled and body.is_in_group("Player") and body.has_method("get_pipe"):
		var pipe = body.get_pipe()
		if pipe:
			pipe_start = pipe
			can_place = true
			if not pipe.get_is_pumping():
				$PlaceLabel.visible = true

func _on_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_place = false
		$PlaceLabel.visible = false
		
func _unhandled_input(event):
	if enabled and can_place and event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_E and pipe_start:
				if pipe_start.get_is_pumping():
					pipe_start.stop_pumping()
					stop_pumping()
				else:
					pipe_start.start_pumping(self)
					$UnconnectedPipe.visible = false
					$ConnectedPipe.visible = true
