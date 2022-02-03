#pragma once

#include "CloudIoTCore.h"
#include "CloudIoTCoreMqtt.h"
#include "common/Logger.hpp"

// Overwrites some methods
class GoogleIotMqttProxy : public CloudIoTCoreMqtt {
  //! not override. just covering.
  // TODO check if it works
  void onConnect() { Logger::debugln("onConnect"); }
};
