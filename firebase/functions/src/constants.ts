"use strict";

declare const DEFAULT_ROLE = "reader";


const DEFAULT_CLAIMS = {
  "role": DEFAULT_ROLE,
};

type DocumentList = FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>[];


