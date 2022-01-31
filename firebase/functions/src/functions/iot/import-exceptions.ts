import admin from "firebase-admin";
import {pubsub} from "firebase-functions";
import {ControllerException} from "../../entities/controller-exception";
import {InvalidControllerData} from "../../throwed/exceptions";

export const importExceptions = pubsub
  .topic("projects/snappy-provider-295713/topics/exceptions")
  .onPublish(onPublish);

function onPublish(message: pubsub.Message) {
  const json = message.json();

  if (!isControllerException(json)) throw new InvalidControllerData(message.data);

  const docID = Date.now();
  const values = {
    "code": json.code,
    "object": json.object,
  };

  admin
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
