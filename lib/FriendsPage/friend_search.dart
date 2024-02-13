import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_1/Constants/constants.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/FriendsPage/components.dart';
import 'package:project_1/FriendsPage/my_requests.dart';
import 'package:project_1/services/database.dart';

class FriendSearchPage extends StatefulWidget {
  const FriendSearchPage({super.key});

  @override
  State<FriendSearchPage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<FriendSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  RxList<String> searchResults = RxList<String>([]);

  AuthController authController = Get.find<AuthController>();
  DatabaseService databaseService = DatabaseService();
  String? username;
  RxBool searchActive = RxBool(false);

  @override
  void initState() {
    print('SEARCH BUTTON STATUS : $searchActive');
    // username =  databaseService.getUserUsername(authController.user?.uid);
    // fetchUsername();
    super.initState();
  }

  @override
  void dispose() {
    searchActive.value = false;
    super.dispose();
  }
  // Future<void> fetchUsername() async {
  //   final retrievedUsername =
  //       await databaseService.getUserUsername(authController.user?.uid);
  //   setState(() {
  //     username = retrievedUsername;
  //   });
  // }

  void search() async {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final results = await databaseService.searchUsers(query);
      searchResults.value = results;
      searchActive.value = true;
    }
  }

  Future<List<String>> getSentRequestsUsernames(String? userId) async {
    final ownRequestsSnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .doc(userId)
        .collection('ownRequests')
        .get();

    final List<String> usernames = [];

    for (final doc in ownRequestsSnapshot.docs) {
      final receiverUid = doc.id;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .get();
      final username = userData['username'] as String?;
      if (username != null) {
        usernames.add(username);
      }
    }

    return usernames;
  }

  Stream<int> streamUnseenRequests(String? userId) {
    return FirebaseFirestore.instance
        .collection('requests')
        .doc(userId)
        .collection('friendRequests')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      int unseenCount = 0;
      snapshot.docs.forEach((doc) {
        final seen = doc['seen'] ?? false; // assuming 'seen' is a boolean field
        if (!seen) {
          unseenCount++;
        }
      });
      return unseenCount;
    });
  }

  // RxInt _currIndex = RxInt(0);

  @override
  Widget build(BuildContext context) {
    print("WIDGET REBUILD");
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // stops: [0.5, 0.5],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
              colors: [
                Color(0xffa3c1ad),
                Color(0xffe3ece6),
              ],
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "${authController.user?.displayName}",
              style: GoogleFonts.pressStart2p(fontSize: 18),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  style: GoogleFonts.pressStart2p(),
                  controller: _searchController,
                  decoration: customInputDecoration(
                    iconBtn: IconButton(
                      onPressed: search,
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 70,
                      width: Get.width * 0.85,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () => Get.to(() => const MyFriendRequests()),
                        child: Text(
                          "Friend Requests",
                          style: GoogleFonts.pressStart2p(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                    StreamBuilder<int>(
                      stream: streamUnseenRequests(authController.user?.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int unseenRequestsCount = snapshot.data ?? 0;
                          if (unseenRequestsCount > 0) {
                            return Positioned(
                              right: -7,
                              top: -7,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.red,
                                ),
                                constraints: const BoxConstraints(
                                    minHeight: 20, minWidth: 20),
                                child: Center(
                                  child: Text(
                                    unseenRequestsCount.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.pressStart2p(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }
                      },
                    )
                  ],
                ),
              ),
              Obx(
                () => Container(
                  child: searchActive.value && searchResults.isNotEmpty
                      ? FutureBuilder<List<String>>(
                          future: getSentRequestsUsernames(
                              authController.user?.uid),
                          builder: (context, snapshot) {
                            print("FUTURE BUILDER");
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              print("FUTURE WAITING");

                              return const Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              print("FUTURE ERROR");

                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              print("FUTURE BUILDED");

                              print(searchActive);
                              final sentRequests = snapshot.data ?? [];
                              print(" SENT REQUESTS $sentRequests");
                              // print("USERNAME : $username");

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    print(
                                        " SEARCH RESULTS ${searchResults[index]}");
                                    username = searchResults[index];

                                    // final username = snapshot.data?[index];
                                    final isFriendRequested =
                                        sentRequests.contains(username);
                                    print(isFriendRequested);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: ListTile(
                                          trailing: authController
                                                      .user?.displayName ==
                                                  searchResults[index]
                                              ? Text(
                                                  "You",
                                                  style: GoogleFonts
                                                      .pressStart2p(),
                                                )
                                              : Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.green[200],
                                                  ),
                                                  child: AddFriendButton(
                                                    friendName:
                                                        searchResults[index],
                                                    isFriendRequested:
                                                        isFriendRequested,
                                                  ),
                                                ),
                                          title: Text(
                                            searchResults[index],
                                            style: GoogleFonts.pressStart2p(),
                                          ),
                                          // Add onTap functionality to handle selecting a user from the search results
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        )
                      : searchActive.value
                          ? Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Text(
                                "User not found",
                                style: GoogleFonts.pressStart2p(),
                              ),
                            )
                          : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
