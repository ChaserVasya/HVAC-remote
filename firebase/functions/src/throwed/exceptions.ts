import {HttpsError, FunctionsErrorCode} from "firebase-functions/lib/providers/https";

export class Exception extends HttpsError {
  constructor(code: FunctionsErrorCode, message: string) {
    super(code, message);
  }
}


export class UnauthorizedAccess extends Exception {
  constructor() {
    super(
        "unauthenticated",
        "Unauthorized access to functions. Current user circumvented signing " +
      "or it is a development error."
    );
  }
}
