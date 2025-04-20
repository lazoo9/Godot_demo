extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $Node2D/Sprite2D/GPUParticles2D
@onready var hit_box: HitBox = $Node2D/Sprite2D/HitBox
@onready var player_detector: Area2D = $PlayerDetector
@onready var sprite_2d: Sprite2D = $Node2D/Sprite2D
@onready var pick_up_cool_timer: Timer = $PickUpCoolTimer

@export var scene_path: String
@export var is_on_floor: bool = false
var tween: Tween

func _ready() -> void:
	pick_up_cool_timer.timeout.connect(_on_pick_up_cool_timeout)

func move(move_direction: Vector2) -> void:
	hit_box.knock_direction = move_direction
	rotation = move_direction.angle()
	if scale.y == 1 and move_direction.x < 0:
		scale.y = -1
	elif scale.y == -1 and move_direction.x > 0:
		scale.y = 1

func get_input() -> void:
	if Input.is_action_just_pressed("attack") and not animation_player.is_playing():
		animation_player.play("charge")
	elif Input.is_action_just_released("attack"):
		if animation_player.is_playing() and animation_player.current_animation == "charge":
			animation_player.play("attack")
		elif gpu_particles_2d.emitting:
			animation_player.play("heavy_attack")

func cancel_attack() -> void:
	animation_player.play("cancel_attack")

func is_busy() -> bool:
	if animation_player.is_playing() or gpu_particles_2d.emitting:
		return true
	return false

func drop(cur_pos: Vector2) -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween().bind_node(self)
	tween.finished.connect(on_tween_finished)
	print(self)
	tween.tween_property(self, "global_position", cur_pos, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func on_tween_finished() -> void:
	#player_detector.monitoring = true
	print(self)
	is_on_floor = true

func _on_player_detector_body_entered(body: Node2D) -> void:
	if is_instance_valid(body) and body.has_method("pick_up_weapon") and is_on_floor:
		#player_detector.set_deferred("monitoring", false)
		print(body)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
		is_on_floor = false
	else:
		#player_detector.monitoring = true
		if tween and tween.is_valid() and body is not Player:
			print("stop")
			tween.stop()
			if pick_up_cool_timer.is_stopped():
				pick_up_cool_timer.start(0.3)
			#is_on_floor = true

func _on_pick_up_cool_timeout() -> void:
	is_on_floor = true
	pick_up_cool_timer.stop()
