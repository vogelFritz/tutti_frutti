import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static void loadEnvironmentVariables() async {
    await dotenv.load(fileName: ".env");
  }

  static String? get host => dotenv.env['HOST'];
  static String? get port => dotenv.env['PORT'];
  static String? get address => '${dotenv.env['HOST']}:${dotenv.env['PORT']}';
}
