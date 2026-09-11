import 'package:flutter/material.dart';

class ConfirmTest extends StatelessWidget {
  final String userEmail;
  const ConfirmTest({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تم تأكيد التسجيل"),
        automaticallyImplyLeading: false, // منع زر الرجوع
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.check_circle_outline,
              color: Color.fromARGB(248, 7, 17, 104),
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              "تم تأكيد بريدك الإلكتروني $userEmail بنجاح!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Scaffold(
                      body: Center(child: Text("تم تسجيل الدخول بنجاح!")),
                    ),
                  ),
                );
              },
              child: const Text("الذهاب إلى الصفحة الرئيسية"),
            ),
          ],
        ),
      ),
    );
  }
}
