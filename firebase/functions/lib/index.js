"use strict";

/* eslint max-len: ["error", { "code": 120 }]*/

const admin = require("firebase-admin");
admin.initializeApp();

exports.changeRole = require("./functions/change-role").changeRole;
exports.deleteUserData = require("./functions/delete-user-data").deleteUserData;
exports.createUserDoc = require("./functions/init-user").createUserDoc;
exports.setCustomClaims = require("./functions/set-custom-claims").setCustomClaims;

// TODO do app check
