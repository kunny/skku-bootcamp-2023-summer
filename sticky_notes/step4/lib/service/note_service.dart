import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sticky_notes/data/note.dart';

class NoteService {
  final _db = FirebaseFirestore.instance;

  Future<void> addNote(Note note) async {
    await _db.collection('notes').add(note.toData());
  }

  Future<void> deleteNote(String id) {
    return _db.collection('notes').doc(id).delete();
  }

  Future<DocumentSnapshot> getNote(String id) {
    return _db.collection('notes').doc(id).get();
  }

  Future<List<DocumentSnapshot>> listNotes() async {
    final collection = await _db.collection('notes').get();
    return collection.docs;
  }

  Future<void> updateNote(String id, Note note) {
    return _db.collection('notes').doc(id).update(note.toData());
  }
}
