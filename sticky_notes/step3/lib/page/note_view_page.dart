import 'package:flutter/material.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/providers.dart';

class NoteViewPage extends StatefulWidget {
  final int index;

  const NoteViewPage(this.index, {super.key});

  @override
  State createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  @override
  Widget build(BuildContext context) {
    final note = noteService().getNote(widget.index);
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title.isEmpty ? '(제목 없음)' : note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: '편집',
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: '삭제',
            onPressed: null,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: note.color,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Text(note.body),
        ),
      ),
    );
  }
}
