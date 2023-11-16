importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
    apiKey: "AIzaSyB5klb6cyMOCKPemp8cAIAvMibjbTqEUuk",
    authDomain: "kirk-9aadd.firebaseapp.com",
    projectId: "kirk-9aadd",
    storageBucket: "kirk-9aadd.appspot.com",
    messagingSenderId: "140101484711",
    appId: "1:140101484711:web:e85b360ded6fc356755b82",
    measurementId: "G-QEDT486EGC"
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });