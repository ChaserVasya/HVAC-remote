import {auth} from "firebase-functions";
import admin from "firebase-admin";
import {DEFAULT_CLAIMS} from "../../constants.js";


export const setCustomClaims = auth.user().onCreate(
  async (user) => await admin
    .auth()
    .setCustomUserClaims(user.uid, DEFAULT_CLAIMS),
);
