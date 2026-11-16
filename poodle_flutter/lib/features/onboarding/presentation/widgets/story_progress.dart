import 'package:flutter/material.dart';

class StoryProgress extends StatelessWidget {
  const StoryProgress({
    super.key,
    required this.index,
    required this.count,
    required this.progress,
  });
  final int index;
  final int count;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: AnimatedBuilder(
      animation: progress,
      builder: (context, _) => Row(
        children: List.generate(
          count,
          (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == count - 1 ? 0 : 4),
              child: LinearProgressIndicator(
                value: i < index
                    ? 1
                    : i == index
                    ? progress.value
                    : 0,
                minHeight: 3,
                borderRadius: BorderRadius.circular(3),
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
