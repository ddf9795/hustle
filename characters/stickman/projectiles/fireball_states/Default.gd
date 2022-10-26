extends ObjectState

class_name DefaultFireball

const FREE_AFTER_TICKS = 60

export var _c_Projectile_Dir = 0
export var move_x = 4
export var move_y = 0
export var clash = true
export var num_hits = 1
export var lifetime = 999999

var hit_something = false
var hit_something_tick = 0

func _enter():
	hit_something = false
	hit_something_tick = 0
	host.set_grounded(false)

func _tick():
	var pos = host.get_pos()
	host.update_grounded()
	if !hit_something and host.is_grounded() or pos.x < -host.stage_width or pos.x > host.stage_width:
		fizzle()
		host.hurtbox.width = 0
		host.hurtbox.height = 0
		pass
	if current_tick >= lifetime:
		fizzle()
	elif !hit_something:
		if data and data.has("speed_modifier"):
			host.move_directly_relative((move_x + data["speed_modifier"]) if move_x != 0 else 0, (move_y + data["speed_modifier"]) if move_y != 0 else 0)
		else:
			host.move_directly_relative(move_x, move_y)

func _on_hit_something(_obj, _hitbox):
	if clash:
		num_hits -= 1
		if num_hits == 0:
			fizzle()

func fizzle():
	hit_something = true
	host.disable()
	terminate_hitboxes()
	hit_something_tick = current_tick
