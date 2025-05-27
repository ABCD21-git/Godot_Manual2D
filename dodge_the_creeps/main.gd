extends Node

@export var mob_scene : PackedScene
var score

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	if not $Music.playing:
		$Music.play()
	$Player.show()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD.update_score(score)

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() # Makes a instance of the mob scene which can be added to the scene
	
	var mob_spawn_location = $MobPath/MobSpawnLocation # Gets the spawn location from the Child node Pathfollow2D of the child Path2D
	mob_spawn_location.progress_ratio = randf() # Randomises the spawn location
	
	mob.position = mob_spawn_location.position # Sets the mob position to the randomised location
	# The mob is currently rotated towards the edges and will move on edges of the screen
	var direction = mob_spawn_location.rotation + PI/2 # Adds Pi/2 of rotation to the mobs to move it inwards
	direction += randf_range(-PI / 4, PI / 4) # Adds a bit of randomness to it
	mob.rotation = direction # Sets the mob's rotation to the randomised direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0) # Sets the velocity of mob to a Vector 2 of (150 - 250 , 0)
	mob.linear_velocity = velocity.rotated(direction) # Rotates the mobs velocity direction
	
	add_child(mob) # Adds it to the scene
	
func _ready():
	$Player.hide()
	$Music.play()

func _on_hud_start_game() -> void:
	new_game()
