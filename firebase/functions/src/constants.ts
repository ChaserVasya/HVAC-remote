"use strict";

export const DEFAULT_ROLE = "reader";


export const DEFAULT_CLAIMS = {
  "role": DEFAULT_ROLE,
};

export type DocumentList = FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>[];


