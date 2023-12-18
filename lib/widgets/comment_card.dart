// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.snap,
  });

  final snap;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 19, 19, 19),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(47, 255, 255, 255),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profilePic']),
                  radius: 18,
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.snap['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          "   ●   ",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePosted'].toDate()),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.snap['text'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
