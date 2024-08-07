import 'package:appwrite/appwrite.dart';

class Appwrite {
  static final Appwrite instance = Appwrite._internal();
  late final Client client;

  Appwrite._internal();

  void initializeClient(Client newClient) {
    client = newClient;
  }
}
