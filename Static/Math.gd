extends Object
class_name Math

static  func clampi(value: int, min_value: int, max_value: int)-> int:
	return int(clamp(float(value), float(min_value), float(max_value)))
