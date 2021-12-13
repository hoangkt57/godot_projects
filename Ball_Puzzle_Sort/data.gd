

static func getData() -> Array:
	var level1 = '{"1":[1,1,1,0],"2":[0,0,0,1],"3":[]}'
	var level2 = '{"1":[0,1,0,1],"2":[1,0,1,0],"3":[]}'
	var level = []
	level.append(level1)
	level.append(level2)
	return level

