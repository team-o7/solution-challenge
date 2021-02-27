import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
admin.firestore().settings({ ignoreUndefinedProperties: true });

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
