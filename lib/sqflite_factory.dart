import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SqfliteFactory {
  static Future<void> init() async {
    sqfliteFfiInit(); // Inicializa o FFI
    databaseFactory = databaseFactoryFfi; // Configura o databaseFactory globalmente
  }
}
