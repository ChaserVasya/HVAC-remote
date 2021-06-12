
import {https, logger} from "firebase-functions";
import admin = require("firebase-admin")
import {Role} from "../entities/user";
import {RoleClaimNotExist} from "../throwed/errors";
import {Exception, UnauthorizedAccess} from "../throwed/exceptions";


export const changeRole = https.onCall(
    async (password, context) => {
      try {
        if (!context.auth) throw new UnauthorizedAccess();

        const newRole = await getRoleWithSamePassword(password);
        const uid = context.auth.uid;

        if (newRole) {
          await updateUserDoc(uid, newRole);
          await refreshClaimsWithNewRole(uid, newRole);
          logSuccess(uid, newRole);
          return true;
        } else {
          warnAboutUnsuccess(uid);
          return false;
        }
      } catch (e) {
        if (!(e instanceof Exception)) logger.error(e.code, e.details);
        throw e;
      }
    },
);

async function getRoleWithSamePassword(password: string): Promise<Role | null> {
  const rolesDocList = await admin
      .firestore()
      .collection("roles")
      .listDocuments();


  for (const roleDocRef of rolesDocList) {
    const roleDetails = (await roleDocRef.get()).data()!;
    if (roleDetails.password === password) return roleDocRef.id as Role;
  }

  return null;
}

async function refreshClaimsWithNewRole(uid: string, newRole: string) {
  const customClaims = (await admin.auth().getUser(uid)).customClaims;
  if (!customClaims || !("role" in customClaims)) throw new RoleClaimNotExist();
  customClaims.role = newRole;
  await admin.auth().setCustomUserClaims(uid, customClaims);
}

async function updateUserDoc(uid: string, newRole: string) {
  await admin.firestore().collection("users").doc(uid).update("role", newRole);
}

function warnAboutUnsuccess(uid: string) {
  logger.warn({
    "uid": uid,
    "message": "unsuccessful attempt to change roles",
  });
}

function logSuccess(uid: string, newRole: string) {
  logger.log({
    "uid": uid,
    "role": newRole,
  });
}

