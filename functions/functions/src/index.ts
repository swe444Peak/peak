import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

export const sendToDevice = functions.firestore.document('Invitation/{Invitation}').onCreate(async snapshot => {


  const invit = snapshot.data();

  const querySnapshot = await db
    .collection('users')
    .doc(invit.receiverId)
    .collection('tokens')
    .get();

  const tokens = querySnapshot.docs.map(snap => snap.id);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      title: 'Goal invitation !!',
      body: `you are invited to  ${invit.goalName} goal GO chick it UP!!`,
      icon: 'your-icon-url',
      click_action: 'FLUTTER_NOTIFICATION_CLICK'
    }
  };

  return fcm.sendToDevice(tokens, payload);
});
