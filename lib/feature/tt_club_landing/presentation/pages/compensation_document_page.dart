import 'package:demandium/feature/language/controller/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class CompensationDocumentPage extends StatefulWidget {
  const CompensationDocumentPage({super.key});

  static const String routeName = '/compensation-document';

  @override
  State<CompensationDocumentPage> createState() =>
      _CompensationDocumentPageState();
}

class _CompensationDocumentPageState extends State<CompensationDocumentPage> {
  late final String _assetPath;
  late final PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _assetPath = _pdfAssetForCurrentLocale();
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset(_assetPath),
    );
  }

  String _pdfAssetForCurrentLocale() {
    final languageCode =
        (Get.find<LocalizationController>().locale.languageCode).toLowerCase();
    if (languageCode.startsWith('en')) {
      return 'assets/docs/compensation_en.pdf';
    }
    return 'assets/docs/compensation_ar.pdf';
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode =
        (Get.find<LocalizationController>().locale.languageCode).toLowerCase();
    final isEnglish = languageCode.startsWith('en');
    final title = isEnglish ? 'Compensation Document' : 'وثيقة تعويض';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PdfViewPinch(
        controller: _pdfController,
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (context, error) =>
              _PdfErrorView(error: error, assetPath: _assetPath),
        ),
      ),
    );
  }
}

class _PdfErrorView extends StatelessWidget {
  final Object error;
  final String assetPath;

  const _PdfErrorView({required this.error, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final languageCode =
        (Get.find<LocalizationController>().locale.languageCode).toLowerCase();
    final isEnglish = languageCode.startsWith('en');

    final title = isEnglish ? 'Failed to open document' : 'تعذر فتح الوثيقة';
    final hint = isEnglish
        ? 'Make sure the PDF is included in pubspec.yaml assets and exists at:'
        : 'تأكد من إضافة ملف PDF في pubspec.yaml وأنه موجود في المسار:';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.picture_as_pdf, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(hint, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            SelectableText(assetPath, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(error.toString(), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
