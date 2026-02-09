import 'package:flutter/material.dart';
import 'photo.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('fikra'),
        backgroundColor: Colors.deepPurple,
      ),
     body: Builder(
  builder: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: NetworkImage(
            'https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp',
          ),
          height: 200,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadPhotoScreen(),
              ),
            );
          },
          child: const Text('Open Upload Photo'),
        ),
      ],
    ),
  ),
),

    ),
  ),
  );
}
//raghad
