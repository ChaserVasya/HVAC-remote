import { driver } from "../database";
import { Data } from "../data";


export async function insertValue(data: Data) {
  const query = `
  UPSERT INTO test(timestamp, batteryVoltage, illuminance, temperature)
  VALUES(CAST(${data.time.toFixed(0)} as DATETIME), ${data.batteryVoltage}, ${data.illuminance}, ${data.temperature});
  `;

  await driver.tableClient.withSession(async (session) => {
    await session.executeQuery(query);
  });
}
