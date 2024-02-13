import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:project_1/services/friend_request_service.dart';

class AddFriendButton extends StatelessWidget {
  final bool isFriendRequested;
  final String friendName;
  const AddFriendButton({
    super.key,
    required this.isFriendRequested,
    required this.friendName,
  });

  @override
  Widget build(BuildContext context) {
    FriendRequestService friendRequestService = FriendRequestService();

    RxBool clicked = isFriendRequested ? RxBool(true) : RxBool(false);
    return Obx(
      () => IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: child.key == const ValueKey('done')
                ? Tween<double>(begin: 1, end: 0).animate(anim)
                : Tween<double>(begin: 0, end: 1).animate(anim),
            child: ScaleTransition(
              scale: anim,
              // opacity: anim,
              child: child,
            ),
          ),
          child: clicked.value == false
              ? const Icon(
                  Icons.person_add,
                  key: ValueKey('add'),
                )
              : const Icon(
                  Icons.done,
                  key: ValueKey('done'),
                ),
        ),
        onPressed: clicked.value
            ? () {
                print("ALREADY SENT");
              }
            : () {
                print("SENDING REQUEST TO ${friendName}");
                friendRequestService.processFriendRequest(friendName);
                clicked.value = true;
                print(clicked);
              },
      ),
    );
  }
}

class UserProfilePhoto extends StatelessWidget {
  UserProfilePhoto({
    required this.size,
    required this.color,
    super.key,
  });
  Color color;
  double size;

  @override
  Widget build(BuildContext context) {
    return HexagonWidget.pointy(
      elevation: 4,
      color: const Color(0xFFFFD700),
      cornerRadius: 30,
      height: size, //135
      width: size,
      child: HexagonWidget.pointy(
        cornerRadius: 25,
        color: color,
        height: size - 12, //120
        width: size - 12,
        child: Transform.rotate(
          angle: 0.5,
          child: Image.asset(
            "assets/images/dicenew.png",
            height: size - 55, //80
            width: size - 55,
          ),
        ),
      ),
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
      ],
    );
  }
}

class ConfirmOrRejectButton extends StatelessWidget {
  const ConfirmOrRejectButton(
      {super.key, required this.currentUserUid, required this.friendUid});
  final String currentUserUid;
  final String friendUid;

  @override
  Widget build(BuildContext context) {
    FriendRequestService friendRequestService = FriendRequestService();
    RxBool isRejectClicked = RxBool(false);
    RxBool isAcceptClicked = RxBool(false);
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isAcceptClicked.value || isRejectClicked.value
            ? Text(
                isAcceptClicked.value ? "Accepted" : "Rejected",
                style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: isAcceptClicked.value ? Colors.green : Colors.red),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 15,
                      ),
                      onPressed: () async {
                        //REJECT
                        isRejectClicked.value = true;
                        await Future.delayed(const Duration(seconds: 1));
                        await friendRequestService.rejectFriendRequest(
                            currentUserUid, friendUid);
                      },
                      child: const Center(
                        child: Icon(
                          PixelArtIcons.user_minus,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 15,
                      ),
                      onPressed: () async {
                        isAcceptClicked.value = true;
                        await Future.delayed(const Duration(seconds: 1));
                        await friendRequestService.acceptFriendRequest(
                            currentUserUid, friendUid);
                      },
                      child: const Center(
                        child: Icon(
                          PixelArtIcons.user_plus,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
