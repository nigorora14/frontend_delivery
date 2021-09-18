import 'package:frontend_delivery/src/models/mercado_pago_credentials.dart';

class Environment {
  static const String API_DELIVERY="192.168.0.100:3000";
  static const String API_KEY_MAPS="AIzaSyBeT4ZvVXN6-ME_yU4I3fNDwG1_N7thEsk";

  //MERCADO PAGO CLAVE PUBLICA
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'TEST-538ea3b9-6d58-4605-a7fa-ed76ef5c5713',
      accessToken: 'TEST-1844554889341512-091715-42a964c6db346b8309e3901515f9dcee-578676229'
  );
}

