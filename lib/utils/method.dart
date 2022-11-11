//@dart=2.9
double checkDouble(double d) {
  if (d == null) {
    d = 0.0;
  } else {
    d.round();
  }
  return d;
}
