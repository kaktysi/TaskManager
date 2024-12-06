import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Запрашиваем разрешение
    await _messaging.requestPermission();

    // Получаем токен
    final fcmToken = await _messaging.getToken();
    log("FCM Token: $fcmToken");

    // Подписка на пользовательский топик
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final sanitizedEmail = user.email!.replaceAll('.', '_').replaceAll('@', '_');
      await _messaging.subscribeToTopic(sanitizedEmail);
    }

    // Обработчик уведомлений
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received notification: ${message.notification?.title}");
    });
  }
}
