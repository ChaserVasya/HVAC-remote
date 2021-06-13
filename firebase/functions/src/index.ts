"use strict";

/* eslint max-len: ["error", { "code": 120 }]*/

import admin = require("firebase-admin")
admin.initializeApp();

export {changeRole} from "./functions/auth/change-role";
export {deleteUserData} from "./functions/auth/delete-user-data";
export {createUserDoc} from "./functions/auth/create-user-doc";
export {setCustomClaims} from "./functions/auth/set-custom-claims";

// TODO do app check
