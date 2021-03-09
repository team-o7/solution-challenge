import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
admin.firestore().settings({ ignoreUndefinedProperties: true });

const titleColors = [
  "0xffef5350",
  "0xffec407a",
  "0xffab47bc",
  "0xff039be5",
  "0xff43a047",
  "0xffc0ca33",
  "0xffff8f00",
];

/**
 * max excluded
 */
function getRndInteger(min, max) {
  return Math.floor(Math.random() * (max - min)) + min;
}

/**
 * substrings
 */
function getAllSubstrings(str: string) {
  const allSubstrings = [];
  const start = 0;
  const val = str.toLowerCase();
  for (let i = 0; i <= str.length; i++) {
    allSubstrings.push(val.substring(start, i));
  }
  return allSubstrings;
}

export const onUserCreate = functions.firestore
  .document("/users/{userId}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();
    const firstName = data.firstName;
    const lastName = data.lastName;
    const userName = data.userName;

    const subStrings = getAllSubstrings(firstName);
    const lastNamess = getAllSubstrings(lastName);
    const userNamess = getAllSubstrings(userName);

    lastNamess.forEach((element) => {
      subStrings.push(element);
    });

    userNamess.forEach((element) => {
      subStrings.push(element);
    });

    snapshot.ref.update({
      searchKey: subStrings,
    });
  });

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

    const title = snap.data().title;

    snap.ref.update({
      searchKey: getAllSubstrings(title),
    });

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

    if (myUid === otherUid) {
      nogo = true;
      status = "You can't add yourself as your friend 🤷‍♀️";
    }

    myFriends.forEach((element) => {
      if (element === otherUid) {
        status = "Already Friends ✌";
        nogo = true;
      }
    });

    myFriendRequest.forEach((element) => {
      if (element === otherUid) {
        status = "You Already have his request 😎";
        nogo = true;
      }
    });

    friendRequestSent.forEach((element) => {
      if (element === otherUid) {
        status = "You have already sent request 😁";
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

      status = "Request sent succesfully 😍";
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
        status = "Already Friends 🤷‍♀️";
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
      status = "Added friends Succesfully 😍";
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
        status = "Already Friends 🤷‍♀️";
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
      status = "Deleted friend request 🤣";
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
    const peoples = topic.data().peoples;

    peoples.forEach((element) => {
      if (element === uid) {
        status = "You are already in the topic 🤷‍♀️";
        nogo = true;
      }
    });

    if (!nogo) {
      await topic.ref.update({
        peoples: admin.firestore.FieldValue.arrayUnion(uid),
      });
      await topic.ref.collection("peoples").add({
        uid: uid,
        access: "general",
        rating: 0.0,
        "push notification": true,
        color: titleColors[getRndInteger(0, 7)],
      });

      const suggestionhannel = await topic.ref
        .collection("privateChannels")
        .where("title", "==", "Suggestion")
        .get();

      await suggestionhannel.docs[0].ref.update({
        peoples: admin.firestore.FieldValue.arrayUnion(uid),
      });

      await suggestionhannel.docs[0].ref.collection("peoples").add({
        uid: uid,
        access: "readwrite",
      });

      status = "Added topic succesfully 😍";
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

    requests.forEach((element) => {
      if (element === uid) {
        status = "You have already requested 👀";
        nogo = true;
      }
    });

    peoples.forEach((element) => {
      if (element === uid) {
        status = "You are already in the topic 🤦‍♀️";
        nogo = true;
      }
    });

    if (!nogo) {
      await topic.ref.update({
        requests: admin.firestore.FieldValue.arrayUnion(uid),
      });
      status = "Request sent succesfully 😍";
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

  const peoples = topic.data().peoples;

  peoples.forEach((element) => {
    if (element === useruid) {
      status = "He is already in the topic 🤷‍♀️";
      nogo = true;
    }
  });

  const acceptor = (
    await topic.ref.collection("peoples").where("uid", "==", Acceptoruid).get()
  ).docs[0].data();

  if (acceptor.access !== "creator" && acceptor.access !== "admin") {
    status = "You don't have access";
    nogo = true;
  }

  if (!nogo) {
    await topic.ref.update({
      requests: admin.firestore.FieldValue.arrayRemove(useruid),
      peoples: admin.firestore.FieldValue.arrayUnion(useruid),
    });

    await topic.ref.collection("peoples").add({
      uid: useruid,
      access: "general",
      rating: 0.0,
      "push notification": true,
      color: titleColors[getRndInteger(0, 7)],
    });

    await topic.ref
      .collection("privateChannels")
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

    status = "Request accepted succesfully 😍";
  }

  return status;
});

export const createPublicChannel = functions.https.onCall(
  async (data, context) => {
    const topicId = data.id;
    const topicTitle = data.title;
    const user = context.auth.uid;
    const firestore = admin.firestore();

    let nogo = false;
    let status = "None";

    const topic = await firestore.collection("topics").doc(topicId).get();

    await topic.ref
      .collection("peoples")
      .where("uid", "==", user)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (
          usersAccess.access !== "creator" &&
          usersAccess.access !== "admin"
        ) {
          status = "You don't have access";
          nogo = true;
        }
      });

    (await topic.ref.collection("publicChannels").get()).docs.forEach(
      (element) => {
        if (element.data().title == topicTitle) {
          status = "Title already exists 🤦‍♀️";
          nogo = true;
        }
      }
    );

    if (!nogo) {
      await topic.ref.collection("publicChannels").add({
        title: topicTitle,
      });
      status = "Created channel succesfully 😍";
    }

    return status;
  }
);

export const makeAdmin = functions.https.onCall(async (data, context) => {
  const otherGuy = data.uid;
  const topicid = data.topic;
  const me = context.auth.uid;
  const firestore = admin.firestore();

  let nogo = false;
  let status = "None";

  const topic = await firestore.collection("topics").doc(topicid).get();

  await topic.ref
    .collection("peoples")
    .where("uid", "==", me)
    .get()
    .then((value) => {
      const usersAccess = value.docs[0].data();
      if (usersAccess.access !== "creator" && usersAccess.access !== "admin") {
        status = "You don't have access";
        nogo = true;
      }
    });

  if (!nogo) {
    await topic.ref
      .collection("peoples")
      .where("uid", "==", otherGuy)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (
          usersAccess.access === "creator" ||
          usersAccess.access === "admin"
        ) {
          status = "Already admin";
        } else {
          value.docs[0].ref.update({
            access: "admin",
          });
          status = "Update succesfull";
        }
      });
  }

  return status;
});

