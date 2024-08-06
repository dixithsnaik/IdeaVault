import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/globles/pallets.dart';
import 'package:note_app/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:note_app/controllers/note_controller.dart';

class AddNoteScreen extends StatelessWidget {
  final bool edit;
  AddNoteScreen({super.key, this.edit = false}) {
    if (edit) {
      final NoteController noteController = Get.find();
      noteController.titleController.text =
          noteController.currentNote.value!.title;
      noteController.bodyController.text =
          noteController.currentNote.value!.noteMessage;
      noteController.type.value = noteController.currentNote.value!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NoteController noteController = Get.find();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/left.svg",
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    GestureDetector(
                      onPanStart: (details) {
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        final position = Offset(details.globalPosition.dx,
                            details.globalPosition.dy + 20);
                        showMenu(
                          context: Get.context!,
                          color: backgroundColor,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          position: RelativeRect.fromSize(
                            position & const Size(0, 0),
                            overlay.size,
                          ),
                          items: List.generate(
                            noteController.types.length,
                            (index) => PopupMenuItem(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  noteController.type.value =
                                      noteController.types[index];
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  noteController.types[index],
                                  style: const TextStyle(
                                      color: whiteColor, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            height: 8,
                            width: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: color2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              noteController.type.value,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            CupertinoIcons.chevron_compact_down,
                            color: whiteColor,
                          )
                        ],
                      ),
                    ),
                    CustomButton(
                      icon: SvgPicture.asset(
                        "assets/icons/check.svg",
                        height: 12,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      onTap: () async {
                        if (edit) {
                          await noteController.editNote();
                        } else {
                          await noteController.createNote();
                        }
                        Get.back();
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: noteController.titleController,
                  style: const TextStyle(fontSize: 24, color: whiteColor),
                  cursorColor: whiteColor,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: "Title Of The Note",
                    hintStyle: TextStyle(color: timeColor, fontSize: 24),
                  ),
                ),
                TextField(
                  controller: noteController.bodyController,
                  minLines: 1,
                  maxLines: 25,
                  style: const TextStyle(fontSize: 18, color: whiteColor),
                  cursorColor: whiteColor,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText:
                        "Write anything you want to remember\nNo character limit, express yourself freely! Start typing to begin",
                    hintStyle: TextStyle(color: timeColor, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
