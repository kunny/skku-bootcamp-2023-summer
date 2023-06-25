import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/providers.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  bool _showAsGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticky Notes'),
        actions: [
          IconButton(
            icon: Icon(_showAsGrid ? Icons.list : Icons.grid_view),
            tooltip: _showAsGrid ? '목록으로 보기' : '격자로 보기',
            onPressed: () {
              setState(() {
                _showAsGrid = !_showAsGrid;
              });
            },
          ),
        ],
      ),
      body: _buildCards(noteService().listNotes()),
    );
  }

  Widget _buildCards(List<Note> notes) {
    const padding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0);
    return _showAsGrid
        ? GridView.builder(
            padding: padding,
            itemCount: notes.length,
            itemBuilder: (context, index) => _buildCard(notes[index]),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
          )
        : ListView.builder(
            padding: padding,
            itemCount: notes.length,
            itemBuilder: (context, index) =>
                SizedBox(height: 160, child: _buildCard(notes[index])),
          );
  }

  Widget _buildCard(Note note) {
    return Card(
      color: note.color,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title.isEmpty ? '(제목 없음)' : note.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Text(
                note.body,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
