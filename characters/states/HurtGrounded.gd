extends CharacterHurtState

const GROUND_FRIC = "0.05"
const DI_STRENGTH = "3.5"

var hitstun = 0
var can_act = false
var wall_slam = false

func _enter():
	can_act = false
	hitbox = data["hitbox"]
	match hitbox.hit_height:
		Hitbox.HitHeight.High:
			anim_name = "HurtGroundedHigh"
		Hitbox.HitHeight.Mid:
			anim_name = "HurtGroundedMid"
		Hitbox.HitHeight.Low:
			anim_name = "HurtGroundedLow"
	hitstun = global_hitstun_modifier(hitbox.hitstun_ticks + hitstun_modifier(hitbox))
	wall_slam = hitbox.wall_slam and host.wall_slams < host.MAX_WALL_SLAMS
	counter = hitbox.counter_hit
	var x = get_x_dir(hitbox)
	host.set_facing(Utils.int_sign(fixed.round(x)) * -1)
	var knockback_force = fixed.normalized_vec_times(x, hitbox.dir_y, hitbox.knockback)
	knockback_force.y = "0"
	var di_force = fixed.vec_mul(host.get_scaled_di(host.current_di).x, "0", fixed.mul(DI_STRENGTH, hitbox.di_modifier))
	if hitbox.hitbox_type == Hitbox.HitboxType.Burst:
		di_force.x = "0"
		di_force.y = "0"
	if host.touching_wall and !wall_slam:
		knockback_force.x = "0"
	var force_x = fixed.add(knockback_force.x, di_force.x)
	var force_y = fixed.add(knockback_force.y, di_force.y)
	host.apply_force(force_x, force_y)

func _tick():
	host.set_pos(host.get_pos().x, 0)
	host.apply_x_fric(GROUND_FRIC)
	host.apply_forces_no_limit()
	if wall_slam:
		var vel = host.get_vel()
		var bounce = BOUNCE.NO_BOUNCE
		var col_box = host.get_collision_box()
		
		if (col_box.x1 <= -host.stage_width and fixed.lt(vel.x, "0")):
			bounce = BOUNCE.LEFT_WALL
		elif (col_box.x2 >= host.stage_width and fixed.gt(vel.x, "0")):
			bounce = BOUNCE.RIGHT_WALL

		if (bounce != BOUNCE.NO_BOUNCE):
			queue_state_change("WallSlam", bounce)
			return

	if current_tick >= hitstun:
		if can_act:
			return fallback_state
		else:
			enable_interrupt()
			can_act = true
