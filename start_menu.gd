extends Node2D

func _on_texture_button_pressed() -> void:
	if Global.is_debug() and Global.is_mobile():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		if Engine.has_singleton("JavaScriptBridge"):
			var js_bridge = Engine.get_singleton("JavaScriptBridge")
			js_bridge.call("eval", """if (document.documentElement.requestFullscreen) {
		  document.documentElement.requestFullscreen();
		} else if (document.documentElement.msRequestFullscreen) {
		  document.documentElement.msRequestFullscreen();
		} else if (document.documentElement.mozRequestFullScreen) {
		  document.documentElement.mozRequestFullScreen();
		} else if (document.documentElement.webkitRequestFullscreen) {
		  document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
		}""")
	get_tree().change_scene_to_file("res://levels/level1.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		_on_texture_button_pressed()
