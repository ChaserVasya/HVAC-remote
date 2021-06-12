"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.changeRole = void 0;
const firebase_functions_1 = require("firebase-functions");
const admin = require("firebase-admin");
const errors_1 = require("../throwed/errors");
const exceptions_1 = require("../throwed/exceptions");
exports.changeRole = firebase_functions_1.https.onCall(async (password, context) => {
    try {
        if (!context.auth)
            throw new exceptions_1.UnauthorizedAccess();
        const newRole = await getRoleWithSamePassword(password);
        const uid = context.auth.uid;
        if (newRole) {
            await updateUserDoc(uid, newRole);
            await refreshClaimsWithNewRole(uid, newRole);
            logSuccess(uid, newRole);
            return true;
        }
        else {
            warnAboutUnsuccess(uid);
            return false;
        }
    }
    catch (e) {
        if (!(e instanceof exceptions_1.Exception))
            firebase_functions_1.logger.error(e.code, e.details);
        throw e;
    }
});
async function getRoleWithSamePassword(password) {
    const rolesDocList = await admin
        .firestore()
        .collection("roles")
        .listDocuments();
    for (const roleDocRef of rolesDocList) {
        const roleDetails = (await roleDocRef.get()).data();
        if (roleDetails.password === password)
            return roleDocRef.id;
    }
    return null;
}
async function refreshClaimsWithNewRole(uid, newRole) {
    const customClaims = (await admin.auth().getUser(uid)).customClaims;
    if (!customClaims || !("role" in customClaims))
        throw new errors_1.RoleClaimNotExist();
    customClaims.role = newRole;
    await admin.auth().setCustomUserClaims(uid, customClaims);
}
async function updateUserDoc(uid, newRole) {
    await admin.firestore().collection("users").doc(uid).update("role", newRole);
}
function warnAboutUnsuccess(uid) {
    firebase_functions_1.logger.warn({
        "uid": uid,
        "message": "unsuccessful attempt to change roles",
    });
}
function logSuccess(uid, newRole) {
    firebase_functions_1.logger.log({
        "uid": uid,
        "role": newRole,
    });
}
//# sourceMappingURL=change-role.js.map