export const removeFromAdmin = functions.https.onCall(async (data, context) => {
  const otherGuy = data.uid;
  const topicid = data.topic;
  const me = context.auth.uid;
  const firestore = admin.firestore();

  let nogo = false;
  let status = "None";

  const topic = await firestore.collection("topics").doc(topicid).get();

  await topic.ref
    .collection("peoples")
    .where("uid", "==", me)
    .get()
    .then((value) => {
      const usersAccess = value.docs[0].data();
      if (usersAccess.access !== "creator" && usersAccess.access !== "admin") {
        status = "You don't have access";
        nogo = true;
      }
    });

  if (!nogo) {
    await topic.ref
      .collection("peoples")
      .where("uid", "==", otherGuy)
      .get()
      .then((value) => {
        if (value.docs[0].data().access === "creator") {
          status = "You can't remove creator";
        } else {
          value.docs[0].ref.update({
            access: "general",
          });
          status = "Update succesfull";
        }
      });
  }

  return status;
});

export const kickFromTopic = functions.https.onCall(async (data, context) => {
  const otherGuy = data.uid;
  const topicid = data.topic;
  const me = context.auth.uid;
  const firestore = admin.firestore();

  let nogo = false;
  let status = "None";

  const topic = await firestore.collection("topics").doc(topicid).get();

  await topic.ref
    .collection("peoples")
    .where("uid", "==", me)
    .get()
    .then((value) => {
      const usersAccess = value.docs[0].data();
      if (usersAccess.access !== "creator") {
        status = "You don't have access";
        nogo = true;
      }
    });

  if (me === otherGuy) {
    nogo = true;
    status = "You can't remove yourself 🤦‍♀️";
  }

  if (!nogo) {
    await topic.ref.update({
      peoples: admin.firestore.FieldValue.arrayRemove(otherGuy),
    });
    await topic.ref
      .collection("peoples")
      .where("uid", "==", otherGuy)
      .get()
      .then((value) => {
        value.docs[0].ref.delete();
      });

    await topic.ref
      .collection("privateChannels")
      .where("peoples", "array-contains", otherGuy)
      .get()
      .then((value) => {
        value.docs.forEach((element) => {
          element.ref.update({
            peoples: admin.firestore.FieldValue.arrayRemove(otherGuy),
          });
          element.ref
            .collection("peoples")
            .where("uid", "==", otherGuy)
            .get()
            .then((value) => {
              value.docs[0].ref.delete();
            });
        });
      });

    status = "Removed succesfully";
  }

  return status;
});

