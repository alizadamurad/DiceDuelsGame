import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:project_1/Controllers/AuthController/auth_controller.dart';
import 'package:project_1/FriendsPage/components.dart';
import 'package:project_1/services/friend_request_service.dart';
import 'package:country_flags/country_flags.dart';

class MyFriendRequests extends StatefulWidget {
  const MyFriendRequests({super.key});

  @override
  State<MyFriendRequests> createState() => _MyFriendRequestsState();
}

class _MyFriendRequestsState extends State<MyFriendRequests>
    with TickerProviderStateMixin {
  AuthController authController = Get.find<AuthController>();

  Future<void> setAllRequestsAsSeen() async {
    final userId = authController.user?.uid;
    if (userId != null) {
      final batch = FirebaseFirestore.instance.batch();
      final ownRequests = await FirebaseFirestore.instance
          .collection('requests')
          .doc(userId)
          .collection('friendRequests')
          .where('seen', isEqualTo: false)
          .get();

      for (final doc in ownRequests.docs) {
        final ref = doc.reference;
        batch.update(ref, {'seen': true});
      }

      await batch.commit();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    setAllRequestsAsSeen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FriendRequestService friendRequestService = FriendRequestService();

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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: const SizedBox(),
            centerTitle: false,
            title: Text(
              "My Friend Requests",
              style: GoogleFonts.pressStart2p(fontSize: 15),
            ),
            backgroundColor: Colors.transparent,
          ),
          body: StreamBuilder<List<Map<String, dynamic>>>(
            stream: friendRequestService.getSentRequestsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No sent friend requests',
                    style: GoogleFonts.pressStart2p(),
                  ),
                );
              } else {
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final request = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        height: 300,
                        width: 200,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(5, 5),
                              blurRadius: 8,
                              color: Color(0xff52796f),
                              blurStyle: BlurStyle.normal,
                            ),
                          ],
                          color: const Color(0xff354f52),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  UserProfilePhoto(
                                    color: Colors.red,
                                    size: 135,
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 25,
                                    // bottom: 60,
                                    child: CountryFlag.fromCountryCode(
                                      '${request['country_code']}',
                                      height: 20,
                                      width: 20,
                                      borderRadius: 5,
                                    ),
                                  ),
                                  // Positioned(
                                  //     bottom: -8,
                                  //     right: 75,
                                  //     child: CircleAvatar(
                                  //       radius: 18,
                                  //       child: Center(
                                  //         child: Text(
                                  //           request['level'].toString(),
                                  //           style: GoogleFonts.pressStart2p(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 10,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ))
                                ],
                              )
                                  .animate(
                                onPlay: (controller) => controller.repeat(),
                              )
                                  .shimmer(
                                      delay: const Duration(seconds: 5),
                                      duration: const Duration(seconds: 3),
                                      angle: 1,
                                      size: 3,
                                      colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.6),
                                    Colors.purple[300]!.withOpacity(0.3),
                                    const Color(0xFFFFD700).withOpacity(0.3),
                                    Colors.white.withOpacity(0.6),
                                    Colors.purple[300]!.withOpacity(0.3),
                                    Colors.transparent,
                                  ]),
                              // .flip(
                              //   begin: 0,
                              //   end: 2,
                              //   direction: Axis.horizontal,
                              // )
                              // .animate(
                              //   autoPlay: true,
                              // ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                request['username'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.pressStart2p(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            ConfirmOrRejectButton(
                              currentUserUid: authController.user!.uid,
                              friendUid: request['id'],
                            ),
                            const Spacer()
                          ],
                        ),
                      ),
                    );
                    // Padding(
                    //   padding: const EdgeInsets.all(5),
                    //   child: Stack(
                    //     clipBehavior: Clip.none,
                    //     children: [
                    //       Card(
                    //         elevation: 0,
                    //         color: Colors.white,
                    //         child: ListTile(
                    //           trailing: GestureDetector(
                    //             onTap: () {
                    //               // isTapped.value = !isTapped.value;
                    //             },
                    //             child: Obx(
                    //               () => Container(
                    //                 height: 40,
                    //                 width: 40,
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   color: Colors.green[200],
                    //                 ),
                    //                 child: IconButton(
                    //                   icon: AnimatedSwitcher(
                    //                       duration:
                    //                           const Duration(milliseconds: 250),
                    //                       transitionBuilder: (child, anim) =>
                    //                           RotationTransition(
                    //                             turns: child.key ==
                    //                                     const ValueKey('icon2')
                    //                                 ? Tween<double>(
                    //                                         begin: 1, end: 0)
                    //                                     .animate(anim)
                    //                                 : Tween<double>(
                    //                                         begin: 0, end: 1)
                    //                                     .animate(anim),
                    //                             child: ScaleTransition(
                    //                               scale: anim,
                    //                               // opacity: anim,
                    //                               child: child,
                    //                             ),
                    //                           ),
                    //                       child: _currIndex.value == 0
                    //                           ? const Icon(
                    //                               Icons.person_add,
                    //                               key: ValueKey('icon1'),
                    //                             )
                    //                           : const Icon(
                    //                               Icons.done,
                    //                               key: ValueKey('icon2'),
                    //                             )),
                    //                   onPressed: () {
                    //                     _currIndex.value =
                    //                         _currIndex.value == 0 ? 1 : 0;
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           // subtitle: Text(request['status'] ?? "null"),
                    //           title: Text(
                    //             request['username'],
                    //             style: GoogleFonts.pressStart2p(),
                    //           ),
                    //           // You can display additional information here
                    //         ),
                    //       ),

                    //     ],
                    //   ),
                    // );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
