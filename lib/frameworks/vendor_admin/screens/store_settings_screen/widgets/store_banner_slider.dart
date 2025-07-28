import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../../../../../widgets/common/index.dart' show XFileImageWidget;

class StoreBannerSlider extends StatelessWidget {
  final void Function()? onCallback;
  final void Function(int index)? onRemove;
  final List<Map> storeListBanner;
  final String title;

  const StoreBannerSlider({
    super.key,
    this.onCallback,
    this.storeListBanner = const [],
    this.title = '',
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: onCallback,
                child: SizedBox(
                  width: 105,
                  height: 105,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValueOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      storeListBanner.length,
                      (index) {
                        return StoreBannerSliderItem(
                          item: storeListBanner[index],
                          onDeleted: () => onRemove?.call(index),
                          enabled: onCallback != null,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StoreBannerSliderItem extends StatelessWidget {
  final Map item;
  final bool enabled;
  final void Function()? onDeleted;
  const StoreBannerSliderItem({
    required this.item,
    this.onDeleted,
    this.enabled = true,
  });

  Widget renderImage() {
    final image = item['image'];
    if (image is String && image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
        ),
      );
    }
    if (image is XFile) {
      return XFileImageWidget(
        image: image,
        width: 100,
        height: 100,
      );
    }
    return Container(
      color: Colors.red,
      width: 50,
      height: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final link = item['link'];

    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            height: 105,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: renderImage(),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: onDeleted,
                    child: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            S.of(context).link,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 5),
          Container(
            width: 105,
            height: 35,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: TextField(
                enabled: enabled,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 18.0),
                ),
                controller: link is TextEditingController ? link : null,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
