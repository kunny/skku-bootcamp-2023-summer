import 'package:flutter/material.dart';

class NoteListPage extends StatefulWidget {

  const NoteListPage({super.key});

  @override
  State createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sticky Notes'),
      ),
    );
  }
}
