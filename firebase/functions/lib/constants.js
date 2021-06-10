"use strict";

const DEFAULT_ROLE = "reader";

exports.constants = Object.freeze({
  DEFAULT_CLAIMS: {
    "role": DEFAULT_ROLE,
  },


  DEFAULT_ROLE: DEFAULT_ROLE,

  UNSUCCESSFUL_ROLE_CHANGING_WARN: "unsuccessful attempt to change roles",

  USER_DETAILD_TEMPLATE: {
    "role": undefined,
    "createdOn": undefined,
  },
});

