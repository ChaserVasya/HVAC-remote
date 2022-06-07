import { Data } from "./data";
import { driver, initDb } from "./database";
import { insertValue } from "./queries/clients-table";

const data = new Data({
  batteryVoltage: 5.2342,
  illuminance: 1.25,
  temperature: 4.341,
  time: 213213322,
});

async function main() {
  await initDb();
  await insertValue(data);
  await driver.destroy();
}

main();
