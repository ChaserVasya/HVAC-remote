export class Data {
  temperature: number;
  illuminance: number;
  batteryVoltage: number;
  time: number;

  constructor(
    {
      temperature,
      illuminance,
      batteryVoltage,
      time,
    }: {
      temperature: number;
      illuminance: number;
      batteryVoltage: number;
      time: number;
    }
  ) {
    this.temperature = temperature;
    this.illuminance = illuminance;
    this.batteryVoltage = batteryVoltage;
    this.time = time;
  }
}


