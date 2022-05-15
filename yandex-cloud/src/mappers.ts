import { Data } from "./data";

export function event2data(event: any): Data {
  const payload: string = event.messages[0].details.payload;
  const dataJson = Buffer.from(payload, "base64").toString();
  const data: Data = JSON.parse(dataJson);
  return data;
}
