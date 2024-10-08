import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/separators.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// List of notes.
class NotesList extends ConsumerStatefulWidget {
  /// Main page with the list of not deleted notes.
  const NotesList.notes() : route = RouterRoute.notes;

  /// Bin page with the list of deleted notes.
  const NotesList.bin() : route = RouterRoute.bin;

  /// Route in which the notes list is displayed.
  ///
  /// Used to determine which notes provider should be used.
  final RouterRoute route;

  @override
  ConsumerState<NotesList> createState() => _NotesListState();
}

class _NotesListState extends ConsumerState<NotesList> {
  @override
  Widget build(BuildContext context) {
    final isNotes = widget.route == RouterRoute.notes;
    final provider = isNotes ? notesProvider : binProvider;

    return ref.watch(provider).when(
      data: (notes) {
        if (notes.isEmpty) {
          return isNotes ? EmptyPlaceholder.notes() : EmptyPlaceholder.bin();
        }

        // Use at least 2 columns for the grid view
        final columnsCount = MediaQuery.of(context).size.width ~/ Sizes.custom.gridLayoutColumnWidth;
        final crossAxisCount = columnsCount > 2 ? columnsCount : 2;

        return ValueListenableBuilder(
          valueListenable: layoutNotifier,
          builder: (context, layout, child) {
            return ValueListenableBuilder(
              valueListenable: showTilesBackgroundNotifier,
              builder: (context, showTilesBackground, child) {
                return ValueListenableBuilder(
                  valueListenable: showSeparatorsNotifier,
                  builder: (context, showSeparators, child) {
                    return layout == Layout.list
                        ? ListView.separated(
                            padding: showTilesBackground ? Paddings.custom.notesWithBackground : Paddings.custom.fab,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              return NoteTile(notes[index]);
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: showTilesBackground
                                    ? Paddings.custom.notesListWithBackgroundSeparation
                                    : EdgeInsetsDirectional.zero,
                                child: showSeparators ? Separator.divider1indent8.horizontal : null,
                              );
                            },
                          )
                        : AlignedGridView.count(
                            padding: Paddings.custom.notesWithBackground,
                            mainAxisSpacing: Sizes.custom.notesGridLayoutSpacing,
                            crossAxisSpacing: Sizes.custom.notesGridLayoutSpacing,
                            crossAxisCount: crossAxisCount,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              return NoteTile(notes[index]);
                            },
                          );
                  },
                );
              },
            );
          },
        );
      },
      error: (error, stackTrace) {
        return const ErrorPlaceholder();
      },
      loading: () {
        return const LoadingPlaceholder();
      },
    );
  }
}
