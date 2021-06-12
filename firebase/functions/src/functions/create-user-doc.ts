

import {auth} from "firebase-functions";
import admin = require("firebase-admin")
import {UserDetails} from "../entities/user";


export const createUserDoc = auth.user().onCreate(
    async (user) => {
      const userDetails = new UserDetails({createdOn: Date.now(), role: DEFAULT_ROLE});
      await admin.firestore().collection("users").doc(user.uid).create(userDetails);
    },
);
