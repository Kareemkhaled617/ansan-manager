import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../../../../../widgets/common/index.dart' show XFileImageWidget;

class StoreBanner extends StatelessWidget {
  final void Function()? onCallback;
  final dynamic storeBanner;
  final String title;

  const StoreBanner({
    super.key,
    this.onCallback,
    this.storeBanner,
    this.title = '',
  });

  Widget renderBanner() {
    final banner = storeBanner;
    if (banner is String && banner.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        child: CachedNetworkImage(
          imageUrl: storeBanner,
          fit: BoxFit.cover,
        ),
      );
    }
    if (banner is XFile) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        child: XFileImageWidget(
          image: storeBanner,
          width: 200,
          height: 200,
        ),
      );
    }
    return const Center(
      child: Icon(Icons.camera_alt_outlined),
    );
  }

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
          InkWell(
            onTap: onCallback,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.withValueOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: renderBanner(),
            ),
          ),
        ],
      ),
    );
  }
}
