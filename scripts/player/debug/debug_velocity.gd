extends RayCast3D


func _on_player_line_update(end, length):
	target_position = Vector3(0, 0, -length)
	# Workaround the dumb "Error look_at() failed"
	# because when falling, end is equal to Vector3.UP
	end.x += 0.01
	end.z += 0.01
	look_at(end)
