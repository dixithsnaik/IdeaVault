
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:note_app/controllers/note_controller.dart';
import 'package:note_app/globles/pallets.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/note_details_screen.dart';

class NoteCard extends StatelessWidget {
  final NotesModel note;
  final int index;
  final VoidCallback onDelete;
  final bool trashNote;

  NoteCard({
    super.key,
    required this.note,
    required this.index,
    required this.onDelete,
    this.trashNote = false,
  });
  final noteController = Get.find<NoteController>();
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: backgroundColor,
                    title: const Text(
                      "Delete Note",
                      style: TextStyle(color: whiteColor),
                    ),
                    content: const Text(
                        "Are you sure you want to delete this note?",
                        style: TextStyle(color: whiteColor)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          onDelete();
                        },
                        child: const Text("Yes",
                            style: TextStyle(color: whiteColor)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No",
                            style: TextStyle(color: whiteColor)),
                      ),
                    ],
                  );
                });
          },
          backgroundColor: backgroundColor,
          icon: Icons.delete,
          label: "Delete",
        ),
        if (trashNote)
          SlidableAction(
            onPressed: (context) {
              noteController.currentNote.value = note;
              noteController.restoreNote();
              Navigator.of(context).pop();
            },
            backgroundColor: backgroundColor,
            icon: Icons.restore,
            label: "Restore",
          )
      ]),
      child: InkWell(
        onTap: () {
          if (trashNote == false) {
            noteController.currentNote.value = note;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteDetailsScreen(note: note),
              ),
            );
          }
          return;
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .copyWith(top: 15, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  noteController.colors[index % noteController.colors.length],
              width: 3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 320,
                child: Text(
                  note.noteMessage,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    note.date,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: timeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: noteController
                          .colors[index % noteController.colors.length],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    note.type,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
