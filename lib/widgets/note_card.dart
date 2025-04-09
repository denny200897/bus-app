import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.white,
      Colors.pink.shade100,
      Colors.yellow.shade100,
      Colors.lightGreen.shade100,
      Colors.lightBlue.shade100,
      Colors.purple.shade100,
    ];

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colors[note.colorId],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title.isNotEmpty)
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (note.title.isNotEmpty)
                const SizedBox(height: 4),
              if (note.content.isNotEmpty)
                Text(
                  note.content,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Text(
                DateFormat('yyyy/MM/dd HH:mm').format(note.createdTime),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}