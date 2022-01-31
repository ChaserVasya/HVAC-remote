export class ControllerException {
  code: number;
  object: string;

  constructor(
    {
      code,
      object,
    }: {
      code: number,
      object: string,
    }
  ) {
    this.code = code;
    this.object = object;
  }
}
