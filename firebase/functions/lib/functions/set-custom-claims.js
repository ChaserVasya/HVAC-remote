"use strict";


const admin = require("firebase-admin");
const functions = require("firebase-functions");

const USERS_COLLECTION = "users";
const DEFAULT_ROLE = "reader";
const ROLE_FIELD = "role";

const CUSTOM_CLAIMS = {[ROLE_FIELD]: DEFAULT_ROLE};

exports.setCustomClaims = functions.auth.user().onCreate(
    async (user) => {
      await setCustomUserClaims();
      await createDocWithUserData();

      async function createDocWithUserData() {
        const userDetails = {
          role: DEFAULT_ROLE,
          createdOn: Date.now(),
        };
        await admin.firestore()
            .collection(USERS_COLLECTION)
            .doc(user.uid)
            .create(userDetails);
      }

      async function setCustomUserClaims() {
        await admin.auth().setCustomUserClaims(user.uid, CUSTOM_CLAIMS);
      }
    },
);
