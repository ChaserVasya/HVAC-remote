import { Data } from "./data";
import { driver, initDb } from "./database";
import { insertValue } from "./queries/clients-table";
import * as exportedJson from "./exportedData.json";

const datum = new Data({
  batteryVoltage: 5.2342,
  illuminance: 1.25,
  temperature: 4.341,
  time: 213213322,
});

async function main() {
  const map = new Map(Object.entries(exportedJson));

  const data: Array<Data> = [];
  console.log(map.size);
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
