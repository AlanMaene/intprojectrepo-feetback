import 'package:feetback/models/jump.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:feetback/services/service_locator.dart';
import 'package:feetback/services/auth_service.dart';

class DatabaseService {
  final AuthService _authService = locator<AuthService>();

  Future<List<Jump>> getAllJumps() async {
    if (await _authService.isUserSignedIn()) {
      try {
        final DatabaseReference ourDB = FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(_authService.currentUser.uid)
            .child("jumps");
        DataSnapshot snap = await ourDB.reference().orderByChild("date").once();

        if (snap != null && snap.value != null) {
          Map<dynamic, dynamic> data = snap.value;

          List<Jump> allJumps = new List<Jump>();
          data.forEach((key, value) {
            allJumps.add(Jump.fromDB(key, value));
          });
          
          return allJumps;
        } else {
          // Return empty list
          return List<Jump>();
        }
        
      } on Exception catch (e) {
        print(e);
      }
    }
    // Return empty list
    return List<Jump>();
  }

  Future<Jump> getHighestJump() async {
    if (await _authService.isUserSignedIn()) {
      try {
        final DatabaseReference ourDB = FirebaseDatabase.instance.reference().child("users").child(_authService.currentUser.uid).child("jumps");
        DataSnapshot snap = await ourDB.orderByChild("height").limitToLast(1).once();

        if (snap != null && snap.value != null) {
          Map<dynamic, dynamic> data = snap.value;
          String highestJumpId = data.keys.first;
          Jump highestJump = Jump.fromDB(highestJumpId, data[highestJumpId]);
          return highestJump;
        } else {
          return null;
        }

      } on Exception catch (e) {
        print(e);
      }
    }
    return null;
  }

  Future<void> addJump(double height, double airtime, bool isFavorite) async {
    if (await _authService.isUserSignedIn()) {
      final DatabaseReference ourDB = FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(_authService.currentUser.uid)
          .child("jumps");
      try {
        String jumpID = ourDB.push().key;
        await ourDB.child(jumpID).set({
          'height': height,
          'date': DateTime.now().toString(),
          'airtime': airtime,
          'favorite': isFavorite,
          'jid': jumpID,
        });  
        print('Add successful');
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  Future<void> addJumpWithJump(Jump jump) async {
      if (await _authService.isUserSignedIn()) {
        final DatabaseReference ourDB = FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(_authService.currentUser.uid)
            .child("jumps");
        try {
          await ourDB.child(jump.jid).set({
            'height': jump.height,
            'date': jump.date.toString(),
            'airtime': jump.airtime,
            'favorite': jump.favorite,
            'jid': jump.jid,
          });  
          print('Add successful');
        } on Exception catch (e) {
          print(e);
        }
      }
    }

  Future<void> addJumpWithDate(DateTime date, double height, double airtime/*, bool isFavorite*/) async {
    if (await _authService.isUserSignedIn()) {
      final DatabaseReference ourDB = FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(_authService.currentUser.uid)
          .child("jumps");
      try {
        String jumpID = ourDB.push().key;
        await ourDB.child(jumpID).set({
          'height': height,
          'date': date.toString(),
          'airtime': airtime,
          'favorite': false,
          'jid': jumpID,
        });  
        print('Add with date successful');
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  Future<void> delJump(String jumpID) async {
    if (await _authService.isUserSignedIn()) {
      final DatabaseReference ourDB = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(_authService.currentUser.uid)
        .child("jumps");

        try {
          await ourDB.child(jumpID).remove();
          print (jumpID.toString() + " is deleted");
        } on Exception catch (e) {
          print (e);
        }
    }
  }

  Future<void> toggleFavorite(String jumpId, bool state) async {
    if (await _authService.isUserSignedIn()) {
      final DatabaseReference ourDB = FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(_authService.currentUser.uid)
          .child("jumps")
          .child(jumpId);
      try {        
        await ourDB.reference().update({'favorite': state});
        print("Toggle favorite of \"$jumpId\" successful");
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  Future<Jump> getJump(String jumpID) async {
    if (await _authService.isUserSignedIn()) {
      try {
        final DatabaseReference ourDB = FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(_authService.currentUser.uid)
          .child("jumps");
        DataSnapshot snap = await ourDB.reference().child(jumpID).once();

        return Jump.fromDB(jumpID, snap.value);
      } on Exception catch (e) {
        print ("Error pulling one jump: $jumpID\n" + e.toString());
      }
    }
  }

  Future<void> addUserToDB(String _uid, String _name) async {
    final DatabaseReference ourDB =
        FirebaseDatabase.instance.reference().child("users");
    try {
      DataSnapshot snap = await ourDB.child(_uid).once();
      if (snap.value == null) {
        await ourDB.reference().child(_uid).set({'GUID': _uid, 'name': _name});
        print("New user added (ID:$_uid)");
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
