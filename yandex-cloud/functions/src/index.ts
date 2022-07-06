import { driver, initDb } from "./database";
import { event2data } from "./mappers";
import { insertValue } from "./queries/clients-table";

export async function handler(event: any, context: any) {
  console.debug(`Input IoT message: ${JSON.stringify(event)}`);

  const data = event2data(event);
  await initDb();
  await insertValue(data);
  await driver.destroy();

  console.log(`Inserted: ${JSON.stringify(data)}`);
}
