import 'package:flutter/material.dart';
import 'package:pdfmerge/pdf_merge.dart';
import 'package:pdfmerge/save_open_document.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        ElevatedButton(
          onPressed: () async {
            final imagePdf = await ImagePdfApi.generateImagePdf();
            SaveOpenDocument.openPdf(imagePdf);
          },
          child: Text("Open PDF"),
        ),
      ),
    );
  }
}
