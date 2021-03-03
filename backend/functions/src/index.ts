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

export const onPublicTopicJoinRequest = functions.https.onCall(
  async (data, contex) => {
    const topicId = data.id;
    const uid = contex.auth.uid;
    const firestore = admin.firestore();

    let status = "None";
    let nogo = false;

    const topic = await firestore.collection("topics").doc(topicId).get();
    const user = await firestore
      .collection("users")
      .where("uid", "==", uid)
      .get();
    const peoples = topic.data().peoples;

    peoples.array.forEach((element) => {
      if (element === uid) {
        status = "You are already in the topic";
        nogo = true;
      }
    });

    if (!nogo) {
      topic.ref.update({
        peoples: admin.firestore.FieldValue.arrayUnion(uid),
      });
      topic.ref.collection("users").add({
        "uid": uid,
        "access": "general",
        "rating": 0,
        "push notification": true,
      });

      topic.ref
      .collection("privateChanneels")
      .where("title", "==", "Suggestion")
      .get()
      .then((data) => {
        data.docs[0].ref.update({
          peoples: admin.firestore.FieldValue.arrayUnion(uid),
        });
        data.docs[0].ref.collection("peoples").add({
          uid: uid,
          access: "readwrite",
        });
      });

      user.docs[0].ref.update({
        topics: admin.firestore.FieldValue.arrayUnion(topicId),
      });
      status = "Added topic succesfully";
    }

    return status;
  }
);

export const onPrivateTopicJoinRequest = functions.https.onCall(
  async (data, contex) => {
    const topicId = data.id;
    const uid = contex.auth.uid;
    const firestore = admin.firestore();

    let status = "None";
    let nogo = false;

    const topic = await firestore.collection("topics").doc(topicId).get();
    const peoples = topic.data().peoples;
    const requests = topic.data().requests;

    requests.array.forEach((element) => {
      if (element === uid) {
        status = "You have already requested";
        nogo = true;
      }
    });

    peoples.array.forEach((element) => {
      if (element === uid) {
        status = "You are already in the topic";
        nogo = true;
      }
    });

    if (!nogo) {
      await topic.ref.update({
        requests: admin.firestore.FieldValue.arrayUnion(uid),
      });
      status = "Request sent succesfully";
    }
    return status;
  }
);

export const onRequestAccept = functions.https.onCall(async (data, contex) => {
  const topicId = data.id;
  const useruid = data.useruid;
  const Acceptoruid = contex.auth.uid;
  const firestore = admin.firestore();

  let status = "None";
  let nogo = false;

  const topic = await firestore.collection("topics").doc(topicId).get();

  const user = await firestore
    .collection("users")
    .where("uid", "==", useruid)
    .get();

  const peoples = topic.data().peoples;

  peoples.array.forEach((element) => {
    if (element === useruid) {
      status = "He is already in the topic";
      nogo = true;
    }
  });

  const acceptor = await (
    await topic.ref.collection("peoples").where("uid", "==", Acceptoruid).get()
  ).docs[0].data();

  if (acceptor.access !== "creator" || acceptor.access !== "admin") {
    status = "You don't have access";
    nogo = true;
  }

  if (!nogo) {
    topic.ref.update({
      requests: admin.firestore.FieldValue.arrayRemove(useruid),
      peoples: admin.firestore.FieldValue.arrayUnion(useruid),
    });

    topic.ref.collection("peoples").add({
      "uid": useruid,
      "access": "general",
      "rating": 0,
      "push notification": true,
    });

    topic.ref
      .collection("privateChanneels")
      .where("title", "==", "Suggestion")
      .get()
      .then((data) => {
        data.docs[0].ref.update({
          peoples: admin.firestore.FieldValue.arrayUnion(useruid),
        });
        data.docs[0].ref.collection("peoples").add({
          uid: useruid,
          access: "readwrite",
        });
      });

    user.docs[0].ref.update({
      topics: admin.firestore.FieldValue.arrayUnion(topicId),

    });
    status = "Request accepted succesfully";
  }

  return status;
});
