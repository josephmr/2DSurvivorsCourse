class_name WeightedTable

var items: Array[Dictionary] = []
var total_weight = 0

func add_item(item, weight: int):
	items.append({
		"item": item,
		"weight": weight
	})
	total_weight += weight


func pick_item(exclude: Array = []):
	var adjusted_items: Array[Dictionary] = items
	var adjusted_total_weight = total_weight
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_total_weight = 0
		for item in items:
			if item["item"] in exclude:
				continue
			adjusted_items.append(item)
			adjusted_total_weight += item["weight"]
		
	var chosen_weight = randi_range(1, adjusted_total_weight)
	var iterated_sum = 0
	for item in adjusted_items:
		iterated_sum += item["weight"]
		if chosen_weight <= iterated_sum:
			return item["item"]
	return null


func remove_item(item_to_remove):
	items = items.filter(func(item): return item["item"] != item_to_remove)
	total_weight = items.reduce(func(acc, item): return acc + item["weight"], 0)
