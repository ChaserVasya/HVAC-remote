"use strict";

/* eslint max-len: ["error", { "code": 120 }]*/

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const logger = functions.logger;

class UnauthenticatedError extends Error {
  constructor() {
    super();
    this.name = "UnauthenticatedError";
    this.message = "attempted unauthorized access";
  }
}

const USERS_COLLECTION = "users";
const ROLES_COLLECTION = "roles";
const ROLE_FIELD = "role";
const CUSTOM_CLAIMS_FIELD = "custom_claims";
const UID_FIELD = "uid";
const MESSAGE_FIELD = "message";

const UNSUCCESSFUL_ROLE_CHANGING_WARN = "unsuccessful attempt to change roles";

exports.changeRole = functions.https.onCall(
    async (password, context) => {
      try {
        const roleIsFinded = () => Boolean(role);

        checkForExceptions();

        const role = await getRoleWithSameAuth(password);
        const uid = context.auth.uid;

        if (roleIsFinded()) {
          await admin.firestore().collection(USERS_COLLECTION).doc(uid).update(ROLE_FIELD, role);
          const customClaims = {[ROLE_FIELD]: role};
          await admin.auth().setCustomUserClaims(uid, customClaims);
          const logMessage = {[UID_FIELD]: uid, [CUSTOM_CLAIMS_FIELD]: customClaims};
          logger.log(logMessage);
        } else {
          const logMessage = {[UID_FIELD]: uid, [MESSAGE_FIELD]: UNSUCCESSFUL_ROLE_CHANGING_WARN};
          logger.warn(logMessage);
        }

        return role;
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

async function getRoleWithSameAuth(password) {
  const rolesDocList = await admin.firestore()
      .collection(ROLES_COLLECTION)
      .listDocuments();
  const role = await findRole();
  return role;

  async function findRole() {
    for (const roleDocRef of rolesDocList) {
      const getRoleDetails = async () =>{
        const roleDocSnapshot = await roleDocRef.get();
        return roleDocSnapshot.data();
      };

      const roleDetails = await getRoleDetails();
      if (roleDetails.password === password) return roleDocRef.id;
    }
    return undefined;
  }
}


