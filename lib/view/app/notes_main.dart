import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utils/dialogs/show_logout_dialog.dart';
import 'package:mynotes/view/app/notes_list_view.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createUpdateNoteRoute);
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (_) => false);
                  }
              }
            }, itemBuilder: (content) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Log out'))
              ];
            })
          ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          if (allNotes.isNotEmpty) {
                            return NotesList(
                              notes: allNotes,
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                  createUpdateNoteRoute,
                                  arguments: note,
                                );
                              },
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              },
                            );
                          }
                        }
                        return const Center(
                          child: Text('Your notes will appear here!'),
                        );
                      default:
                        return const CircularProgressView();
                    }
                  },
                );
              default:
                return const CircularProgressView();
            }
          },
        ));
  }
}

class CircularProgressView extends StatelessWidget {
  const CircularProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
