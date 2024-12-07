import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Сервис для работы с уведомлениями через Firebase Cloud Messaging (FCM).
/// Этот класс управляет подписками на темы уведомлений и обработкой входящих уведомлений.
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Инициализация сервиса уведомлений.
  /// 
  /// Запрашивает разрешение на получение уведомлений, получает токен устройства,
  /// подписывается на тему уведомлений, связанную с текущим пользователем, и
  /// устанавливает обработчик для получения входящих уведомлений.
  Future<void> initialize() async {
    // Запрашиваем разрешение на получение уведомлений.
    await _messaging.requestPermission();

    // Получаем токен для отправки уведомлений.
    final fcmToken = await _messaging.getToken();
    log("FCM Token: $fcmToken");

    // Подписка на тему, связанную с email текущего пользователя.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final sanitizedEmail = user.email!.replaceAll('.', '_').replaceAll('@', '_');
      await _messaging.subscribeToTopic(sanitizedEmail);
    }

    // Устанавливаем обработчик для получения уведомлений.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received notification: ${message.notification?.title}");
    });
  }
}
