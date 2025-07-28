import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../../../../../widgets/common/index.dart' show XFileImageWidget;

class StoreLogo extends StatelessWidget {
  final void Function()? onCallback;
  final dynamic storeLogo;

  const StoreLogo({
    super.key,
    this.onCallback,
    this.storeLogo,
  });

  Widget renderLogo() {
    final logo = storeLogo;

    if (logo is String && logo.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        child: CachedNetworkImage(
          imageUrl: logo,
          fit: BoxFit.cover,
        ),
      );
    }
    if (logo is XFile) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
        child: XFileImageWidget(
          image: storeLogo,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).storeLogo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Expanded(child: SizedBox(width: 1)),
          InkWell(
            onTap: onCallback,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.withValueOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: renderLogo(),
            ),
          ),
        ],
      ),
    );
  }
}
