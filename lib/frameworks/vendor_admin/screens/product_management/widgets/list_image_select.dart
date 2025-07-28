import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/tools.dart';
import '../../../../../widgets/common/index.dart' show XFileImageWidget;

class ListImageSelect extends StatefulWidget {
  final List? images;
  final Function(List? images) onSelect;
  const ListImageSelect({super.key, this.images, required this.onSelect});

  @override
  State<ListImageSelect> createState() => _ListImageSelectState();
}

class _ListImageSelectState extends State<ListImageSelect> {
  List? _images;

  @override
  void initState() {
    _images = List.from(widget.images ?? []);
    super.initState();
  }

  Future<void> _addImage() async {
    try {
      final images = await ImageTools.pickMultiImage(limit: 5);
      _images = [...(_images ?? []), ...images];
      widget.onSelect(_images);
      setState(() {});
    } catch (_) {}
  }

  void _deleteImage({int? index, bool clearAll = false}) {
    final images = _images ?? [];
    if (clearAll) {
      images.clear();
    } else if (index != null) {
      images.removeAt(index);
    }
    widget.onSelect(images);
    setState(() {
      _images = images;
    });
  }

  Widget _buildImage(int index) {
    final images = _images ?? [];
    final item = images[index];
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Builder(
                builder: (_) {
                  if (item is String && item.isNotEmpty) {
                    return ImageResize(url: item, fit: BoxFit.cover);
                  }
                  if (item is XFile) {
                    return XFileImageWidget(
                      image: item,
                      fit: BoxFit.cover,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onPressed: () {
              _deleteImage(index: index);
            },
          ),
        )
      ],
    );
  }

  Widget _buildImages() {
    return SizedBox(
      height: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              InkWell(
                onTap: _addImage,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValueOpacity(0.6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Center(
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ),
              ),
              ...List.generate(
                _images?.length ?? 0,
                (index) => _buildImage(index),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            S.of(context).gallery,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: _buildImages(),
        ),
      ],
    );
  }
}
