

export class UserDetails {
  constructor(
      {createdOn,
        role,
      }: {
      createdOn: number,
      role: Role,
    }
  ) {
    this.createdOn = createdOn;
    this.role = role;
  }

  role: Role;
  createdOn: number;
}

export declare type Role = "reader" | "adjuster" | "manufacter";
