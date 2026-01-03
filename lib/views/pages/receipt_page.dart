import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_learning/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  File? _image;
  String _extractedText = '';
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isProcessing = true;
      });
      await _extractText(File(pickedFile.path));
    }
  }

  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(file);

    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      recognizedText.blocks.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

      List<String> lines = [];
      for (TextBlock block in recognizedText.blocks) {
        block.lines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
        for (TextLine line in block.lines) {
          lines.add(line.text);
        }
      }

      List<String> processedLines = _processLines(lines);

      setState(() {
        _extractedText = processedLines.join('\n');
        _isProcessing = false;
      });

      if (mounted) _showExtractedTextPopup(context);
    } catch (e) {
      setState(() {
        _extractedText = 'Error extracting text: $e';
        _isProcessing = false;
      });
    }
  }

  List<String> _processLines(List<String> lines) {
    List<String> processedLines = [];
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      if (RegExp(r'\d{4}-\d{2}-\d{2}').hasMatch(line)) continue;
      if (RegExp(r'^\d{2}:\d{2}$').hasMatch(line) ||
          line.toUpperCase().contains("DANKORT") ||
          line.contains("Kab")) continue;

      if (RegExp(r'^-?\d+([.,]\d{2})?$').hasMatch(line)) {
        if (processedLines.isNotEmpty &&
            RegExp(r'[a-zA-Z]').hasMatch(processedLines.last) &&
            !processedLines.last.toUpperCase().contains("RABAT") &&
            !processedLines.last.toUpperCase().contains("PANT")) {
          processedLines[processedLines.length - 1] += " $line";
        } else {
          processedLines.add(line);
        }
      } else if (line.toUpperCase() == "RABAT" || line.toUpperCase() == "PANT") {
        if (i + 1 < lines.length && RegExp(r'^-?\d+([.,]\d{2})?$').hasMatch(lines[i + 1].trim())) {
          processedLines.add("$line ${lines[i + 1].trim()}");
          i++;
        }
      } else {
        processedLines.add(line);
      }
    }
    return processedLines;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _image == null ? _buildEmptyState(isDark) : _buildImagePreview(isDark),
      floatingActionButton: _image != null ? _buildFloatingButtons() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Scan a Receipt',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Take a photo or choose from your gallery to extract receipt data automatically',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ScanOptionButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 24),
                _ScanOptionButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.file(_image!, width: double.infinity, fit: BoxFit.cover),
                if (_isProcessing)
                  Positioned.fill(
                    child: Container(
                      color: AppColors.background.withValues(alpha: 0.7),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: AppColors.primary),
                            const SizedBox(height: 16),
                            Text(
                              'Processing...',
                              style: GoogleFonts.dmSans(
                                color: AppColors.textLight,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_extractedText.isNotEmpty && !_isProcessing) ...[
            const SizedBox(height: 24),
            Text(
              'Extracted Text',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.border : AppColors.divider),
              ),
              child: SelectableText(
                _extractedText,
                style: GoogleFonts.dmMono(
                  fontSize: 14,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                  height: 1.6,
                ),
              ),
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'gallery',
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text('Gallery', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'camera',
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text('Camera', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showExtractedTextPopup(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    List<Map<String, String>> products = [];

    for (String line in _extractedText.split('\n')) {
      if (line.toUpperCase().contains("AT BETALE") ||
          line.toUpperCase().contains("MOMS") ||
          line.toUpperCase().contains("VARER")) continue;

      List<String> parts = line.split(' ').map((part) => part.trim().replaceAll(',', '.')).toList();
      String? price;
      for (int i = parts.length - 1; i >= 0; i--) {
        if (RegExp(r'^-?\d+\.\d{2}$').hasMatch(parts[i])) {
          price = parts.removeAt(i);
          break;
        }
      }
      String name = parts.join(' ');
      if (name.isEmpty && (price == null || price.isEmpty)) continue;
      products.add({'name': name.trim(), 'price': price ?? ''});
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Items',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _ProductEditCard(
                    product: products[index],
                    isDark: isDark,
                    onChanged: (name, price) {
                      products[index] = {'name': name, 'price': price};
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        _extractedText = products
                            .map((p) => '${p['name']} ${p['price']}')
                            .join('\n');
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ScanOptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.border : AppColors.divider),
            ),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductEditCard extends StatelessWidget {
  final Map<String, String> product;
  final bool isDark;
  final void Function(String name, String price) onChanged;

  const _ProductEditCard({
    required this.product,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceLight : AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: product['name'],
              style: GoogleFonts.dmSans(
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              decoration: InputDecoration(
                labelText: 'Item',
                labelStyle: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) => onChanged(value, product['price'] ?? ''),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              initialValue: product['price'],
              keyboardType: TextInputType.number,
              style: GoogleFonts.dmMono(
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 12),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) => onChanged(product['name'] ?? '', value),
            ),
          ),
        ],
      ),
    );
  }
}
