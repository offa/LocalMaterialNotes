import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/select.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Adds a note.
///
/// An optional [content] can be specified for the note.
///
/// Exits the selection mode and navigates the app to the editor page.
Future<void> addNote(BuildContext context, WidgetRef ref, {String? content}) async {
  exitSelectionMode(ref);

  final note = content == null ? Note.empty() : Note.content(content);

  // If some content was provided, immediately save the note without waiting for changes in the editor
  if (content != null) {
    ref.read(notesProvider.notifier).edit(note);
  }

  currentNoteNotifier.value = note;

  if (!context.mounted) {
    return;
  }

  final editorRoute = RouterRoute.editor.fullPath!;
  final editorParameters = EditorParameters.from({'readonly': false, 'autofocus': true});

  // If the editor is already opened with another note, replace the route with the new editor
  RouterRoute.isEditor
      ? context.pushReplacement(editorRoute, extra: editorParameters)
      : context.push(editorRoute, extra: editorParameters);
}
