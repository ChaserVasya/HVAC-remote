"use strict";


const admin = require("firebase-admin");
const functions = require("firebase-functions");

const constants = require("../constants.js").constants;

const DEFAULT_ROLE = constants.DEFAULT_ROLE;
const USER_DETAILD_TEMPLATE = constants.USER_DETAILD_TEMPLATE;


exports.createUserDoc = functions.auth.user().onCreate(
    async (user) => {
      const userDetails = createUserDetails();
      await createUserDoc(user.uid, userDetails);
    },
);

async function createUserDoc(uid, userDetails) {
  await admin.firestore()
      .collection("users")
      .doc(uid)
      .create(userDetails);
}

function createUserDetails() {
  const template = USER_DETAILD_TEMPLATE;

  template.createdOn = Date.now();
  template.role = DEFAULT_ROLE;

  return template;
}
