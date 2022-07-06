import { Data } from "./data";
import { driver, initDb } from "./database";
import { insertValue } from "./queries/clients-table";
import * as exportedJson from "./exportedData.json";

async function main() {
  const map = new Map(Object.entries(exportedJson));

  const data: Array<Data> = [];
  for (let i = 0; i < map.size - 1; i++) {
    const datum = map.get(i.toString())!;
    const dataDatum = {
      illuminance: datum.illuminance,
      batteryVoltage: datum.batteryVoltage,
      temperature: datum.temperature,
      time: parseInt(datum.time),
    }
    data[i] = new Data(dataDatum);
  }

  await initDb();
  for (const datum of data) {
    await insertValue(datum);
  }
  await driver.destroy();
}

main();
