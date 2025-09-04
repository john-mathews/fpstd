extends Sprite3D

@onready var progress:= $SubViewport/ProgressBar
@onready var label := $SubViewport/ProgressBar/Label

func update_health_bar(current_health: int, max_health: int):
	progress.max_value = max_health
	progress.value = current_health
	label.text = str(current_health) + "/" + str(max_health)
