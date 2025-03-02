import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

Future<void> openPdf(File file) async {
  final path = file.path;
  await OpenFile.open(path);
}

// Function to get all PDF file paths
List<String> getListPDFs() {
  List<String> pdfPaths = [];

  for (int i = 1; i <= 9; i++) {
    pdfPaths.add("pdfs/integration_questions_q$i.pdf");
  }
  for (int i = 1; i <= 9; i++) {
    pdfPaths.add("pdfs/limits_questions_q$i.pdf");
  }
  for (int i = 1; i <= 9; i++) {
    pdfPaths.add("pdfs/matrices_questions_q$i.pdf");
  }

  return pdfPaths;
}

Future<File> mergePDFs() async {
  Directory? root = await getExternalStorageDirectory();
  root ??= await getApplicationDocumentsDirectory(); // Fallback

  // ✅ Create a new PDF document
  PdfDocument mergedPdf = PdfDocument();

  // ✅ Ensure section is initialized
  PdfSection? section = mergedPdf.sections?.add();
  section?.pageSettings = PdfPageSettings(PdfPageSize.a4);

  // ✅ A4 Page Settings with Margins
  double leftMargin = 50;
  double topMargin = 50;
  double rightMargin = 50;
  double bottomMargin = 50;

  // ✅ Calculate usable width and height
  double pageWidth = PdfPageSize.a4.width - leftMargin - rightMargin;
  double pageHeight = PdfPageSize.a4.height - topMargin - bottomMargin;
  double currentHeight = topMargin; // Start from top margin
  double spacingBetweenPdfs = 10; // Space between PDFs

  // ✅ Get all PDF file paths
  List<String> pdfPaths = getListPDFs();

  // ✅ Ensure first page is initialized
  PdfPage? currentPage = section?.pages.add();

  for (String path in pdfPaths) {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    // ✅ Load each small PDF
    PdfDocument inputPdf = PdfDocument(inputBytes: bytes);
    PdfPage inputPage = inputPdf.pages[0];

    // ✅ Get small PDF height
    double inputHeight = inputPage.getClientSize().height;

    // ✅ If the next PDF won't fit, create a new page
    if (currentHeight + inputHeight + spacingBetweenPdfs > pageHeight) {
      currentPage = section?.pages.add();
      currentHeight = topMargin; // Reset height for new page
    }

    // ✅ Add spacing before PDFs (except first one on the page)
    if (currentHeight > topMargin) {
      currentHeight += spacingBetweenPdfs;
    }

    // ✅ Draw the small PDF onto the A4 page with margins
    PdfTemplate template = inputPage.createTemplate();
    currentPage?.graphics.drawPdfTemplate(
      template,
      Offset(leftMargin, currentHeight), // Apply left margin
      Size(pageWidth, inputHeight),
    );

    // ✅ Update height for next PDF
    currentHeight += inputHeight;

    inputPdf.dispose(); // ✅ Free memory
  }

  // ✅ Save final merged PDF
  List<int> bytes = mergedPdf.saveSync();
  mergedPdf.dispose();

  final File file = File("${root.path}/MergedMultiPage.pdf");
  await file.writeAsBytes(bytes);

  return file;
}
