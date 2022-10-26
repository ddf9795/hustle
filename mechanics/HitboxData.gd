class_name HitboxData

var hit_height: int
var hitstun_ticks: int
var facing: String
var knockback: String
var dir_y: String
var dir_x: String
var pos_x: int
var pos_y: int
var knockdown: bool
var hitlag_ticks
var victim_hitlag
var disable_collision
var aerial_hit_state
var grounded_hit_state
var ground_bounce
var damage
var reversible
var name
var throw

func _init(state):
	hit_height = state.hit_height
	hitstun_ticks = state.hitstun_ticks
	facing = state.host.get_facing()
	knockback = state.knockback
	dir_y = state.dir_y
	hitlag_ticks = state.hitlag_ticks
	victim_hitlag = state.victim_hitlag
	disable_collision = state.disable_collision
	dir_x = state.dir_x
	knockdown = state.knockdown
	aerial_hit_state = state.aerial_hit_state
	grounded_hit_state = state.grounded_hit_state
	damage = state.damage
	name = state.name
	ground_bounce = state.ground_bounce
	throw = state.throw
	reversible = false if !state.get("launch_reversible") else state.launch_reversible
	if state.has_method("get_absolute_position"):
		var pos = state.get_absolute_position()
		pos_x = pos.x
		pos_y = pos.y
