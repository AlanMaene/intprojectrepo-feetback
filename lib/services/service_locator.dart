import 'package:get_it/get_it.dart';

import 'package:feetback/services/navigation_service.dart';
import 'package:feetback/services/auth_service.dart';
import 'package:feetback/services/notification_service.dart';
import 'package:feetback/services/database_service.dart';
import 'package:feetback/services/settings_service.dart';
import 'package:feetback/services/bluetooth_service.dart';
import 'package:feetback/services/permission_service.dart';

/// https://www.filledstacks.com/snippet/dependency-injection-in-flutter/
/// https://medium.com/flutter-community/firebase-startup-logic-and-custom-user-profiles-6309562ea8b7
/// 
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => BluetoothService());
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => PermissionService());
}