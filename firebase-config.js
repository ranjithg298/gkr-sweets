// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import {
    getAuth,
    createUserWithEmailAndPassword,
    signInWithEmailAndPassword,
    signInWithPopup,
    GoogleAuthProvider,
    onAuthStateChanged,
    signOut
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import { getStorage } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-storage.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyD7cfZzjEk9oXvjIEEtk_hhw_5B0Y9GVzE",
    authDomain: "gkr-sweets.firebaseapp.com",
    projectId: "gkr-sweets",
    storageBucket: "gkr-sweets.firebasestorage.app",
    messagingSenderId: "296999115012",
    appId: "1:296999115012:web:04ad15ed7733ac2a5dd851",
    measurementId: "G-BZ8CM0LFWV"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth(app);
const googleProvider = new GoogleAuthProvider();
const storage = getStorage(app);
const db = getFirestore(app);

// Export for use in other files
export {
    app,
    analytics,
    auth,
    googleProvider,
    storage,
    db,
    createUserWithEmailAndPassword,
    signInWithEmailAndPassword,
    signInWithPopup,
    onAuthStateChanged,
    signOut
};

// Auth state observer
onAuthStateChanged(auth, (user) => {
    if (user) {
        console.log('User is signed in:', user.email);
        // Update UI for logged-in user
        updateUIForLoggedInUser(user);
    } else {
        console.log('User is signed out');
        // Update UI for logged-out user
        updateUIForLoggedOutUser();
    }
});

function updateUIForLoggedInUser(user) {
    // Update navigation to show user info
    const accountLink = document.querySelector('a[href*="account"]');
    if (accountLink) {
        accountLink.textContent = user.email.split('@')[0];
    }

    // Show logout button
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.style.display = 'block';
    }
}

function updateUIForLoggedOutUser() {
    const accountLink = document.querySelector('a[href*="account"]');
    if (accountLink) {
        accountLink.textContent = 'My account';
    }

    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.style.display = 'none';
    }
}
