import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sticky_notes/data/note.dart';
import 'package:sticky_notes/page/note_edit_page.dart';
import 'package:sticky_notes/page/note_view_page.dart';
import 'package:sticky_notes/providers.dart';

class NoteListPage extends StatefulWidget {
  static const routeName = '/';

  const NoteListPage({super.key});

  @override
  State createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  bool _showAsGrid = true;

  late Future<List<DocumentSnapshot>> _listNotes;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

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
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _listNotes,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snap.hasError) {
            return const Center(
              child: Text('오류가 발생했습니다.'),
            );
          }

          return _buildCards(snap.requireData);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '새 노트',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, NoteEditPage.routeName).then((value) {
            setState(() {
              _loadData();
            });
          });
        },
      ),
    );
  }

  Widget _buildCards(List<DocumentSnapshot> snapshots) {
    const padding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0);
    return _showAsGrid
        ? GridView.builder(
            padding: padding,
            itemCount: snapshots.length,
            itemBuilder: (context, index) {
              final snapshot = snapshots[index];
              return SizedBox(
                height: 160,
                child: _buildCard(snapshot.id, Note.fromData(snapshot.data())),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
          )
        : ListView.builder(
            padding: padding,
            itemCount: snapshots.length,
            itemBuilder: (context, index) {
              final snapshot = snapshots[index];
              return SizedBox(
                height: 160,
                child: _buildCard(snapshot.id, Note.fromData(snapshot.data())),
              );
            },
          );
  }

  Widget _buildCard(String id, Note note) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          NoteViewPage.routeName,
          arguments: id,
        ).then((value) {
          setState(() {
            _loadData();
          });
        });
      },
      child: Card(
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
      ),
    );
  }

  void _loadData() {
    _listNotes = noteService().listNotes();
  }
}
