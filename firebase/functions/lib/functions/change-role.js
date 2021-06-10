"use strict";

/* eslint max-len: ["error", { "code": 120 }]*/

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const logger = functions.logger;


const constants = require("../constants.js").constants;

const UNSUCCESSFUL_ROLE_CHANGING_WARN = constants.UNSUCCESSFUL_ROLE_CHANGING_WARN;

class UnauthenticatedError extends Error {
  constructor() {
    super();
    this.name = "UnauthenticatedError";
    this.message = "attempted unauthorized access";
  }
}

exports.changeRole = functions.https.onCall(
    async (password, context) => {
      try {
        checkForExceptions();

        const newRole = await getRoleWithSamePassword(password);
        const uid = context.auth.uid;

        if (newRole) {
          await updateUserDoc(uid, newRole);
          await refreshClaimsWithNewRole(uid, newRole);
          logSuccessResult(uid, newRole);
          return true;
        } else {
          warnAboutUnsuccess(uid);
          return false;
        }
      } catch (error) {
        if (error instanceof UnauthenticatedError) {
          logger.error(error.name, error.message);
          throw new functions.https.HttpsError(error.name, error.message);
        } else {
          throw error;
        }
      }

      function checkForExceptions() {
        if (!context.auth) throw new UnauthenticatedError;
      }
    },
);

async function getRoleWithSamePassword(password) {
  const rolesDocList = await admin.firestore()
      .collection("roles")
      .listDocuments();

  const role = await findRole();
  return role;

  async function findRole() {
    for (const roleDocRef of rolesDocList) {
      const getRoleDetails = async () => {
        const roleDocSnapshot = await roleDocRef.get();
        return roleDocSnapshot.data();
      };

      const roleDetails = await getRoleDetails();
      if (roleDetails.password === password) return roleDocRef.id;
    }
    return null;
  }
}


async function refreshClaimsWithNewRole(uid, newRole) {
  const oldCustomClaims = (await admin.auth().getUser(uid)).customClaims;
  oldCustomClaims["role"] = newRole;
  const newCustomClaims = oldCustomClaims;

  await admin.auth().setCustomUserClaims(uid, newCustomClaims);
}

async function updateUserDoc(uid, newRole) {
  await admin.firestore()
      .collection("users")
      .doc(uid)
      .update("role", newRole);
}

function warnAboutUnsuccess(uid) {
  logger.warn({
    "uid": uid,
    "message": UNSUCCESSFUL_ROLE_CHANGING_WARN,
  });
}

function logSuccessResult(uid, newRole) {
  logger.log({
    "uid": uid,
    "role": newRole,
  });
}
