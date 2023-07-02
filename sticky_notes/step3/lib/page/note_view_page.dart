import 'package:flutter/material.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/providers.dart';

class NoteViewPage extends StatefulWidget {
  static const routeName = '/view';

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
            onPressed: () => _edit(widget.index),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: '삭제',
            onPressed: () => _confirmDelete(widget.index),
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

  void _edit(int index) {
    Navigator.pushNamed(
      context,
      NoteEditPage.routeName,
      arguments: index,
    ).then((value) {
      setState(() { });
    });
  }

  void _confirmDelete(int index) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('노트 삭제'),
        content: const Text('노트를 삭제할까요?'),
        actions: [
          TextButton(
            child: const Text('아니오'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('예'),
            onPressed: () {
              noteService().deleteNote(index);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      );
    });
  }
}
