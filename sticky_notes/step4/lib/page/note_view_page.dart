import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/providers.dart';

class NoteViewPage extends StatefulWidget {
  static const routeName = '/view';

  final String id;

  const NoteViewPage(this.id, {super.key});

  @override
  State createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  late Future<DocumentSnapshot> _note;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _note,
      builder: (context, snap) {
        Widget title;
        Widget body;

        if (snap.connectionState == ConnectionState.waiting) {
          title = const Text('불러오는 중...');
          body = const CircularProgressIndicator();
        } else if (snap.hasError) {
          title = const Text('오류');
          body = const Text('정보를 불러오지 못했습니다.');
        } else {
          final note = Note.fromData(snap.requireData.data());
          title = Text(note.title.isEmpty ? '(제목 없음)' : note.title);
          body = Container(
            width: double.infinity,
            height: double.infinity,
            color: note.color,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Text(note.body),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: title,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: '편집',
                onPressed: () => _edit(widget.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: '삭제',
                onPressed: () => _confirmDelete(widget.id),
              ),
            ],
          ),
          body: body,
        );
      },
    );
  }

  void _edit(String id) {
    Navigator.pushNamed(
      context,
      NoteEditPage.routeName,
      arguments: id,
    ).then((value) {
      setState(() {
        _loadData();
      });
    });
  }

  void _confirmDelete(String id) {
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
              noteService().deleteNote(id).then((result) {
                Navigator.popUntil(context, (route) => route.isFirst);
              });
            },
          ),
        ],
      );
    });
  }

  void _loadData() {
    _note = noteService().getNote(widget.id);
  }
}
