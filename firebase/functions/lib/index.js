"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
/* eslint max-len: ["error", { "code": 120 }]*/
const admin = require("firebase-admin");
admin.initializeApp();
var change_role_1 = require("./functions/change-role");
Object.defineProperty(exports, "changeRole", { enumerable: true, get: function () { return change_role_1.changeRole; } });
var delete_user_data_1 = require("./functions/delete-user-data");
Object.defineProperty(exports, "deleteUserData", { enumerable: true, get: function () { return delete_user_data_1.deleteUserData; } });
var create_user_doc_1 = require("./functions/create-user-doc");
Object.defineProperty(exports, "createUserDoc", { enumerable: true, get: function () { return create_user_doc_1.createUserDoc; } });
var set_custom_claims_1 = require("./functions/set-custom-claims");
Object.defineProperty(exports, "setCustomClaims", { enumerable: true, get: function () { return set_custom_claims_1.setCustomClaims; } });
//# sourceMappingURL=index.js.map