import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rec4trav/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../Models/Post.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('postsFlutter').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('postsFlutter').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('postsFlutter').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('postsFlutter')
            .doc(postId)
            .collection('commentsFlutter')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<Map<String, dynamic>>> getWishlistData(String uid) async {
    List<Map<String, dynamic>> wishlistData = [];
    await FirebaseFirestore.instance
        .collection('wishlistFlutter') // Birinci koleksiyon
        .doc(uid) // Birinci belge
        .collection('placeName') // İkinci koleksiyon // İkinci belge
        .get() // Belgeyi getirir
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
        var temp = documentSnapshot.data() as Map<String, dynamic>;
        wishlistData.add(temp);
      });
    });
    return wishlistData;
  }

  Future<String> addwishlist(String uid, String placename, String placepic,
      double lat, double lng) async {
    String res = "Some error occurred";
    try {
      _firestore
          .collection('wishlistFlutter')
          .doc(uid)
          .collection('placeName')
          .doc(placename)
          .set({
        'profilePic': placepic,
        'name': placename,
        'lat': lat,
        'lng': lng,
        'uid': uid,
        'datePublished': DateTime.now(),
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addrecentplaces(String uid, double lat, double lng) async {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    String res = "Some error occurred";
    try {
      _firestore
          .collection('recentPlacesFlutter')
          .doc(uid)
          .collection('places')
          .doc(id)
          .set({
        'placeName': 'unknown',
        'lat': lat,
        'lng': lng,
        'date': DateTime.now(),
        'id': id
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletewishlist(String uid, String placename) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('wishlistFlutter')
          .doc(uid)
          .collection('placeName')
          .doc(placename)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleterecentplaces(String uid, String id) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('recentPlacesFlutter')
          .doc(uid)
          .collection('places')
          .doc(id)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updaterecentplaces(String uid, String id, String name) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('recentPlacesFlutter')
          .doc(uid)
          .collection('places')
          .doc(id)
          .update({'placeName': name});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('RegUser').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('RegUser').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('RegUser').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('RegUser').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('RegUser').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getRecentPlacesData(String uid) async {
    List<Map<String, dynamic>> wishlistData = [];
    await FirebaseFirestore.instance
        .collection('recentPlacesFlutter') // Birinci koleksiyon
        .doc(uid) // Birinci belge
        .collection('places') // İkinci koleksiyon // İkinci belge
        .get() // Belgeyi getirir
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
        var temp = documentSnapshot.data() as Map<String, dynamic>;
        wishlistData.add(temp);
      });
    });
    return wishlistData;
  }
}
