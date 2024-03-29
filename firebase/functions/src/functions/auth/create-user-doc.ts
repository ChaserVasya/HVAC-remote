import {auth} from "firebase-functions";
import admin from "firebase-admin";
import {UserDetails} from "../../entities/user.js";
import {DEFAULT_ROLE} from "../../constants.js";


export const createUserDoc = auth.user().onCreate(
  async (user) => {
    const userDetails = new UserDetails({createdOn: Date.now(), role: DEFAULT_ROLE});
    await admin
      .firestore()
      .collection("users")
      .doc(user.uid)
      .create(JSON.parse(JSON.stringify(userDetails)));
  },
);
