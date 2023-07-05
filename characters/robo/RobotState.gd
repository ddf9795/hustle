extends CharacterState

class_name RobotState

export var is_super = false
export var super_level = 1
export var supers_used = -1
export var super_freeze_ticks = 15
export var super_effect = true
export var can_fly = true
export var throw_invuln_frames = 0
export var super_scale_combo_meter = true

func is_usable():
	if !is_super:
		return .is_usable()
	return .is_usable() and host.supers_available >= super_level

func _enter_shared():
	._enter_shared()
	if throw_invuln_frames > 0:
		host.start_throw_invulnerability()

func _frame_0_shared():
	if !is_super:
		return
	if super_effect:
		if super_scale_combo_meter and (super_level if supers_used == -1 else supers_used) > 0:
			host.combo_supers += 1
		host.start_super(super_freeze_ticks)
		host.play_sound("Super")
		host.play_sound("Super2")
		host.play_sound("Super3")
	for i in range(super_level if supers_used == -1 else supers_used):
		host.use_super_bar()

func _tick_shared():
	._tick_shared()
	if current_tick == throw_invuln_frames and throw_invuln_frames > 0:
		host.end_throw_invulnerability()
		
