import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';
import 'package:localmaterialnotes/models/note/note.dart';

/// Dismissible widget for the pin swipe action.
class DismissiblePin extends StatelessWidget {
  const DismissiblePin({
    super.key,
    required this.note,
    required this.swipeDirection,
  });

  /// Note that will be swiped.
  final Note note;

  /// Direction in which is widget will be swiped.
  final SwipeDirection swipeDirection;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(note.pinned ? Icons.push_pin_outlined : Icons.push_pin);
    final text = Text(
      note.pinned ? localizations.dismiss_unpin : localizations.dismiss_pin,
      style: Theme.of(context).textTheme.titleMedium,
    );

    return ColoredBox(
      color: Colors.blue,
      child: Padding(
        padding: Paddings.padding16.horizontal,
        child: Row(
          mainAxisAlignment: swipeDirection == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (swipeDirection == SwipeDirection.right) icon else text,
            Padding(padding: Paddings.padding4.horizontal),
            if (swipeDirection == SwipeDirection.right) text else icon,
          ],
        ),
      ),
    );
  }
}
