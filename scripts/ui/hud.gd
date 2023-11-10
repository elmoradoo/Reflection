extends MarginContainer


func velocity_change(velocity: float):
	$Stats/Velocity.text = str(snapped(velocity, 0.001))

func _on_stats_update(velocity: float):
	velocity_change(velocity)
