extends Control

@export var player: Node2D
@onready var cont: SubViewportContainer = $SubViewportContainer
@onready var subvp: SubViewport = $SubViewportContainer/SubViewport
@onready var peek_cam: Camera2D = $SubViewportContainer/SubViewport/PeekCam

# UI 크기(엣지 프리뷰 창 크기)
const PEEK_SIZE := Vector2i(18, 32)
# 메인 카메라 사각형을 살짝 키워서 ‘완전 밖’ 판단
const OUT_MARGIN := 4.0

func _ready() -> void:
	# SubViewport 설정
	subvp.world_2d = get_viewport().world_2d
	peek_cam.position_smoothing_enabled = false

func _process(_dt: float) -> void:
	if not is_instance_valid(player):
		return

	var rect := Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size)
	var pos := player.global_position

	# 화면 안쪽이면 숨김 (비용 절약: 업데이트 중지)
	if rect.grow(-OUT_MARGIN).has_point(pos):
		_set_peek_visible(false)
		return

	# 화면 밖이면 표시
	_set_peek_visible(true)

	# 1) 프리뷰 카메라를 플레이어에 맞춘다 (정확히 보여주기)
	peek_cam.global_position = pos

	# 2) 어느 가장자리에 붙일지 결정
	#var side := _offscreen_side(rect, pos)
	#_dock_edge(side)

func _set_peek_visible(v: bool) -> void:
	self.visible = v
	subvp.render_target_update_mode = SubViewport.UPDATE_ALWAYS if v else SubViewport.UPDATE_DISABLED

# 메인 카메라가 보는 월드 좌표 사각형
func _camera_world_rect(cam: Camera2D) -> Rect2:
	var vsz := get_viewport().get_visible_rect().size
	# 회전이 크면 Transform 계산으로 더 정확히 해야 하지만, 보통 2D는 회전 0이라고 가정
	var half := vsz * 0.5 * cam.zoom
	return Rect2(cam.global_position - half, vsz * cam.zoom)

# 플레이어가 바깥 어느 방향인지
func _offscreen_side(rect: Rect2, p: Vector2) -> String:
	var left_gap := rect.position.x - p.x
	var right_gap := p.x - (rect.position.x + rect.size.x)
	var top_gap := rect.position.y - p.y
	var bot_gap := p.y - (rect.position.y + rect.size.y)

	var max_gap = max(max(left_gap, right_gap), max(top_gap, bot_gap))
	if max_gap == left_gap:  return "left"
	if max_gap == right_gap: return "right"
	if max_gap == top_gap:   return "top"
	return "bottom"

# 엣지에 부착 + 크기/정렬
func _dock_edge(side: String) -> void:
	var pad := 8
	match side:
		"left":
			anchor_left = 0.0; anchor_right = 0.0
			anchor_top = 0.5;  anchor_bottom = 0.5
			position = Vector2(pad, size.y * -0.5)
			size = Vector2(PEEK_SIZE.x, PEEK_SIZE.y)
		"right":
			anchor_left = 1.0; anchor_right = 1.0
			anchor_top = 0.5;  anchor_bottom = 0.5
			position = Vector2(-PEEK_SIZE.x - pad, size.y * -0.5)
			size = Vector2(PEEK_SIZE.x, PEEK_SIZE.y)
		"top":
			anchor_left = 0.5; anchor_right = 0.5
			anchor_top = 0.0;  anchor_bottom = 0.0
			position = Vector2(size.x * -0.5, pad)
			size = Vector2(PEEK_SIZE.x, PEEK_SIZE.y)
		"bottom":
			anchor_left = 0.5; anchor_right = 0.5
			anchor_top = 1.0;  anchor_bottom = 1.0
			position = Vector2(size.x * -0.5, -PEEK_SIZE.y - pad)
			size = Vector2(PEEK_SIZE.x, PEEK_SIZE.y)
