class_name BaseMessage extends RefCounted

# Referência ao WebSocketClient usado para enviar as mensagens
var _client: WebSocketClient


# Inicializa a mensagem, associando o WebSocketClient
func _init():
	_client = Network.websocket


# Converte um pacote recebido em uma BaseMessage
func from_packet(packet: Packet) -> BaseMessage:
	self.content = packet.content
	return self


# Converte a mensagem atual em um pacote para ser enviado
func to_packet() -> Packet:
	# Retorna um novo pacote com o ID e o conteúdo da mensagem
	var packet := Packet.new()
	packet.id = 0
	packet.content = PackedByteArray()

	return packet


# Envia a mensagem através do WebSocket
func send() -> void:
	_client.send_packet(self.to_packet())


# Manipula um pacote recebido e atualiza o conteúdo da mensagem
func handle(packet: Packet, scene_tree: SceneTree) -> void:
	pass
