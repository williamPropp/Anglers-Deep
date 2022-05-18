extends CanvasLayer

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.change_scene(Global.main_menu_path)


func _on_TextureButton_pressed():
	Global.change_scene(Global.main_menu_path)
