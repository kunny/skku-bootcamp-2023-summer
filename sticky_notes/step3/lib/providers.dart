import 'package:sticky_notes/service/note_service.dart';

NoteService? _noteService;

NoteService noteService() {
  if (_noteService == null) {
    _noteService = NoteService();
  }
  return _noteService!;
}