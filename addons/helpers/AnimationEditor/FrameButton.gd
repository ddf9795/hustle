tool

extends Control

signal pressed()
signal insert_before()
signal insert_after()
signal delete()

var keyframe = false

func _ready():
#	Utils.pass_along_signal($"%Button", self, "pressed")
	$"%Button".connect("pressed", self, "_on_button_pressed")
	Utils.pass_signal_along($"%InsertBefore", self, "pressed", "insert_before")
	Utils.pass_signal_along($"%InsertAfter", self, "pressed", "insert_after")
	Utils.pass_signal_along($"%Delete", self, "pressed", "delete")

func _on_button_pressed():
	if keyframe:
		emit_signal("pressed")


func set_frame(i):
	$"%Button".text = str(i + 1)

func set_image(texture):
	$"%TextureRect".texture = texture

func set_keyframe(on):
	keyframe = on
	if keyframe:
		$"%TextureRect".modulate.a = 1.0
		$"%Button".disabled = false
	else:
		$"%TextureRect".modulate.a = 0.25
		$"%Button".disabled = true
