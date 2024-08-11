class_name Processor extends RefCounted


var handlers: Dictionary = {}


func register_message(id: int, processor: Callable) -> void:
	handlers[id] = processor


func process_message(packet: Packet) -> void:
	var handler = handlers.get(packet.id)

	if handler:
		handler.call(packet)
	else:
		# TODO: fazer alguma coisa aqui (emitir um alerta?)
		return;
