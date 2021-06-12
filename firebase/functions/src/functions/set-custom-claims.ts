

import {auth} from "firebase-functions";
import admin = require("firebase-admin")


export const setCustomClaims = auth.user().onCreate(
    async (user) => await admin
        .auth()
        .setCustomUserClaims(user.uid, DEFAULT_CLAIMS),
);
