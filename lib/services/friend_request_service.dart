import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_1/services/database.dart';

class FriendRequestService {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseService databaseService = DatabaseService();

  Future<Map<String, dynamic>> getCountryInfoForUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String countryName = userDoc['country'] ?? '';
        String countryCode = userDoc['countryCode'] ?? '';
        int levelinfo = userDoc['level'] ?? 1;

        return {
          'countryName': countryName,
          'countryCode': countryCode,
          'level': levelinfo
        };
      }
    } catch (e) {
      // Handle error
      print('Error Getting Flag info: $e');
    }

    return {'countryName': '', 'countryCode': ''};
  }

  Future<String?> findReceiverUid(String receiverUsername) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await usersRef
        .where('username', isEqualTo: receiverUsername)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
      // final userData = querySnapshot.docs.first.data();

      // return {
      //   'userId': querySnapshot.docs.first.id,
      //   'username': userData['username'],
      //   'countryName': userData['country'],
      //   'countryCode': userData['countryCode'],
      //   // Add other fields if needed
      // };
    }

    return null; // If username doesn't exist or no user found
  }

  Future<void> sendFriendRequest(
      String senderUid,
      String receiverUid,
      String username,
      String? countryFlagCode,
      String? countryName,
      int levelinfo) async {
    final requestsRef = FirebaseFirestore.instance.collection('requests');
    final myUserName = auth.currentUser?.displayName;

    // Update the sender's ownRequests subcollection
    await requestsRef
        .doc(senderUid)
        .collection('ownRequests')
        .doc(receiverUid)
        .set({
      'username': username,
      'status': 'requested', // Add additional data if needed
    });

    // Update the receiver's friendRequests subcollection
    await requestsRef
        .doc(receiverUid)
        .collection('friendRequests')
        .doc(senderUid)
        .set({
      'seen': false,
      'username': myUserName,
      'status': 'requested', // Add additional data if needed
      'country_code': countryFlagCode, // Country Flag code
      'country_name': countryName, // Country Name
      'level': levelinfo,
    });
    // // Update the sender's friend requests list
  }

  Future<void> processFriendRequest(String receiverUsername) async {
    final senderCountryInfo =
        await getCountryInfoForUser(auth.currentUser!.uid);

    final senderCountryName = senderCountryInfo['countryName'];
    final senderCountryCode = senderCountryInfo['countryCode'];
    final senderLevelInfo = senderCountryInfo['level'];

    final receiverUid = await findReceiverUid(receiverUsername);
    if (receiverUid != null) {
      final senderUid = auth.currentUser?.uid;
      if (senderUid != null) {
        await sendFriendRequest(senderUid, receiverUid, receiverUsername,
            senderCountryCode, senderCountryName, senderLevelInfo);
      } else {
        print('Sender UID not found');
      }
    } else {
      print('Receiver UID not found');
    }
  }

  Stream<List<Map<String, dynamic>>> getSentRequestsStream() {
    return FirebaseFirestore.instance
        .collection('requests')
        .doc(auth.currentUser?.uid)
        .collection('friendRequests')
        .where('status', isEqualTo: 'requested')
        .orderBy('seen', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data(); //as Map<String, dynamic>;
              print("DATA $data");
              return {
                'id': doc.id,
                'username': data['username'],
                'status': data['status'],
                'seen': data['seen'],
                'country_code': data['country_code'],
                'country_name': data['country_name'],
                'level': data['level']
                // Add other fields as needed
              };
            }).toList());
  }

  Future<void> acceptFriendRequest(
      String currentUserUid, String friendUid) async {
    final requestsRef = FirebaseFirestore.instance.collection('requests');

    // DOCs path
    final currentUserDoc = requestsRef.doc(currentUserUid);
    final friendDoc = requestsRef.doc(friendUid);

    //Requests path
    final currentUserFriendRequests =
        currentUserDoc.collection('friendRequests');
    final friendOwnRequestsDoc = friendDoc.collection('ownRequests');

    final currentUserOwnRequests = currentUserDoc.collection('ownRequests');
    final friendFriendRequests = friendDoc.collection('friendRequests');

    //Geting documents
    final currentUserRequestDoc =
        await currentUserFriendRequests.doc(friendUid).get();
    final friendRequestDoc =
        await friendOwnRequestsDoc.doc(currentUserUid).get();

    final currentUserSentRequests =
        await currentUserOwnRequests.doc(friendUid).get();
    final friendReceivedRequests =
        await friendFriendRequests.doc(currentUserUid).get();

    if (currentUserRequestDoc.exists && friendRequestDoc.exists) {
      currentUserFriendRequests.doc(friendUid).update({'status': 'accepted'});
      friendOwnRequestsDoc.doc(currentUserUid).update({'status': 'accepted'});

      if (currentUserSentRequests.exists && friendReceivedRequests.exists) {
        currentUserOwnRequests.doc(friendUid).update({'status': 'accepted'});
        friendFriendRequests.doc(currentUserUid).update({'status': 'accepted'});
      }

      final currentUserFriendListDoc =
          await currentUserDoc.collection('friendlist').doc(friendUid).get();

      if (!currentUserFriendListDoc.exists) {
        await currentUserDoc.collection('friendlist').doc(friendUid).set({
          'friendId': friendUid,
          // Add other fields if needed
        });
      }

      final friendFriendListDoc =
          await friendDoc.collection('friendlist').doc(currentUserUid).get();

      if (!friendFriendListDoc.exists) {
        await friendDoc.collection('friendlist').doc(currentUserUid).set({
          'friendId': currentUserUid,
          // Add other fields if needed
        });
      }
    }
  }

  Future<void> rejectFriendRequest(
      String currentUserUid, String friendUid) async {
    final requestsRef = FirebaseFirestore.instance.collection('requests');

    // DOCs path
    final currentUserDoc = requestsRef.doc(currentUserUid);
    final friendDoc = requestsRef.doc(friendUid);

    //Requests path
    final currentUserFriendRequests =
        currentUserDoc.collection('friendRequests');
    final friendOwnRequestsDoc = friendDoc.collection('ownRequests');

    final currentUserOwnRequests = currentUserDoc.collection('ownRequests');
    final friendFriendRequests = friendDoc.collection('friendRequests');

    //Deleting DOCs

    await currentUserFriendRequests.doc(friendUid).delete();
    await friendOwnRequestsDoc.doc(currentUserUid).delete();

    await currentUserOwnRequests.doc(friendUid).delete();
    await friendFriendRequests.doc(currentUserUid).delete();

    //Geting documents
    // final currentUserRequestDoc =
    //     await currentUserFriendRequests.doc(friendUid).get();
    // final friendRequestDoc =
    //     await friendOwnRequestsDoc.doc(currentUserUid).get();

    // final currentUserSentRequests =
    //     await currentUserOwnRequests.doc(friendUid).get();
    // final friendReceivedRequests =
    //     await friendFriendRequests.doc(currentUserUid).get();
  }
}
