class_name SingletonHook extends Object

'''
노드가 초기화되는 콜백에서 이용한다.
SingletonHook.new(self)
'''

static var ids: Dictionary[int, bool] = {}

func _init(target: Node) -> void:
	var script: Script = target.get_script()
	if script == null:
		free()
		return
	
	var id: int = script.get_instance_id()
	if not ids.has(id):
		ids[id] = true
	else:
		target.queue_free()
	
	free()
