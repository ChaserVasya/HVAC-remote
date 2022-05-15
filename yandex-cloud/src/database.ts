// данный код инициализации базы работает как на локальном компьютере с использованием авторизации на основе Service Account Key
// для cloud function авторизация работает на основе сервиса метаданных
// чтобы этот метод работад Вы должны создать сервисный аккаунт, дать ему необходимые права (для начала дайте admin)
// после этого при деплое функции к ней привязывается этот сервисный аккаунт и авторизация к базе данных идет на его основе
//
// для локального запуска пример запускался из под windows.
// поскольку windows автоматически не читает файл .env - то process.env.ENDPOINT не определена
// в то же время при деплое функции я передаю ей в env окружении  ENDPOINT и она определена
// поэтому в одном месте работает авторизация как на основе Service Account Key так и на основе метаданных
//
// документация:
// https://cloud.yandex.ru/docs/ydb/concepts/connect#auth

import { getLogger, Driver, getCredentialsFromEnv } from "ydb-sdk";

export const logger = getLogger();
export let driver: Driver;

export async function initDb() {
  logger.info("Driver initializing...");

  if (!isRunningFromCloud()) {
    const dotenv = await import("dotenv");
    dotenv.config();
  }

  const authService = getCredentialsFromEnv(logger);

  driver = new Driver({ endpoint: process.env.ENDPOINT, database: process.env.DATABASE, authService });
  const timeout = 10000;
  if (!(await driver.ready(timeout))) {
    logger.fatal(`Driver has not become ready in ${timeout}ms!`);
    process.exit(1);
  } else {
    logger.info("Driver ready");
  }
}

function isRunningFromCloud(): boolean {
  return !!process.env._HANDLER;
}
