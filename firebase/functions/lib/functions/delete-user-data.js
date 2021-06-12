"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteUserData = void 0;
const firebase_functions_1 = require("firebase-functions");
const admin = require("firebase-admin");
exports.deleteUserData = firebase_functions_1.auth.user().onDelete(async (user) => {
    await admin.firestore().collection("users").doc(user.uid).delete();
});
//# sourceMappingURL=delete-user-data.js.map