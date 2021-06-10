"use strict";


const admin = require("firebase-admin");
const functions = require("firebase-functions");

exports.deleteUserData = functions.auth.user().onDelete(
    async (user) => {
      await deleteDocWithUserData();
      async function deleteDocWithUserData() {
        await admin.firestore()
            .collection("users")
            .doc(user.uid)
            .delete();
      }
    },
);
