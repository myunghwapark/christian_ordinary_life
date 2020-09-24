import 'package:christian_ordinary_life/src/common/colors.dart';
import 'package:christian_ordinary_life/src/common/commonSettings.dart';
import 'package:christian_ordinary_life/src/common/translations.dart';
import 'package:flutter/material.dart';

class FontSizePickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final double initialFontSize;
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  const FontSizePickerDialog(
      {Key key,
      this.initialFontSize,
      this.sliderHeight = 48,
      this.max = 25,
      this.min = 15,
      this.fullWidth = false})
      : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  /// current selection of the slider
  double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return AlertDialog(
      title: Text(Translations.of(context).trans('font_size')),
      content: Container(
        width: this.widget.fullWidth
            ? double.infinity
            : (this.widget.sliderHeight) * 5.5,
        height: (this.widget.sliderHeight),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(
            Radius.circular((this.widget.sliderHeight * .3)),
          ),
          gradient: new LinearGradient(
              colors: [
                AppColors.fontGradientStart,
                AppColors.fontGradientEnd,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.00),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
              2, this.widget.sliderHeight * paddingFactor, 2),
          child: Row(
            children: <Widget>[
              Text(
                '${this.widget.min}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this.widget.sliderHeight * .3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: this.widget.sliderHeight * .1,
              ),
              Expanded(
                child: Center(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white.withOpacity(.5),
                      inactiveTrackColor: Colors.white.withOpacity(.1),

                      trackHeight: 4.0,
                      thumbShape: CustomSliderThumbCircle(
                        thumbRadius: this.widget.sliderHeight * .4,
                        min: this.widget.min,
                        max: this.widget.max,
                      ),
                      overlayColor: Colors.white.withOpacity(.4),
                      //valueIndicatorColor: Colors.white,
                      activeTickMarkColor: Colors.white,
                      inactiveTickMarkColor: Colors.red.withOpacity(.7),
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: CommonSettings.minimumFontSize,
                      max: CommonSettings.maximumFontSize,
                      divisions: 10,
                      label: '${CommonSettings.tempFontSize}',
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value;
                          CommonSettings.tempFontSize = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: this.widget.sliderHeight * .1,
              ),
              Text(
                '${this.widget.max}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: this.widget.sliderHeight * .3,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            Translations.of(context).trans('cancel'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          onPressed: () {
            Navigator.pop(context, "cancel");
          },
        ),
        FlatButton(
          child: Text(
            Translations.of(context).trans('confirm'),
            style: TextStyle(color: Colors.grey[700]),
          ),
          onPressed: () {
            Navigator.pop(context, "ok");
          },
        ),
      ],
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    @required this.thumbRadius,
    this.min = 0,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
          fontSize: thumbRadius * .8,
          fontWeight: FontWeight.w700,
          color: Colors.orange[700]
          //color: sliderTheme.thumbColor, //Text Color of Value on Thumb
          ),
      text: getValue(value),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
