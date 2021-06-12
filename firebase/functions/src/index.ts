"use strict";

/* eslint max-len: ["error", { "code": 120 }]*/

import admin = require("firebase-admin")
admin.initializeApp();

export {changeRole} from "./functions/change-role";
export {deleteUserData} from "./functions/delete-user-data";
export {createUserDoc} from "./functions/create-user-doc";
export {setCustomClaims} from "./functions/set-custom-claims";

// TODO do app check
