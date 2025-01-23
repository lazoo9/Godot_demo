extends Camera2D

# 视角移动方式
@export var can_scale: bool = true
@export var can_drag: bool = true
@export var can_edge: bool = true
@export var can_keyboard: bool = false

@export var target_zoom: float = 1.0
@export var zoom_scale_frequency: float = 0.05
@export var zoom_scale_rate: float = 1.0
@export var min_zoom: float = 0.6
@export var max_zoom: float = 2.0
@export var zoom_move_rate: float = 2
@export var camera_margin: float = 50
var is_zoom_scale: bool = false
var is_dragging: bool = false
var pre_mouse_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	position_smoothing_enabled = true
	position_smoothing_speed = 5

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_out()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = true if event.pressed else false

func _physics_process(delta: float) -> void:
	if can_scale and is_zoom_scale:
		zoom = lerp(zoom, Vector2.ONE * target_zoom, delta)
		is_zoom_scale = not is_equal_approx(zoom.x, target_zoom)
	
	# 鼠标拖拽移动视角
	if can_drag and is_dragging:
		var direction = pre_mouse_position - get_local_mouse_position()
		position += direction * zoom
	pre_mouse_position = get_local_mouse_position()
	
	# 鼠标到达视角边界移动视角
	if can_edge:
		var _rect = get_viewport_rect()
		var _view = get_local_mouse_position() + _rect.size * 0.5
		if _rect.size.x - _view.x <= camera_margin:
			position += Vector2.RIGHT * zoom_move_rate
		elif _rect.size.y - _view.y <= camera_margin:
			position += Vector2.DOWN * zoom_move_rate
		elif  _view.x <= camera_margin:
			position += Vector2.LEFT * zoom_move_rate
		elif  _view.y <= camera_margin:
			position += Vector2.UP * zoom_move_rate
	
	# 键盘移动视角
	if can_keyboard:
		if Input.is_action_pressed("ui_up"):
			position += Vector2.UP * zoom_move_rate
		elif Input.is_action_pressed("ui_down"):
			position += Vector2.DOWN * zoom_move_rate
		elif Input.is_action_pressed("ui_left"):
			position += Vector2.LEFT * zoom_move_rate
		elif Input.is_action_pressed("ui_right"):
			position += Vector2.RIGHT * zoom_move_rate

# 鼠标滚轮缩放视距
func zoom_in() -> void:
	target_zoom = max(min_zoom, target_zoom - zoom_scale_frequency)
	is_zoom_scale = true

func zoom_out() -> void:
	target_zoom = min(max_zoom, target_zoom + zoom_scale_frequency)
	is_zoom_scale = true
