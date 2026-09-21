importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.11.0/firebase-messaging-compat.js');

firebase.initializeApp({
    apiKey: 'AIzaSyB4bq_OwA8h_rhF9C6ueHaWZS84Ym62auw',
    authDomain: 'i2c-academy.firebaseapp.com',
    projectId: 'i2c-academy',
    storageBucket: 'i2c-academy.firebasestorage.app',
    messagingSenderId: '209336982411',
    appId: '1:209336982411:web:03a89c747ac38a8b222d8e',
    measurementId: 'G-QS77YXHX0P',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    const title = payload.notification.title || 'New notification';
    const options = {
        body: payload.notification.body || 'You have a new message',
        icon: '/icons/Icon-192.png',
    };

    return self.registration.showNotification(title, options);
});