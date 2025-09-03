extends HBoxContainer

var init_y: float = 0.0

func _ready() -> void:
	init_y = self.position.y

func show_down() -> void:
	ignore_event()
	
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"position:y", init_y + Utility.world_y, 1.5).set_trans(Tween.TRANS_QUAD)

func show_up() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"position:y", init_y, 1.5).set_trans(Tween.TRANS_QUAD)
	
	await tween.finished
	
	allow_event()

func ignore_event() -> void:
	$SettingButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PlayButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func allow_event() -> void:
	$SettingButton.mouse_filter = Control.MOUSE_FILTER_STOP
	$PlayButton.mouse_filter = Control.MOUSE_FILTER_STOP
	#$Button.mouse_filter = Control.MOUSE_FILTER_STOP
