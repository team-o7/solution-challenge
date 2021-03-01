import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
admin.firestore().settings({ignoreUndefinedProperties: true});

export const onTopicCreate = functions.firestore
  .document("/topics/{topicId}")
  .onCreate(async (snap, context) => {
    // Grab the current value of what was written to Firestore.
    const original = snap.data();
    // const topicId = context.params.topicId;
    const creator = original.creator;
    const d = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", creator)
      .get();
    // const s = original.id;

    d.forEach((doc) => {
      doc.ref.update({
        topics: admin.firestore.FieldValue.arrayUnion(context.params.topicId),
      });
    });
  });

export const onFriendRequesting = functions.https.onCall(
  async (data, context) => {
    const myUid = context.auth.uid;
    const otherUid = data.otherUid;

    console.log(myUid);
    console.log(otherUid);

    const me = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", myUid)
      .get();

    const otherGuy = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", otherUid)
      .get();

    let status = "None";
    let nogo = false;

    const myFriends = me.docs[0].data().friends;
    const myFriendRequest = me.docs[0].data().friendRequestsReceived;
    const friendRequestSent = me.docs[0].data().friendRequestsSent;

    myFriends.forEach((element) => {
      if (element === otherUid) {
        status = "Already Friends";
        nogo = true;
      }
    });

    myFriendRequest.forEach((element) => {
      if (element === otherUid) {
        status = "You Already have his request";
        nogo = true;
      }
    });

    friendRequestSent.forEach((element) => {
      if (element === otherUid) {
        status = "You have already sent request";
        nogo = true;
      }
    });

    if (!nogo) {
      await me.docs[0].ref.update({
        friendRequestsSent: admin.firestore.FieldValue.arrayUnion(otherUid),
      });

      await otherGuy.docs[0].ref.update({
        friendRequestsReceived: admin.firestore.FieldValue.arrayUnion(myUid),
      });

      status = "Request sent succesfully";
      return status;
    } else return status;
  }
);

export const onFriendRequestAccept = functions.https.onCall(
  async (data, context) => {
    const myUid = context.auth.uid;
    const otherUid = data.otherUid;

    console.log(myUid);
    console.log(otherUid);

    const me = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", myUid)
      .get();

    const otherGuy = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", otherUid)
      .get();

    let status = "None";
    let nogo = false;

    const myFriends = me.docs[0].data().friends;

    myFriends.forEach((element) => {
      if (element === otherUid) {
        status = "Already Friends";
        nogo = true;
      }
    });

    if (!nogo) {
      await me.docs[0].ref.update({
        friendRequestsReceived: admin.firestore.FieldValue.arrayRemove(
          otherUid
        ),
        friends: admin.firestore.FieldValue.arrayUnion(otherUid),
      });

      await otherGuy.docs[0].ref.update({
        friendRequestsSent: admin.firestore.FieldValue.arrayRemove(myUid),
        friends: admin.firestore.FieldValue.arrayUnion(myUid),
      });
      status = "Added friends Succesfully";
    }

    if (!nogo) {
      admin
        .firestore()
        .collection("chats")
        .add({
          users: [myUid, otherUid],
          [myUid]: admin.firestore.Timestamp.now(),
          [otherUid]: admin.firestore.Timestamp.now(),
        })
        .then((doc) => {
          doc.collection("users").add({
            uid: myUid,
            lastActive: admin.firestore.Timestamp.now(),
          });
          doc.collection("users").add({
            uid: otherUid,
            lastActive: admin.firestore.Timestamp.now(),
          });
        });
    }

    return status;
  }
);

export const onFriendRequestDecline = functions.https.onCall(
  async (data, context) => {
    const myUid = context.auth.uid;
    const otherUid = data.otherUid;

    console.log(myUid);
    console.log(otherUid);

    const me = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", myUid)
      .get();

    const otherGuy = await admin
      .firestore()
      .collection("users")
      .where("uid", "==", otherUid)
      .get();

    let status = "None";
    let nogo = false;

    const myFriends = me.docs[0].data().friends;

    myFriends.forEach((element) => {
      if (element === otherUid) {
        status = "Already Friends";
        nogo = true;
      }
    });

    if (!nogo) {
      await me.docs[0].ref.update({
        friendRequestsReceived: admin.firestore.FieldValue.arrayRemove(
          otherUid
        ),
      });

      await otherGuy.docs[0].ref.update({
        friendRequestsSent: admin.firestore.FieldValue.arrayRemove(myUid),
      });
      status = "Deleted friend request";
    }
    return status;
  }
);
