import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
    const db = admin.firestore();
    const fcm = admin.messaging();






export const sendToDevice = functions.firestore.document('invations/{invationsId}')
.onCreate(async snapshot => {
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
      body: `Wooah someone invited you to ${invit.goalName} goal GO CHECK IT OUT`,
      icon: 'mipmap/ic_launcher',
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
    },
  };
  console.log('im before sending notification');
  console.log(invit.receiverId);
  return fcm.sendToDevice(tokens, payload);
});
