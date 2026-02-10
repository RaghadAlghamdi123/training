import 'package:flutter/material.dart';
import 'photo.dart';
import 'activty.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('fikra'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const NetworkImage(
                    'https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp',
                  ),
                  height: 200,
                ),
                const SizedBox(height: 20),

                /// زر صفحة رفع الصور
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UploadPhotoScreen(),
                      ),
                    );
                  },
                  child: const Text('Open Upload Photo'),
                ),

                const SizedBox(height: 12),

                /// ✅ زر صفحة الاكتفتي
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActivitiesScreen(),
                      ),
                    );
                  },
                  child: const Text('Open Activities'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
// raghad