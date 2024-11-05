extends Sprite2D


@export var speed: float = 100

var rect: Rect2

func _ready():
	rect = self.region_rect
	
func _process(delta):
	region_rect.position += Vector2( speed * delta , 0)
