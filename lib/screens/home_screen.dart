import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/screens/note_screen.dart';
import 'package:notes_app/screens/calendar_screen.dart';
import 'package:notes_app/widgets/note_card.dart';
import 'package:notes_app/providers/calendar_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const NotesPage(),
    ChangeNotifierProvider(
      create: (_) => CalendarProvider(),
      child: const CalendarScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('您的記事'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 實作搜尋功能
            },
          ),
          IconButton(
            icon: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) => Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(
                  context,
                  listen: false
              );
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: '筆記',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '行事曆',
          ),
        ],
      ),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, _) {
        final notes = notesProvider.notes;

        if (notes.isEmpty) {
          return const Center(
            child: Text('沒有筆記，請點擊右下角的按鈕添加'),
          );
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCard(
              note: notes[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(note: notes[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}