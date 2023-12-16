import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.snap,
  });
  final snap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: mobileBackgroundColor,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            // Header
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    snap['profImage']!,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          title: const Text("Delete Post"),
                          content: const Text(
                              "Are you sure you want to delete this post\nThis can't be undone"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(168, 244, 67, 54),
                  ),
                ),
              ],
            ),
          ),
          // Image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.33,
            width: double.infinity,
            child: Image.network(
              snap['postUrl'],
              fit: BoxFit.cover,
            ),
          ),

          // Like , Comments & Share
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outline,
                  // color: Color.fromARGB(166, 244, 67, 54),
                ),
              ),
              Text(
                snap['likes'].length.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share_outlined,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_outlined),
                  ),
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
                    snap['description'],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View All 200 Comments",
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
