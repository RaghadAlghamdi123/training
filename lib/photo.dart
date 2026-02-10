import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

//ph


class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  Future<void> _pickFromGallery() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (img != null) setState(() => _pickedImage = img);
  }

  Future<void> _pickFromCamera() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.camera);
    if (!mounted) return;
    if (img != null) setState(() => _pickedImage = img);
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromCamera();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF79926C)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Upload Photo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF515F49),
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 40),

            // ✅ Upload Area (صار قابل للضغط + يعرض الصورة)
            InkWell(
              onTap: _showPickOptions,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: DashedBorderPainter(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _pickedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud,
                                    size: 80,
                                    color: const Color(0xFF6B8E7B).withOpacity(0.8),
                                  ),
                                  const Icon(
                                    Icons.arrow_upward,
                                    size: 30,
                                    color: Color.fromARGB(255, 245, 244, 244),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Click to upload',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF4B5563),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'PNG, PDF, AND JPEG',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          )
                        : Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // ✅ Cancel يرجع للصفحة السابقة
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFFD4A373)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF8C8888),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickedImage == null
                        ? null
                        : () {
                            // هنا لاحقاً ترفعين الصورة للسيرفر
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Submitted!')),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC49A83),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


// Custom painter for the dashed border effect
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFD4A373)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 3;
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
