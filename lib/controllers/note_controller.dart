import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_app/globles/pallets.dart';
import 'package:note_app/models/note_model.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/user_model.dart';

class NoteController extends GetxController {
  final colors = [color1, color2, color3, color4];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final type = "personal".obs;
  final types = ["personal", "work", "others"];
  final currentNote = Rx<NotesModel?>(null);
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  // signIn() async {
  //   GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //   AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //   print(userCredential.user?.displayName);
  // }

  final auth = FirebaseAuth.instance;
  Future<void> signInWithGoogle() async {
    try {
      // get google user
      final googleUser = await GoogleSignIn().signIn();
      //get google auth
      final googleAuth = await googleUser!.authentication;
      //create credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // signin with credentials
      await auth.signInWithCredential(credential);
      userId = auth.currentUser!.uid.toString();
      final user = UserModel(
        name: auth.currentUser!.displayName ?? "Name",
        id: auth.currentUser!.uid,
        email: auth.currentUser!.email ?? "N/A",
      );
      await addUserDetails(user);
      // user signed in successfully
    } catch (e) {
      debugPrint("Error signing in with google: $e");
    }
  }

  Future<void> addUserDetails(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).set(
            user.toJson(),
          );
    } catch (e) {
      debugPrint("Error adding user details: $e");
    }
  }

  Future<void> signout(context) async {
    // disconnect google sign
    await GoogleSignIn().disconnect();
    // sign out from firebase auth
    await auth.signOut();
    userId = "";
    Navigator.of(context).pop();
  }

  Stream<List<NotesModel>> getNotes() {
    try {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId) // Target the user's document
          .collection("notes") // Get notes subcollection within the user
          .snapshots()
          .map((event) {
        final allNotes = <NotesModel>[];
        for (var element in event.docs) {
          final newNote = NotesModel.fromMap(element.data());
          allNotes.add(newNote);
        }
        return allNotes;
      });
    } catch (e) {
      print(e);
      return Stream.value(<NotesModel>[]);
    }
  }

  Stream<List<NotesModel>> getTrashNotes() {
    try {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("deletedNotes")
          .snapshots()
          .map((event) {
        final allNotes = <NotesModel>[];
        for (var element in event.docs) {
          final newNote = NotesModel.fromMap(element.data());
          allNotes.add(newNote);
        }
        return allNotes;
      });
    } catch (e) {
      print(e);
      return Stream.value(<NotesModel>[]);
    }
  }

  Future<void> createNote() async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("users")
          .doc(userId) // Target the user's document
          .collection("notes") // Create note within the "notes" subcollection
          .doc();
      final date = DateTime.now();
      final formatedDate = DateFormat("dd-MM-yyyy").format(date);
      final note = NotesModel(
        userName: nameController.text.trim(),
        id: ref.id,
        title: titleController.text.trim(),
        noteMessage: bodyController.text.trim(),
        date: formatedDate,
        type: type.value,
      );
      await ref.set(note.toMap());
      Get.back();
    } catch (e) {
      print("Error creating note: $e");
    }
  }

  Future<void> editNote() async {
    try {
      final note = currentNote.value!;
      final ref = FirebaseFirestore.instance
          .collection("users")
          .doc(userId) // Target the user's document
          .collection("notes") // Update note within the "notes" subcollection
          .doc(note.id);
      final date = DateTime.now();
      final formatedDate = DateFormat("dd-MM-yyyy").format(date);
      final editedNote = note.copyWith(
        title: titleController.text.trim(),
        noteMessage: bodyController.text.trim(),
        date: formatedDate,
        type: type.value,
      );
      await ref.set(editedNote.toMap());
      Get.back();
    } catch (e) {
      print("Error creating note: $e");
    }
  }

  Future<void> moveToTrash({required NotesModel note}) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("deletedNotes")
          .doc(note.id);
      final trashNote = note.copyWith(id: ref.id);
      await ref.set(trashNote.toMap());
    } catch (e) {
      print("Error creating note: $e");
    }
  }

  Future<void> deleteNote({required NotesModel note}) async {
    try {
      await moveToTrash(note: note);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId) // Target the user's document
          .collection("notes") // Delete from the "notes" subcollection
          .doc(note.id)
          .delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> removeFromTrash({required NotesModel note}) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("deletedNotes")
          .doc(note.id)
          .delete();
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> restoreNote() async {
    try {
      final note = currentNote.value!;
      await removeFromTrash(note: note);
      titleController.text = note.title;
      bodyController.text = note.noteMessage;
      type.value = note.type;
      await createNote();
    } catch (e) {
      print("Error restoring note: $e");
    }
  }

  void resetFields() {
    titleController.clear();
    bodyController.clear();
    type.value = "personal";
  }
}
