import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Imageextract extends StatefulWidget {
  const Imageextract({super.key});

  @override
  State<Imageextract> createState() => _ImageextractState();
}

class _ImageextractState extends State<Imageextract> {
  File? image;
  void imagePicker() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        image = File(file.path);
      });
    }
  }

  Future<String> extract(File image) async {
    // return "Select a image";
    final textRec = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inImage = InputImage.fromFile(image);
    final extText = await textRec.processImage(inImage);
    return extText.text;
  }

  Widget viewImage() {
    return Center(
      child: image != null
          ? Image.file(image!)
          : TextButton(onPressed: imagePicker, child: Text("pick a image")),
    );
  }

  Widget buildUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        viewImage(),
        if (image != null)
          FutureBuilder(
            future: extract(image!),
            builder: (context, snapshot) {
              return Expanded(
                  child: Text(
                      style: TextStyle(fontSize: 30),
                      snapshot.data ?? "NO TEXT FOUND"));
            },
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildUi());
  }
}
