import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:graduationregistration/features/notifications/presentation/firebase/notification_service.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// يحاول الحصول على FCM Token مع إعادة المحاولة عدة مرات
  Future<String?> getFCMToken({int retry = 5}) async {
    for (var i = 0; i < retry; i++) {
      try {
        final token = await _firebaseMessaging.getToken();
        if (token != null) {
          print(' FCM Token Fetched: $token');
          return token;
        }
      } catch (e) {
        print(' Error while fetching token: $e');
      }

      print(' Waiting to retry getting token... attempt ${i + 1}');
      await Future.delayed(const Duration(seconds: 2));
    }

    print(' Failed to fetch FCM token after $retry attempts');
    return null;
  }

  /// تهيئة إعدادات Firebase Messaging
  Future<void> initNotifications() async {
    // طلب الإذن من المستخدم
    await _firebaseMessaging.requestPermission();

    // الحصول على التوكن عند أول تشغيل
    final token = await getFCMToken();
    print(' Initial FCM Token: $token');

    // الاستماع لتجديد التوكن تلقائيًا
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print(' FCM Token Refreshed: $newToken');
      // يمكنك هنا تخزينه أو إرساله للخادم
    });

    // الاستماع للإشعارات أثناء عمل التطبيق (Foreground)
    FirebaseMessaging.onMessage.listen((message) {
      print(' Foreground Notification');
      if (message.notification != null) {
        NotificationService.showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: message.data.toString(),
        );
      }
    });

    // عند فتح التطبيق من الإشعار (Background to Foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(' Notification caused app to open');
      // يمكن التوجيه لصفحة معينة حسب البيانات
    });

    // التعامل مع الإشعارات في الخلفية
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}

/// التعامل مع الإشعارات في الخلفية (يجب أن تكون دالة top-level)
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(' Background Notification Received');
  print('title : ${message.notification?.title}');
  print('body : ${message.notification?.body}');
  print('payload : ${message.data}');
}
