// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/posts.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/widgets/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImg,
  ) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImg: profImg,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      String postId, String uid, List likes, BuildContext context) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      mySnackBar(context, e.toString());
    }
  }

  // Add Comments
  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
    BuildContext context,
  ) async {
    String res = "Some Error Occured";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePosted': DateTime.now(),
        });
        res = "success";
      } else {
        res = "Text is empty";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Deleting a Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occured";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Following
  Future<void> followUser(String uid, String followId) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];

    if (following.contains('followId')) {
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayRemove([uid]),
      });
      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayRemove([followId]),
      });
    } else {
      await _firestore.collection('users').doc(followId).update({
        'followers': FieldValue.arrayUnion([uid]),
      });
      await _firestore.collection('users').doc(uid).update({
        'following': FieldValue.arrayUnion([followId]),
      });
    }
  }
}
