// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.uid,
  });
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String text = "Edit Profile";
  Color backgroundColor = blueColor;
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // Posts length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      mySnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: MediaQuery.of(context).size.width * 0.305,
          color: const Color.fromARGB(255, 14, 14, 14),
          child: Text(
            num.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade300,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: MediaQuery.of(context).size.width * 0.305,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      ],
    );
  }

  void onFollowTap() async {
    await FirestoreMethods().followUser(
      FirebaseAuth.instance.currentUser!.uid,
      userData['uid'],
    );
    setState(() {
      isFollowing = true;
      followers++;
    });
  }

  void onUnFollowTap() async {
    await FirestoreMethods().followUser(
      FirebaseAuth.instance.currentUser!.uid,
      userData['uid'],
    );
    // mySnackBar(context, res);
    setState(() {
      isFollowing = false;
      followers--;
    });
  }

  void signOut() async {
    String res = await AuthMethods().signOut();
    if (res == "success") {
      mySnackBar(context, "Signed Out");
    } else {
      mySnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor:
                                const Color.fromARGB(255, 65, 65, 65),
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['username'],
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? InkWell(
                                  onTap: signOut,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: blueColor,
                                      border: Border.all(
                                        color: primaryColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "Sign Out",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                              : isFollowing
                                  ? InkWell(
                                      onTap: onUnFollowTap,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          "Following",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: onFollowTap,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                          const SizedBox(width: 6),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildStatColumn(postLength, "Posts"),
                          buildStatColumn(followers, "Follwers"),
                          buildStatColumn(following, "Following"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.92,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 15, 15, 15),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 55, 55, 55),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            userData['bio'],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(58, 255, 255, 255),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Text("No posts avaiable"),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 1,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              DocumentSnapshot snap =
                                  snapshot.data!.docs[index];
                              return Image(
                                image: NetworkImage(
                                  snap['postUrl'],
                                ),
                                fit: BoxFit.cover,
                              );
                            }),
                          );
                  },
                ),
              ],
            ),
    );
  }
}