export const leaveTopic = functions.https.onCall(async (data, context) => {
  const topicid = data.topic;
  const me = context.auth.uid;
  const firestore = admin.firestore();

  let nogo = false;
  let status = "None";

  const topic = await firestore.collection("topics").doc(topicid).get();

  await topic.ref
    .collection("peoples")
    .where("uid", "==", me)
    .get()
    .then((value) => {
      const usersAccess = value.docs[0].data();
      if (usersAccess.access === "creator") {
        status = "Creator can't leave 🤔";
        nogo = true;
      }
    });

  if (!nogo) {
    await topic.ref.update({
      peoples: admin.firestore.FieldValue.arrayRemove(me),
    });
    await topic.ref
      .collection("peoples")
      .where("uid", "==", me)
      .get()
      .then((value) => {
        value.docs[0].ref.delete();
      });

    await topic.ref
      .collection("privateChannels")
      .where("peoples", "array-contains", me)
      .get()
      .then((value) => {
        value.docs.forEach((element) => {
          element.ref.update({
            peoples: admin.firestore.FieldValue.arrayRemove(me),
          });
          element.ref
            .collection("peoples")
            .where("uid", "==", me)
            .get()
            .then((value) => {
              value.docs[0].ref.delete();
            });
        });
      });

    status = "Left topic succesfully 🤔";
  }

  return status;
});

export const rate = functions.https.onCall(async (data, context) => {
  const topicid = data.topic;
  const rating = data.rating;
  const me = context.auth.uid;
  const firestore = admin.firestore();

  const topic = await firestore.collection("topics").doc(topicid).get();

  await topic.ref
    .collection("peoples")
    .where("uid", "==", me)
    .get()
    .then((value) => {
      value.docs[0].ref.update({
        rating: rating,
      });
    });

  let newRating = 0.0;

  await topic.ref
    .collection("peoples")
    .get()
    .then((value) => {
      value.docs.forEach((element) => {
        newRating += element.data().rating;
      });
      newRating = newRating / value.docs.length;
    });

  await topic.ref.update({
    avgRating: newRating,
  });

  return "Rated succesfully";
});

export const createPrivateChannel = functions.https.onCall(
  async (data, context) => {
    const topicId = data.id;
    const topicTitle = data.title;
    const user = context.auth.uid;
    const firestore = admin.firestore();

    let nogo = false;
    let status = "None";

    const topic = await firestore.collection("topics").doc(topicId).get();

    await topic.ref
      .collection("peoples")
      .where("uid", "==", user)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (
          usersAccess.access !== "creator" &&
          usersAccess.access !== "admin"
        ) {
          status = "You don't have access";
          nogo = true;
        }
      });

    (await topic.ref.collection("privateChannels").get()).docs.forEach(
      (element) => {
        if (element.data().title == topicTitle) {
          status = "Title already exists 🤦‍♀️";
          nogo = true;
        }
      }
    );

    if (!nogo) {
      await topic.ref
        .collection("privateChannels")
        .add({
          title: topicTitle,
          peoples: [user],
        })
        .then((newDoc) => {
          newDoc.collection("peoples").add({
            access: "readwrite",
            uid: user,
          });
        });
      status = "Created channel succesfully 😍";
    }

    return status;
  }
);

