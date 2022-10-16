extends CharacterHurtState

const GROUND_FRIC = "0.05"
const DI_STRENGTH = "1.0"

var hitstun = 0
var can_act = false

func _enter():
	can_act = false
	var hitbox = data["hitbox"]
	match hitbox.hit_height:
		Hitbox.HitHeight.High:
			anim_name = "HurtGroundedHigh"
		Hitbox.HitHeight.Mid:
			anim_name = "HurtGroundedMid"
		Hitbox.HitHeight.Low:
			anim_name = "HurtGroundedLow"
	
	hitstun = hitbox.hitstun_ticks
	var x = fixed.mul(hitbox.dir_x, "-1" if hitbox.facing == "Left" else "1")
	var knockback_force = fixed.normalized_vec_times(x, hitbox.dir_y, hitbox.knockback)
	knockback_force.y = "0"
	var di_force = fixed.normalized_vec_times(host.current_di.x, "0", DI_STRENGTH)
	var force_x = fixed.add(knockback_force.x, di_force.x)
	var force_y = fixed.add(knockback_force.y, di_force.y)
	host.apply_force(force_x, force_y)

func _tick():
	host.apply_full_fric(GROUND_FRIC)
	host.apply_forces_no_limit()
	if current_tick >= hitstun:
		if can_act:
			return fallback_state
		else:
			enable_interrupt()
			can_act = true

func _exit():
	if host.hp <= 0:
		queue_state_change("Knockdown")
