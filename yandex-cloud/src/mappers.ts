import { Data } from "./data";

export function event2data(event: any): Data {
  const payload: string = event.messages[0].details.payload;
  const dataJson = Buffer.from(payload, "base64").toString();
  console.debug(`IoT message payload: ${payload}`);
  const data: Data = JSON.parse(dataJson);
  return data;
}
