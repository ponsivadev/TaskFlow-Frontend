// import 'package:appwrite/appwrite.dart';

// class Appwrite {
//   static final Appwrite instance = Appwrite._internal();

//   late final Client client;

//   Appwrite._internal() {
//     client = Client() // Ensure client is initialized
//         .setEndpoint('https://cloud.appwrite.io/v1')
//         .setProject('66b2f99400258e649456')
//         .setSelfSigned(status: true);
//   }
// }
import 'package:appwrite/appwrite.dart';

class Appwrite {
  static final Appwrite instance = Appwrite._internal();
  late final Client client;

  Appwrite._internal();

  void initializeClient(Client newClient) {
    client = newClient;
  }
}
