import admin from "firebase-admin";
import {pubsub} from "firebase-functions";
import {ControllerException} from "../../entities/controller-exception.js";
import {InvalidControllerData} from "../../throwed/exceptions.js";

export const importExceptions = pubsub
  .topic("exceptions")
  .onPublish(onPublish);

async function onPublish(message: pubsub.Message) {
  const json = message.json;

  if (!isControllerException(json)) throw new InvalidControllerData(message.data);

  const docID = Date.now();
  const values = {
    "code": json.code,
    "object": json.object,
  };

  await admin
    .firestore()
    .collection("exceptions")
    .doc(docID.toString())
    .set(values);
}

function isControllerException(data: unknown): data is ControllerException {
  const maybeData = data as ControllerException;

  return (
    typeof (maybeData.code) === "number" &&
    typeof (maybeData.object) === "string"
  );
}
