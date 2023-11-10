extends Control

func _on_stats_update(array):
	$ItemList.clear()
	for debug in array:
		$ItemList.add_item(debug)
