// Import the functions you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCrbuZoquVIyDipqmGvqY2nUdxgHCR3D2M",
  authDomain: "complice-app.firebaseapp.com",
  projectId: "complice-app",
  storageBucket: "complice-app.firebasestorage.app",
  messagingSenderId: "800722318058",
  appId: "1:800722318058:web:896185a72d864145779d93",
  measurementId: "G-9HYFK96W93"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);

export { app, analytics };
