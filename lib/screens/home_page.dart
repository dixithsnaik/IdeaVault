import 'package:note_app/controllers/note_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:note_app/globles/pallets.dart';
import 'package:note_app/screens/add_note_screen.dart';
import 'package:note_app/screens/trash_notes.dart';
import 'package:note_app/widgets/custom_button.dart';
import 'package:note_app/widgets/note_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final noteController = Get.find<NoteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            CustomButton(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const TrashPage()));
                              },
                              icon: SvgPicture.asset(
                                "assets/icons/delete.svg",
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            CustomButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: backgroundColor,
                                        title: const Text(
                                          "Logout",
                                          style: TextStyle(color: whiteColor),
                                        ),
                                        content: const Text(
                                            "Are you sure you want to Logout?",
                                            style:
                                                TextStyle(color: whiteColor)),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              noteController.signout(context);
                                            },
                                            child: const Text("Yes",
                                                style: TextStyle(
                                                    color: timeColor)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("No",
                                                style: TextStyle(
                                                    color: whiteColor)),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: SvgPicture.asset(
                                "assets/icons/logout.svg",
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder(
                      stream: noteController.getNotes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final notes = snapshot.data!;
                        if (notes.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                noteController.resetFields();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AddNoteScreen()));
                              },
                              child: const Text(
                                "Keep track of everything with our easy-to-use note app. Write down ideas, create lists, plan projects - the possibilities are endless!",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: timeColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: notes.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              onDelete: () {
                                noteController.deleteNote(note: note);
                                Navigator.of(context).pop();
                              },
                              note: note,
                              index: index,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    noteController.resetFields();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddNoteScreen()));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: flotingActionColor,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 90, 90, 90),
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              0.0, 0.0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/icons/add.svg"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
