#include "incbin.h"

//incbin defines external! linkage const vars;
#define SENSITIVE_FOLDER "C:/Dev/Projects/HVAC-remote/controller/src/sensitive"
INCBIN(primaryCrt, SENSITIVE_FOLDER "/primary.cer");
INCBIN(backupCrt, SENSITIVE_FOLDER "/backup.cer");
INCBIN(privateKey, SENSITIVE_FOLDER "/private.pem");