export const addInPrivaateChannel = functions.https.onCall(
  async (data, context) => {
    const topicId = data.topic;
    const channelId = data.channel;
    const person: string = data.person;
    const access: string = data.access;
    const user = context.auth.uid;
    const firestore = admin.firestore();

    let nogo = false;
    let status = "None";

    const topic = await firestore.collection("topics").doc(topicId).get();

    await topic.ref
      .collection("peoples")
      .where("uid", "==", user)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (
          usersAccess.access !== "creator" &&
          usersAccess.access !== "admin"
        ) {
          status = "You don't have access";
          nogo = true;
        }
      });

    const channel = await firestore
      .collection("topics")
      .doc(topicId)
      .collection("privateChannels")
      .doc(channelId)
      .get();
    const ps: Array<string> = channel.data().peoples;
    ps.forEach((element) => {
      if (element === person) {
        status = "Already exists";
        nogo = true;
      }
    });

    if (!nogo) {
      await channel.ref.update({
        peoples: admin.firestore.FieldValue.arrayUnion(person),
      });
      await channel.ref.collection("peoples").add({
        access: access,
        uid: person,
      });

      status = "Added succesfully 😍";
    }

    return status;
  }
);

export const removeFromPrivaateChannel = functions.https.onCall(
  async (data, context) => {
    const topicId = data.topic;
    const channelId = data.channel;
    const person: string = data.person;
    const user = context.auth.uid;
    const firestore = admin.firestore();

    let nogo = false;
    let status = "None";

    const topic = await firestore.collection("topics").doc(topicId).get();

    await topic.ref
      .collection("peoples")
      .where("uid", "==", user)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (
          usersAccess.access !== "creator" &&
          usersAccess.access !== "admin"
        ) {
          status = "You don't have access";
          nogo = true;
        }
      });

    await topic.ref
      .collection("peoples")
      .where("uid", "==", person)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (usersAccess.access === "creator") {
          status = "You can't remove creator";
          nogo = true;
        }
      });

    if (!nogo) {
      const channel = await firestore
        .collection("topics")
        .doc(topicId)
        .collection("privateChannels")
        .doc(channelId)
        .get();

      await channel.ref.update({
        peoples: admin.firestore.FieldValue.arrayRemove(person),
      });
      await channel.ref
        .collection("peoples")
        .where("uid", "==", person)
        .get()
        .then((elements) => {
          elements.docs[0].ref.delete();
        });

      status = "Removed succesfully 😂";
    }

    return status;
  }
);

export const updateAccessInPrivaateChannel = functions.https.onCall(
  async (data, context) => {
    const topicId = data.topic;
    const channelId = data.channel;
    const access = data.access;
    const person: string = data.person;
    const user = context.auth.uid;
    const firestore = admin.firestore();

    let nogo = false;
    let status = "None";

    const topic = await firestore.collection("topics").doc(topicId).get();

    await topic.ref
      .collection("peoples")
      .where("uid", "==", user)
      .get()
      .then((value) => {
        const usersAccess = value.docs[0].data();
        if (
          usersAccess.access !== "creator" &&
          usersAccess.access !== "admin"
        ) {
          status = "You don't have access";
          nogo = true;
        }
      });

    if (!nogo) {
      const channel = await firestore
        .collection("topics")
        .doc(topicId)
        .collection("privateChannels")
        .doc(channelId)
        .get();

      await channel.ref
        .collection("peoples")
        .where("uid", "==", person)
        .get()
        .then((elements) => {
          elements.docs[0].ref.update({
            access: access === "readwrite" ? "readonly" : "readwrite",
          });
        });

      status = "Updated succesfully";
    }

    return status;
  }
);
