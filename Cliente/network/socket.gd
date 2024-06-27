class_name Socket


extends Object


enum Endianness {
	Little,
	Big
}

enum Header {
	U8,
	U16,
	U32,
	U64,
}


class TcpClient extends RefCounted:
	signal connected
	signal disconnected

	var alive: bool:
		get: return _connected

	var _stream: StreamPeerTCP
	var _connected: bool
	var _expecting := -1
	var _internal: Internal


	static func from_stream(stream: StreamPeerTCP) -> TcpClient:
		stream.set_no_delay(true)

		var client := TcpClient.new()
		client._stream = stream
		client._connected = true
		return client


	func _init():
		_stream = StreamPeerTCP.new()
		_internal = Internal.new()


	func connect_to_host(host: String, port: int) -> Error:
		var result := _stream.connect_to_host(host, port)
		if result == OK:
			await connected
			_stream.set_no_delay(true)
		return result


	func disconnect_from_host() -> void:
		_stream.disconnect_from_host()
		await disconnected


	func send(buf: PackedByteArray) -> Error:
		var result := _stream.put_partial_data(buf)
		if result[0] != OK:
			disconnect_from_host()
		return result[0]


	func recv(size: int) -> Array:
		if _expecting != -1:
			push_error('Cannot call recv while another recv operation is still in progress. Await the completion of the previous recv call before initiating a new one.')
			return [FAILED]

		_expecting = size
		var result := await _internal.recv as Array
		if result[0] != OK:
			_stream.disconnect_from_host()
		return result


	func poll() -> void:
		_stream.poll()
		var status := _stream.get_status()

		match status:
			StreamPeerTCP.Status.STATUS_CONNECTED:
				if not _connected:
					_connected = true
					connected.emit()
				if _expecting != -1 and _stream.get_available_bytes() >= _expecting:
					var result := _stream.get_partial_data(_expecting)
					_expecting = -1
					_internal.recv.emit(result[0], result[1])
			StreamPeerTCP.Status.STATUS_NONE, StreamPeerTCP.Status.STATUS_ERROR:
				if _connected:
					_connected = false
					disconnected.emit()


class TcpListener extends RefCounted:
	signal client_connected(client: TcpClient)
	signal client_disconnected(client: TcpClient)


	var _listener: TCPServer
	var _host: String
	var _port: int
	var _clients: Array


	func _init(host: String, port: int) -> void:
		_host = host
		_port = port
		_listener = TCPServer.new()
		_clients = []


	func start() -> Error:
		return _listener.listen(_port, _host)


	func stop() -> void:
		_listener.stop()


	func poll() -> void:
		if _listener.is_connection_available():
			var stream := _listener.take_connection()
			var client := TcpClient.from_stream(stream)
			client.disconnected.connect(func() -> void:
				var idx := _clients.find(client)
				var last_idx := _clients.size()
				var temp = _clients[idx]
				_clients[idx] = _clients[last_idx]
				_clients[last_idx] = temp
				_clients.resize(last_idx - 1)
				client_disconnected.emit(client))
			_clients.push_back(client)
			client_connected.emit(client)

		for c in _clients:
			c.poll()


class PacketClient extends RefCounted:
	signal connected
	signal disconnected
	signal packet_received(packet_buf: PackedByteArray)


	const Size := {
		Header.U8: 1,
		Header.U16: 2,
		Header.U32: 4,
		Header.U64: 8,
	}


	const PutFuncName := {
		Header.U8: StringName('put_8'),
		Header.U16: StringName('put_16'),
		Header.U32: StringName('put_32'),
		Header.U64: StringName('put_64'),
	}


	var alive: bool:
		get: return _client._connected
		
	var endianness: Endianness:
		get: return Endianness.Big if _client._stream.big_endian else Endianness.Little
		set(value): _client._stream.big_endian = value == Endianness.Big

	var _client: TcpClient
	var _put_header: StringName
	var _header_size: int


	func _init(header_size: Header):
		_client = TcpClient.new()
		_client.connected.connect(func(): connected.emit())
		_client.disconnected.connect(func(): disconnected.emit())
		_put_header = PutFuncName[header_size]
		_header_size = Size[header_size]


	func connect_to_host(host: String, port: int) -> Error:
		var result := await _client.connect_to_host(host, port)
		
		_begin_receive()
		
		return result


	func disconnect_from_host() -> void:
		await _client.disconnect_from_host()


	func send_packet(buf: PackedByteArray) -> Error:
		var size := buf.size()
		var stream := _client._stream

		stream.call(_put_header, size)
		var result := stream.put_partial_data(buf)
		if result[0] != OK:
			_client._stream.disconnect_from_host()
		return result[0]


	func poll() -> void:
		_client.poll()


	func _begin_receive() -> void:
		var header_buf: PackedByteArray
		var packet_buf: PackedByteArray
		var size: int
		var result: Array

		while _client.alive:
			result = await _client.recv(_header_size)
			if result[0] != OK:
				_client._stream.disconnect_from_host()
				return

			header_buf = result[1]
			match _header_size:
				1: size = header_buf.decode_u8(0)
				2: size = header_buf.decode_u16(0)
				4: size = header_buf.decode_u32(0)
				8: size = header_buf.decode_u64(0)

			result = await _client.recv(size)
			if result[0] != OK:
				_client._stream.disconnect_from_host()
				return

			packet_buf = result[1]
			packet_received.emit(packet_buf)


class Internal extends Object:
	signal recv(error: Error, buf: PackedByteArray)
