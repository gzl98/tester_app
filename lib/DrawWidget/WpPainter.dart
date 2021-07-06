import 'dart:math';
import 'dart:ui';


class WPPainter {
  Offset point;
  Color color;
  double strokeWidth;

  WPPainter(this.point, this.color, this.strokeWidth);

  Offset get getPoint => this.point;

  /*
  * 该函数传入一个Offset类和一个宽度，判断该点，是否在点与宽度构成的圆心内
  * */
  bool eqOffset(Offset other,double width){
    var dis_a = other.dx-this.point.dx;
    var dis_b = other.dy-this.point.dy;
    var distance = sqrt(dis_a*dis_a+dis_b*dis_b);
    return distance<=(width+this.strokeWidth/2);
  }
}