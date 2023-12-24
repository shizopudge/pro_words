import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

@immutable
@RoutePage<void>()
class HomePage extends StatefulWidget {
  /// Домашний экран
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => setState(() {
          isVisible = !isVisible;
        }),
        child: Scaffold(
          body: SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) => _ExampleCard(index: index),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: 18,
            ),
          ),
        ),
      );
}

@immutable
class _ExampleCard extends StatelessWidget {
  final int index;

  _ExampleCard({
    required this.index,
    super.key,
  });

  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) => InteractionHoldWrapper(
        builder: (context, isHeldDown) => AnimatedScale(
          scale: isHeldDown ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.colors.grey),
                color: context.colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, .25),
                    color: context.colors.black.withOpacity(.15),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: AspectRatio(
                      aspectRatio: 341 / 190,
                      child: Flow(
                        delegate: ParallaxFlowDelegate(
                          scrollable: Scrollable.of(context),
                          listItemContext: context,
                          backgroundImageKey: _backgroundImageKey,
                        ),
                        children: [
                          AnimatedOpacity(
                            opacity: isHeldDown ? 0.85 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: AnimatedScale(
                              scale: isHeldDown ? 1.25 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Hero(
                                tag: index.toString(),
                                child: Image.network(
                                  'https://docs.flutter.dev/cookbook/img-files/effects/parallax/05-bali.jpg',
                                  key: _backgroundImageKey,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.theme.textTheme.titleLarge?.copyWith(
                            color: context.colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Description',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              color: context.colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) =>
      BoxConstraints.tightFor(
        width: constraints.maxWidth,
      );

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the image
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the image alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the image.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
