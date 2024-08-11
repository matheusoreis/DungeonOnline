class_name Packet extends RefCounted

# ID do pacote
var id: int

# Conteúdo do pacote em formato binário
var content: PackedByteArray


# Construtor para inicializar o pacote
func _init(id: int = 0, content: PackedByteArray = PackedByteArray()):
	self.id = id
	self.content = content


# Converte um PackedByteArray em um Packet
func from_packed_byte_array(data: PackedByteArray) -> Packet:
	# Usando StreamPeerBuffer para manipulação binária
	var packet_buff := StreamPeerBuffer.new()
	packet_buff.put_data(data)

	# Reiniciar a posição para leitura
	packet_buff.seek(0)

	# Criando o novo pacote
	var packet := Packet.new()
	packet.id = packet_buff.get_u16()

	# Checar se ainda há dados a serem lidos para o conteúdo
	if packet_buff.get_position() < packet_buff.get_size():
		packet.content = packet_buff.get_data_array().slice(packet_buff.get_position())
	else:
		packet.content = PackedByteArray()

	return packet


# Converte o pacote em um PackedByteArray
func to_packet_byte_array() -> PackedByteArray:
	# Usando StreamPeerBuffer para construção do pacote
	var buffer := StreamPeerBuffer.new()

	# Escreve o ID do pacote
	buffer.put_u16(id)

	# Escreve o conteúdo do pacote
	buffer.put_data(content)

	return buffer.data_array
