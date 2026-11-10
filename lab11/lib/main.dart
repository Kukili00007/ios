import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('app_theme_dark_mode') ?? false;
  runApp(MyApp(startDarkMode: isDark));
}

class NoteItem {
  final String id;
  final String title;
  final String dateText;
  final bool isCompleted;

  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    required this.isCompleted,
  });

  NoteItem copyWith({bool? isCompleted}) {
    return NoteItem(
      id: id,
      title: title,
      dateText: dateText,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateText': dateText,
    'isCompleted': isCompleted,
  };

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      id:
          json['id'] as String? ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? 'Untitled note',
      dateText: json['dateText'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class MyApp extends StatefulWidget {
  final bool startDarkMode;

  const MyApp({super.key, required this.startDarkMode});

  @override
  State<MyApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<MyApp> {
  late bool isDarkMode = widget.startDarkMode;

  Future<void> changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('app_theme_dark_mode', value);
    setState(() => isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: NotesScreen(onThemeChanged: changeTheme),
    );
  }
}

class NotesScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const NotesScreen({super.key, required this.onThemeChanged});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  List<NoteItem> notes = [];
  bool isDarkMode = false;
  String username = 'Guest User';
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_display_name') ?? 'Guest User';
    final isDark = prefs.getBool('app_theme_dark_mode') ?? false;
    final savedNotes = prefs.getString('saved_notes');

    List<NoteItem> loadedNotes = [];
    if (savedNotes != null) {
      try {
        final decoded = jsonDecode(savedNotes) as List<dynamic>;
        loadedNotes = decoded
            .map((item) => NoteItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        loadedNotes = [];
      }
    }

    if (!mounted) return;
    setState(() {
      username = savedName;
      nameController.text = savedName == 'Guest User' ? '' : savedName;
      isDarkMode = isDark;
      notes = loadedNotes;
      isReady = true;
    });
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notes.map((note) => note.toJson()).toList());
    await prefs.setString('saved_notes', encoded);
  }

  Future<void> saveName() async {
    final value = nameController.text.trim();
    if (value.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_display_name', value);
    setState(() => username = value);
  }

  Future<void> addNote() async {
    final title = noteController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      notes.insert(
        0,
        NoteItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          dateText: DateTime.now().toString().substring(0, 16),
          isCompleted: false,
        ),
      );
      noteController.clear();
    });
    await saveNotes();
  }

  Future<void> toggleNote(int index, bool? value) async {
    setState(() {
      notes[index] = notes[index].copyWith(isCompleted: value ?? false);
    });
    await saveNotes();
  }

  Future<void> deleteNote(int index) async {
    setState(() => notes.removeAt(index));
    await saveNotes();
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Notes Vault')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Hello, $username', style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: saveName,
              child: const Text('Save name'),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) async {
              setState(() => isDarkMode = value);
              widget.onThemeChanged(value);
            },
          ),
          const Divider(),
          const Text('My Notes', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'New note',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => addNote(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: addNote,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (notes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: Text('No notes yet')),
            ),
          ...List.generate(notes.length, (index) {
            final note = notes[index];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: note.isCompleted,
                  onChanged: (value) => toggleNote(index, value),
                ),
                title: Text(
                  note.title,
                  style: TextStyle(
                    decoration: note.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text(note.dateText),
                trailing: IconButton(
                  onPressed: () => deleteNote(index),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
