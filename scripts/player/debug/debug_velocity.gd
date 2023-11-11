extends RayCast3D


func _on_player_line_update(origin, end, length):
	target_position = Vector3(0, 0, -length)
	look_at(end)
