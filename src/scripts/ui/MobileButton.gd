extends TextureButton
@export var action_name: String

func _pressed():
	Input.action_press(action_name)

func _released():
	Input.action_release(action_name)
