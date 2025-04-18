extends Control

@export var steps = 10
@export var current_step = 0

@export var start_texture: Texture2D
@export var end_texture: Texture2D
@export var progress_texture: Texture2D

@export var second_start_texture: Texture2D
@export var second_end_texture: Texture2D
@export var second_progress_texture: Texture2D

@export var background_start_texture: Texture2D
@export var background_end_texture: Texture2D
@export var background_progress_texture: Texture2D

var start_sprite: Sprite2D
var end_sprite: Sprite2D
var step_sprites: Array[Sprite2D] = []

func _ready() -> void:
	scaffold_steps(steps)
	render_bar(current_step)
	
func scaffold_steps(max_steps):
	steps = max_steps
	
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()
	start_sprite = null
	end_sprite = null
	step_sprites = []
	
	if background_progress_texture:
		var bg_step_width = background_progress_texture.get_width()
		var start_pos = -steps * bg_step_width / 2
		
		if background_start_texture:
			var sprite = Sprite2D.new()
			sprite.texture = background_start_texture
			add_child(sprite)
			sprite.position.x = start_pos - background_start_texture.get_width()
			
		for step in range(steps):
			var sprite = Sprite2D.new()
			sprite.texture = background_progress_texture
			add_child(sprite)
			sprite.position.x = start_pos + step * bg_step_width
			
		if background_end_texture:
			var sprite = Sprite2D.new()
			sprite.texture = background_end_texture
			add_child(sprite)
			sprite.position.x = start_pos + steps * bg_step_width
			
	if progress_texture:
		var step_width = progress_texture.get_width()
		var start_pos = -steps * step_width / 2
		
		if start_texture:
			var sprite = Sprite2D.new()
			sprite.texture = start_texture
			add_child(sprite)
			sprite.position.x = start_pos - start_texture.get_width()
			sprite.visible = false
			start_sprite = sprite
			
		for s in range(steps):
			var sprite = Sprite2D.new()
			sprite.texture = progress_texture
			add_child(sprite)
			sprite.position.x = start_pos + s * step_width
			sprite.visible = false
			step_sprites.append(sprite)
			
		if end_texture:
			var sprite = Sprite2D.new()
			sprite.texture = end_texture
			add_child(sprite)
			sprite.position.x = start_pos + steps * step_width
			sprite.visible = false
			end_sprite = sprite
		
func render_bar(step):
	if step > steps and not second_progress_texture:
		return
	if step > steps * 2:
		return
	
	current_step = step
	
	if not progress_texture:
		return
	
	if step > steps and second_progress_texture:
		if start_sprite:
			start_sprite.visible = true
			start_sprite.texture = second_start_texture
		if end_sprite and step == steps * 2:
			end_sprite.visible = true
			end_sprite.texture = second_end_texture
	else:
		if step == 0:
			if start_sprite:
				start_sprite.visible = false
		else:
			if start_sprite:
				start_sprite.visible = true
		if step < steps:
			if end_sprite:
				end_sprite.visible = false
		else:
			if end_sprite:
				end_sprite.visible = true
	
	for i in range(steps):
		if step > steps and second_progress_texture:
			step_sprites[i].visible = true
			if step - steps > i:
				step_sprites[i].texture = second_progress_texture
			else:
				step_sprites[i].texture = progress_texture
		else:
			if step > i and step != 0:
				step_sprites[i].visible = true
			else:
				step_sprites[i].visible = false
