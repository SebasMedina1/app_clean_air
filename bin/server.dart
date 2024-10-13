import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  // Obtiene el puerto desde las variables de entorno o usa 8080 por defecto
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Middleware para procesar las solicitudes y registrar logs
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_handleRequest);

  // Inicia el servidor en el puerto especificado
  final server = await shelf_io.serve(handler, '0.0.0.0', port);
  print('Servidor corriendo en http://${server.address.host}:${server.port}');
}

// Manejador de solicitudes POST
Future<Response> _handleRequest(Request request) async {
  if (request.method == 'POST' && request.url.path == 'api/recibir') {
    // Lee el cuerpo de la solicitud
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    // Extrae los datos
    final alerta = data['alerta'];
    final gasLevel = data['gas_level'];
    final message = data['message'];

    print('Datos recibidos: Alerta=$alerta, Nivel de Gas=$gasLevel, Mensaje=$message');

    // Responder al cliente
    return Response.ok(
      jsonEncode({'status': 'Datos recibidos'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.notFound('Ruta no encontrada o método no permitido');
}
