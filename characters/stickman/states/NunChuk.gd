extends CharacterState

func _tick():
	host.apply_fric()
	host.apply_forces()
