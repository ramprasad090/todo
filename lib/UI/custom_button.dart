import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final double? iconSize;
  final Widget? child;
  final TextStyle? titleStyle;
  final Function? onPressed;
  final Function? onLongPress;
  final OutlinedBorder? shape;
  final bool isFixedHeight;
  final double? height;
  final bool loading;
  final double shapeRadius;
  final Color? color;
  final Color? iconColor;
  final double? elevation;
  final bool? isSecondary;

  const CustomButton({
    this.title,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.shape,
    this.isFixedHeight = false,
    this.height,
    this.loading = false,
    this.shapeRadius = 8,
    this.color,
    this.titleStyle,
    this.elevation,
    this.isSecondary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: const EdgeInsets.all(0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          animationDuration: const Duration(seconds: 1),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          splashFactory: InkRipple.splashFactory,
          backgroundColor: (loading || onPressed == null)
              ? (color ?? Theme.of(context).primaryColor).withOpacity(0.15)
              : (color ?? Theme.of(context).primaryColor)
                  .withOpacity(isSecondary == true ? 0.12 : 1.0),
          disabledBackgroundColor: loading
              ? (color ?? Theme.of(context).primaryColor).withOpacity(0.05)
              : null,
          elevation: elevation,
          shape: shape ??
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(shapeRadius),
                  side: BorderSide.none),
        ),
        onPressed: (loading || onPressed == null)
            ? null
            : () {
                FocusScope.of(context).requestFocus(FocusNode());
                onPressed!();
              },
        onLongPress: (loading || onLongPress == null)
            ? null
            : () {
                FocusScope.of(context).requestFocus(FocusNode());
                onLongPress!();
              },
        child: loading
            ? SizedBox(
                height: height ?? 48,
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: isSecondary == true
                        ? color ?? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                ),
              )
            : SizedBox(
                width: null,
                height: isFixedHeight ? 48 : (height ?? 48),
                child: child ??
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon != null
                            ? Icon(
                                icon,
                                color: iconColor ??
                                    (isSecondary == true
                                        ? color
                                        : Colors.white),
                                size: iconSize ?? 20,
                              )
                            : const SizedBox(),
                        (title != null && title!.isNotEmpty)
                            ? Center(
                                child: Text(
                                  "$title",
                                  textAlign: TextAlign.center,
                                  style: titleStyle ??
                                      TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: (loading || onPressed == null)
                                            ? Colors
                                                .grey // or any other disabled color you prefer
                                            : (isSecondary == true
                                                ? color ??
                                                    Theme.of(context)
                                                        .primaryColor
                                                : Colors.white),
                                      ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
              ),
      ),
    );
  }
}
