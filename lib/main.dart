import 'package:flutter/material.dart';
import 'package:makinprrovider/app/makin.dart';
import 'core/config/appwrite_config.dart';

void main() async {
  // Ensure Flutter binding is initialized before calling any platform-specific code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Now it's safe to initialize Appwrite
  AppwriteConfig.initialize();
  
  runApp(const Makin());
}
