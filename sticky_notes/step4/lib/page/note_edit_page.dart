import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/providers.dart';

class NoteEditPage extends StatefulWidget {
  static const routeName = '/edit';

  final String? id;

  const NoteEditPage(this.id, {super.key});

  @override
  State createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  final _titleController = TextEditingController();

  final _bodyController = TextEditingController();

  Color _color = Note.colorDefault;

  @override
  void initState() {
    super.initState();
    final noteId = widget.id;
    if (noteId != null) {
      noteService().getNote(noteId).then((snap) {
        final note = Note.fromData(snap.data());
        _titleController.text = note.title;
        _bodyController.text = note.body;
        setState(() {
          _color = note.color;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('노트 편집'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            tooltip: '배경색 선택',
            onPressed: _displayColorSelectionDialog,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '저장',
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: _color,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목 입력',
                ),
                maxLines: 1,
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '노트 입력',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _displayColorSelectionDialog() {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('배경색 선택'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('없음'),
                  onTap: () => _applyColor(Note.colorDefault),
                ),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Note.colorRed),
                  title: const Text('빨간색'),
                  onTap: () => _applyColor(Note.colorRed),
                ),
                ListTile(
                  leading:
                      const CircleAvatar(backgroundColor: Note.colorOrange),
                  title: const Text('오렌지색'),
                  onTap: () => _applyColor(Note.colorOrange),
                ),
                ListTile(
                  leading:
                      const CircleAvatar(backgroundColor: Note.colorYellow),
                  title: const Text('노란색'),
                  onTap: () => _applyColor(Note.colorYellow),
                ),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Note.colorLime),
                  title: const Text('연두색'),
                  onTap: () => _applyColor(Note.colorLime),
                ),
                ListTile(
                  leading: const CircleAvatar(backgroundColor: Note.colorBlue),
                  title: const Text('파란색'),
                  onTap: () => _applyColor(Note.colorBlue),
                ),
              ],
            ),
          );
        });
  }

  void _applyColor(Color newColor) {
    setState(() {
      Navigator.pop(context);
      _color = newColor;
    });
  }

  void _saveNote() {
    if (_bodyController.text.isNotEmpty) {
      final note = Note(
        _bodyController.text,
        title: _titleController.text,
        color: _color,
      );

      final noteId = widget.id;
      Future<void> future;
      if (noteId != null) {
        future = noteService().updateNote(noteId, note);
      } else {
        future = noteService().addNote(note);
      }

      future.then((result) {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('노트를 입력하세요'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}
