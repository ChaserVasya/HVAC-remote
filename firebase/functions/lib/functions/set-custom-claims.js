"use strict";


const admin = require("firebase-admin");
const functions = require("firebase-functions");

const constants = require("../constants.js").constants;

const DEFAULT_CLAIMS = constants.DEFAULT_CLAIMS;


exports.setCustomClaims = functions.auth.user().onCreate(
    async (user) => await admin
        .auth()
        .setCustomUserClaims(user.uid, DEFAULT_CLAIMS),
);
