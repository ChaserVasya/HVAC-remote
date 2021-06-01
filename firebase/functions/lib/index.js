"use strict";

/* eslint max-len: ["error", { "code": 120 }]*/

const admin = require("firebase-admin");
admin.initializeApp();

exports.setCustomClaims = require("./functions/set-custom-claims").setCustomClaims;
exports.changeRole = require("./functions/change-role").changeRole;

