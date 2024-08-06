import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/globles/pallets.dart';
import 'package:note_app/models/note_model.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/widgets/custom_button.dart';

class NoteDetailsScreen extends StatelessWidget {
  final NotesModel note;
  const NoteDetailsScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onTap: () => Navigator.of(context).pop(),
                      icon: SvgPicture.asset(
                        "assets/icons/left.svg",
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: color2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            note.type,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    CustomButton(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddNoteScreen(
                              edit: true,
                            ),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/edit2.svg",
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 26,
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  note.date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: timeColor,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                Text(
                  note.noteMessage,
                  style: const TextStyle(
                    fontSize: 20,
                    color: whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
