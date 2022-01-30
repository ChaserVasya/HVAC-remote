import admin from "firebase-admin";
import {pubsub} from "firebase-functions";
import {Data} from "../../entities/data";
import {InvalidControllerData} from "../../throwed/exceptions";

export const helloPubSub = pubsub.topic("topic-name").onPublish((message) => {
  const json = message.json();

  if (!isData(json)) throw new InvalidControllerData(message.data);

  const docID = json.time.toString();
  const values = {
    "temperature": json.temperature,
    "illuminance": json.illuminance,
    "batteryVoltage": json.batteryVoltage,
  };

  admin
    .firestore()
    .collection("measurements")
    .doc(docID)
    .set(values);
});

function isData(data: unknown): data is Data {
  const maybeData = data as Data;

  return (
    typeof (maybeData.temperature) === "number" &&
    typeof (maybeData.illuminance) === "number" &&
    typeof (maybeData.batteryVoltage) === "number" &&
    typeof (maybeData.time) === "number"
  );
}
