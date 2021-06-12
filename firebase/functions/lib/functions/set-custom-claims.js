"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.setCustomClaims = void 0;
const firebase_functions_1 = require("firebase-functions");
const admin = require("firebase-admin");
exports.setCustomClaims = firebase_functions_1.auth.user().onCreate(async (user) => await admin
    .auth()
    .setCustomUserClaims(user.uid, DEFAULT_CLAIMS));
//# sourceMappingURL=set-custom-claims.js.map