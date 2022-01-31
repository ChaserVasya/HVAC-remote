#pragma once

// convenient representation of voltage divier.
// user fulls known fields by method(double) and takes
// missing value by method().
// Examples are in [AnalogSensor]s implementations
class VoltageDivider {
  double _Rlower;
  double _Rupper;
  double _Roffset;
  double _Vin;
  double _Vout;

  // Main rule:  Vout = Vin/(1 + Rupper/(Rlower + Roffset))
 public:
  double Rlower() { return _Rupper / (_Vin / _Vout - 1) - _Roffset; };
  double Rupper() { return (_Rlower + _Roffset) * (_Vin / _Vout - 1); };
  double Vin() { return _Vout * (1 + _Rupper / (_Rlower + _Roffset)); };
  double Vout() { return _Vin / (1 + _Rupper / (_Rlower + _Roffset)); };

  void Rlower(double val) { _Rlower = val; }
  void Rupper(double val) { _Rupper = val; }
  void Roffset(double val) { _Roffset = val; }
  void Vin(double val) { _Vin = val; }
  void Vout(double val) { _Vout = val; }
};