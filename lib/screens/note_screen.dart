import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/providers/notes_provider.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _colorId = 0;

  final List<Color> _colors = [
    Colors.white,
    Colors.pink.shade100,
    Colors.yellow.shade100,
    Colors.lightGreen.shade100,
    Colors.lightBlue.shade100,
    Colors.purple.shade100,
  ];

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _colorId = widget.note!.colorId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    if (isEditing) {
      final updatedNote = widget.note!.copy(
        title: title,
        content: content,
        colorId: _colorId,
      );
      await notesProvider.updateNote(updatedNote);
    } else {
      final note = Note(
        title: title,
        content: content,
        createdTime: DateTime.now(),
        colorId: _colorId,
      );
      await notesProvider.addNote(note);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteNote() async {
    if (!isEditing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('刪除筆記'),
        content: const Text('確定要刪除這個筆記嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('刪除'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    await notesProvider.deleteNote(widget.note!.id!);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '編輯筆記' : '新增筆記'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Container(
        color: _colors[_colorId],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: '標題',
                border: InputBorder.none,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: '內容',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _colors.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _colorId = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _colors[index],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _colorId == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    width: _colorId == index ? 2 : 1,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}