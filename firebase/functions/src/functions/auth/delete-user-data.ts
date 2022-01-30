import {auth} from "firebase-functions";

import admin from "firebase-admin";

export const deleteUserData = auth.user().onDelete(
  async (user) => {
    await admin.firestore().collection("users").doc(user.uid).delete();
  },
);
