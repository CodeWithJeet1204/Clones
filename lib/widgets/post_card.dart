// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/screens/comments_screen.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/widgets/like_animation.dart';
import 'package:instagram/widgets/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.snap,
  });
  // ignore: prefer_typing_uninitialized_variables
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;
  bool isOriginalRatio = false;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLength = snap.docs.length;
    } catch (e) {
      mySnackBar(context, e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: mobileBackgroundColor,
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            // Header
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: widget.snap['uid'],
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        widget.snap['profImage']!,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Image
          GestureDetector(
            onTap: () {
              setState(() {
                isOriginalRatio = !isOriginalRatio;
              });
            },
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
                context,
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: isOriginalRatio ? BoxFit.contain : BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Like , Comments & Share
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                      context,
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_outline),
                ),
              ),
              Text(
                widget.snap['likes'].length.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 1,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(68, 255, 255, 255),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            snap: widget.snap,
                          )),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
            ],
          ),

          // Description & No. of comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: Text(
                    widget.snap['description'],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) => CommentsScreen(
                              snap: widget.snap,
                            )),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View All $commentLength Comments",
                      style: const TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 34, 34, 34),
          ),
        ],
      ),
    );
  }
}
