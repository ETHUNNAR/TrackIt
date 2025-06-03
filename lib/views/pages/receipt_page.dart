import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  _ReceiptPageState createState() =>
      _ReceiptPageState();
}

class _ReceiptPageState
    extends State<ReceiptPage> {
  File? _image;
  String _extractedText = '';

  Future<void> _pickImage(
    ImageSource source,
  ) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _extractText(File(pickedFile.path));
    }
  }

  Future<void> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final inputImage = InputImage.fromFile(file);

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(
            inputImage,
          );
      textRecognizer.close();

      // Sort the text blocks by their vertical position to ensure they are read from top to bottom
      recognizedText.blocks.sort(
        (a, b) => a.boundingBox.top.compareTo(
          b.boundingBox.top,
        ),
      );

      List<String> lines = [];
      for (TextBlock block
          in recognizedText.blocks) {
        // Sort the lines within each block by their vertical position
        block.lines.sort(
          (a, b) => a.boundingBox.top.compareTo(
            b.boundingBox.top,
          ),
        );
        for (TextLine line in block.lines) {
          lines.add(line.text);
        }
      }

      // Process lines to rearrange text as needed
      List<String> processedLines = _processLines(
        lines,
      );

      setState(() {
        _extractedText = processedLines.join(
          '\n',
        );
      });

      // Show the popup with the extracted text
      _showExtractedTextPopup(context);
    } catch (e) {
      setState(() {
        _extractedText =
            'Error extracting text: $e';
      });
    }
  }

  List<String> _processLines(List<String> lines) {
    List<String> processedLines = [];

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Skip lines that appear to be dates (e.g., 2025-03-13)
      if (RegExp(
        r'\d{4}-\d{2}-\d{2}',
      ).hasMatch(line)) {
        continue;
      }

      // Skip irrelevant lines (time or payment methods)
      if (RegExp(
            r'^\d{2}:\d{2}$',
          ).hasMatch(line) ||
          line.toUpperCase().contains(
            "DANKORT",
          ) ||
          line.contains("Kab")) {
        continue;
      }

      // Handle prices
      if (RegExp(
        r'^-?\d+([.,]\d{2})?$',
      ).hasMatch(line)) {
        if (processedLines.isNotEmpty &&
            RegExp(
              r'[a-zA-Z]',
            ).hasMatch(processedLines.last) &&
            !processedLines.last
                .toUpperCase()
                .contains("RABAT") &&
            !processedLines.last
                .toUpperCase()
                .contains("PANT")) {
          // Attach price to last detected product name
          processedLines[processedLines.length -
                  1] +=
              " " + line;
        } else {
          processedLines.add(line);
        }
      }
      // Handle "RABAT" and "PANT" discounts and their following price
      else if (line.toUpperCase() == "RABAT" ||
          line.toUpperCase() == "PANT") {
        if (i + 1 < lines.length &&
            RegExp(
              r'^-?\d+([.,]\d{2})?$',
            ).hasMatch(lines[i + 1].trim())) {
          processedLines.add(
            line + " " + lines[i + 1].trim(),
          );
          i++; // Skip the next line because it's already added
        }
      } else {
        processedLines.add(
          line,
        ); // Add regular line (product name, etc.)
      }
    }

    return processedLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_image != null)
              Image.file(_image!),
            const SizedBox(height: 16),
            SelectableText(_extractedText),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag:
                  'galleryButton', // Unique tag
              onPressed:
                  () => _pickImage(
                    ImageSource.gallery,
                  ),
              child: const Icon(
                Icons.photo_library,
              ),
            ),
            FloatingActionButton(
              heroTag:
                  'cameraButton', // Unique tag
              onPressed:
                  () => _pickImage(
                    ImageSource.camera,
                  ),
              child: const Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerFloat,
    );
  }

  void _showExtractedTextPopup(
    BuildContext context,
  ) {
    // Parse the extracted text into product names and prices
    List<Map<String, String>> products = [];
    for (String line in _extractedText.split(
      '\n',
    )) {
      // Skip irrelevant lines
      if (line.toUpperCase().contains(
            "AT BETALE",
          ) ||
          line.toUpperCase().contains("MOMS") ||
          line.toUpperCase().contains("VARER")) {
        continue;
      }

      // Split each line into parts
      List<String> parts = line.split(' ');

      // Normalize and trim each part
      parts =
          parts
              .map(
                (part) => part.trim().replaceAll(
                  ',',
                  '.',
                ),
              )
              .toList();

      // Find the last valid price in the line
      String? price;
      for (
        int i = parts.length - 1;
        i >= 0;
        i--
      ) {
        if (RegExp(
          r'^-?\d+\.\d{2}$',
        ).hasMatch(parts[i])) {
          price = parts.removeAt(
            i,
          ); // Remove the price from the parts
          break;
        }
      }

      // Join the remaining parts as the product name
      String name = parts.join(' ');

      // Skip lines that have no valid product name or price
      if (name.isEmpty &&
          (price == null || price.isEmpty)) {
        continue;
      }

      // Add the product to the list
      products.add({
        'name': name.trim(),
        'price':
            price ??
            '', // If no valid price, leave it empty
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Edit Extracted Text',
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue:
                                products[index]['name'],
                            decoration:
                                const InputDecoration(
                                  labelText:
                                      'Product Name',
                                ),
                            onChanged: (value) {
                              setState(() {
                                products[index]['name'] =
                                    value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue:
                                products[index]['price'],
                            decoration:
                                const InputDecoration(
                                  labelText:
                                      'Price',
                                ),
                            keyboardType:
                                TextInputType
                                    .number,
                            onChanged: (value) {
                              // Validate the price format
                              if (RegExp(
                                r'^-?\d+\.\d{2}$',
                              ).hasMatch(value)) {
                                setState(() {
                                  products[index]['price'] =
                                      value;
                                });
                              } else {
                                // If invalid, reset to the previous valid value
                                setState(() {
                                  products[index]['price'] =
                                      products[index]['price']!;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Save the edited products back to _extractedText
                setState(() {
                  _extractedText = products
                      .map(
                        (product) =>
                            '${product['name']} ${product['price']}',
                      )
                      .join('\n');
                });
                Navigator.of(
                  context,
                ).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
