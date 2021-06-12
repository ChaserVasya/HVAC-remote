import {HttpsError} from "firebase-functions/lib/providers/https";

export class InternalError extends HttpsError {
  constructor(details: string) {
    super(
        "internal",
        "Developer`s error.",
        details,
    );
  }
}

export class RoleClaimNotExist extends InternalError {
  constructor() {
    super(
        "Role claim not exist. It should be created on user account creating. " +
      "Current user whether circumvented registration,  " +
      "which is an oversight of developers, " +
      "or it is a developer`s error",
    );
  }
}

