extends Node2D

var enemies: Array[Node2D] = []
@export var bullet_scene: PackedScene
@export var bullet_speed = 75

func _ready() -> void:
	$SpawnSound.play()

var shooting = false
func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies.append(body)
		
		if $Delay.is_stopped():
			$Delay.start()

func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy = enemies.find(body)
		if enemy >= 0:
			enemies.remove_at(enemy)
			
		if enemies.size() == 0:
			shooting = false
			$Delay.stop()

func _on_delay_timeout() -> void:
	var closest_enemy: Node2D
	var closest_distance
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if not closest_distance or distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
					
	if not closest_enemy:
		return
		
	var direction = global_position.direction_to(closest_enemy.global_position)
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.global_rotation = direction.angle()
	var velocity = direction * bullet_speed
	bullet.set_initial_velocity(velocity)
	
	$ShootSound.play()
