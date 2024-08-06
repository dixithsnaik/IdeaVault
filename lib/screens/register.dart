import 'package:note_app/controllers/note_controller.dart';

import 'package:note_app/globles/pallets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterUser extends StatelessWidget {
  const RegisterUser({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController noteController = Get.find();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: noteController.nameController,
              style: const TextStyle(fontSize: 24, color: whiteColor),
              cursorColor: whiteColor,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Enter Your Name To Register",
                hintStyle: TextStyle(color: timeColor, fontSize: 24),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: iconButtonColor,
              ),
              child: const Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
