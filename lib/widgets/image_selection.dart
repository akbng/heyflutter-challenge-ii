import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/location_image.dart';

class ImageSelectionWidget extends StatefulWidget {
  const ImageSelectionWidget({
    super.key,
    required this.images,
    required this.onSelect,
  });

  final List<LocationImage> images;
  final void Function(LocationImage) onSelect;

  @override
  State<ImageSelectionWidget> createState() => _ImageSelectionWidgetState();
}

class _ImageSelectionWidgetState extends State<ImageSelectionWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 375),
          columnCount: 2,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: ImageChoiceWidget(
                image: widget.images[index],
                onSelect: () {
                  setState(() {
                    selectedIndex = selectedIndex == index ? null : index;
                  });
                  widget.onSelect(widget.images[index]);
                },
                selected: selectedIndex == index,
              ),
            ),
          ),
        ),
        itemCount: widget.images.length,
      ),
    );
  }
}

class ImageChoiceWidget extends StatelessWidget {
  const ImageChoiceWidget({
    super.key,
    required this.image,
    required this.onSelect,
    required this.selected,
    this.imageHash,
  });

  final LocationImage image;
  final String? imageHash;
  final void Function() onSelect;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Stack(children: [
        Image.network(image.smallUrl ?? image.url),
        if (selected)
          Positioned.fill(
            child: Container(
              color: Colors.black38,
              child: const Center(
                child: Icon(
                  Icons.check_circle_outlined,
                  color: Colors.white,
                  size: 75,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
