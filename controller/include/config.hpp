#pragma once

#include "incbin.h"

INCBIN_EXTERN(primaryCrt);
INCBIN_EXTERN(backupCrt);
INCBIN_EXTERN(privateKey);

const int jwt_exp_secs = 3600;
