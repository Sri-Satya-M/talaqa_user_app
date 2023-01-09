import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String? title;

  const PdfViewerScreen({super.key, required this.url, this.title});

  static Future open(
    BuildContext context, {
    required String url,
    String? title,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          url: url,
          title: title,
        ),
      ),
    );
  }

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController pdfController;

  @override
  void initState() {
    pdfController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? 'PdfViewer')),
      body: (widget.url.contains('http') || widget.url.contains('https'))
          ? SfPdfViewer.network(widget.url, controller: pdfController)
          : SfPdfViewer.file(File(widget.url), controller: pdfController),
    );
  }

  @override
  void dispose() {
    pdfController.dispose();
    super.dispose();
  }
}
