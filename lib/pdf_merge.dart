import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pdfmerge/save_open_document.dart';

Future<Container> getImage(String path) async {
  final image = (await rootBundle.load("images/$path")).buffer.asUint8List();
  return Container(
    margin: EdgeInsets.all(10),
    child: Image(MemoryImage(image)),
  );
}

class ImagePdfApi {
  static Future<File> generateImagePdf() async {
    final pdf = pw.Document();

    final pageTheme = PageTheme(pageFormat: PdfPageFormat.a4);

    List<Container> images = [];
    for (int i = 1; i <= 9; i++) {
      Container img = await getImage("integration_questions_q$i.png");
      images.add(img);
    }
    for (int i = 1; i <= 9; i++) {
      Container img = await getImage("limits_questions_q$i.png");
      images.add(img);
    }
    for (int i = 1; i <= 9; i++) {
      Container img = await getImage("matrices_questions_q$i.png");
      images.add(img);
    }
    pdf.addPage(
      pw.MultiPage(pageTheme: pageTheme, build: (context) => images),
    );
    return SaveOpenDocument.savePdf(name: "ImageToPdf.pdf", pdf: pdf);
  }
}
