import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('fikra'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(child: Image(image: NetworkImage('https://static.vecteezy.com/vite/assets/photo-masthead-375-BoK_p8LG.webp')),
    
      ),
    ),
  ),
  );
}

