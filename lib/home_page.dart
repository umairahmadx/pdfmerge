import 'package:flutter/material.dart';
import 'package:pdfmerge/pdf_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  void load() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                load();
                final imagePdf = await mergePDFs();
                load();
                openPdf(imagePdf);
              },
              child: Text("Open PDF"),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              width: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: CircularProgressIndicator(color: Colors.white,)),
                  SizedBox(height: 10,),
                  Text("Creating PDF",style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
