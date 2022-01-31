export class UserDetails {
  role: Role;
  createdOn: number;

  constructor(
    {
      createdOn,
      role,
    }: {
      createdOn: number,
      role: Role,
    }
  ) {
    this.createdOn = createdOn;
    this.role = role;
  }
}

export declare type Role = "reader" | "adjuster" | "manufacter";
