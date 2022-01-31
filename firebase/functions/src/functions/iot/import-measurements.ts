import admin from "firebase-admin";
import {pubsub} from "firebase-functions";
import {Data} from "../../entities/data.js";
import {InvalidControllerData} from "../../throwed/exceptions.js";


export const importMeasurements = pubsub
  .topic("measurements")
  .onPublish(onPublish);

async function onPublish(message: pubsub.Message) {
  const json = message.json;

  if (!isData(json)) throw new InvalidControllerData(message.data);

  const docID = json.time.toString();
  const values = {
    "temperature": json.temperature,
    "illuminance": json.illuminance,
    "batteryVoltage": json.batteryVoltage,
  };

  await admin
    .firestore()
    .collection("measurements")
    .doc(docID)
    .set(values);
}

function isData(data: unknown): data is Data {
  const maybeData = data as Data;

  return (
    typeof (maybeData.temperature) === "number" &&
    typeof (maybeData.illuminance) === "number" &&
    typeof (maybeData.batteryVoltage) === "number" &&
    typeof (maybeData.time) === "number"
  );
}
