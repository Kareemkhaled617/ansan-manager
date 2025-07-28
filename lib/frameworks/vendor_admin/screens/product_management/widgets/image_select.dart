import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/tools.dart';
import '../../../../../widgets/common/index.dart' show XFileImageWidget;

class ImageSelect extends StatefulWidget {
  final dynamic image;
  final Function(dynamic image) onSelect;
  const ImageSelect({
    super.key,
    this.image,
    required this.onSelect,
  });

  @override
  State<ImageSelect> createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  dynamic _image;

  @override
  void initState() {
    _image = widget.image;
    super.initState();
  }

  Future<void> _selectImage() async {
    try {
      _image = await ImageTools.pickImage();
      widget.onSelect(_image);
      setState(() {});
    } catch (_) {}
  }

  void _clearImage() {
    widget.onSelect(null);
    _image = null;
    setState(() {});
  }

  Widget _buildImage() {
    final image = _image;
    if (image is String && image.isNotEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: ImageResize(
                url: image,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: _clearImage,
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (image is XFile) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: XFileImageWidget(
                image: image,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: _clearImage,
                icon: const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const Center(
      child: Icon(
        Icons.camera_alt_outlined,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            S.of(context).imageFeature,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        InkWell(
          onTap: _selectImage,
          child: AspectRatio(
            aspectRatio: 6 / 3,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color:
                    _image != null ? null : Colors.grey.withValueOpacity(0.6),
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: MediaQuery.of(context).size.width,
              child: _buildImage(),
            ),
          ),
        ),
      ],
    );
  }
}
