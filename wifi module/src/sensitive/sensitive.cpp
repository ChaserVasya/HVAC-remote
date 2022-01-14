#include "incbin.h"

#define SENSITIVE_FOLDER "C:/Dev/Projects/HVAC-remote/wifi module/src/sensitive"
INCBIN(primaryCrt, SENSITIVE_FOLDER "/primary.cer");
INCBIN(backupCrt, SENSITIVE_FOLDER "/backup.cer");
INCBIN(privateKey, SENSITIVE_FOLDER "/private.pem");
