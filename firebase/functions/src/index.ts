import admin from "firebase-admin";
admin.initializeApp();

export {changeRole} from "./functions/auth/change-role.js";
export {deleteUserData} from "./functions/auth/delete-user-data.js";
export {createUserDoc} from "./functions/auth/create-user-doc.js";
export {setCustomClaims} from "./functions/auth/set-custom-claims.js";

export {importExceptions} from "./functions/iot/import-exceptions.js";
export {importMeasurements} from "./functions/iot/import-measurements.js";

// TODO do app check
