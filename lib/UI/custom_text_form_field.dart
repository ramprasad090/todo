import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    Key? key,
    this.filled,
    this.fillColor,
    this.textEditingController,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.hintText,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.isReadOnly = false,
    this.onTap,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    this.prefixIcon,
    this.underline = false,
    this.inputFormatters,
    this.heading,
    this.hintColor,
    this.isRequired = true,
    this.onTapOutside,
    this.textCapitalization,
    this.note,
    this.infoView,
    this.onInfoTap,
    this.maxLength,
  }) : super(key: key);

  //
  final bool? filled;
  final Color? fillColor;
  final TextEditingController? textEditingController;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  //
  final String? labelText;
  final String? heading;
  final String? hintText;
  final String? errorText;
  final String? note;

  final Function(String)? onChanged;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  bool isReadOnly = false;
  final Function()? onTap;
  final int? minLines;
  final int? maxLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final Color? hintColor;
  final bool? infoView;
  final Function()? onInfoTap;
  final bool underline;
  final TextCapitalization? textCapitalization;
  bool isRequired = true;
  Function(PointerDownEvent)? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeading(),
        SizedBox(height: 6),
        _buildInputField(),
      ],
    );
  }

  Widget _buildHeading() {
    if (widget.heading?.isNotEmpty ?? false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: widget.heading,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge!.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildInputField() {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
              cursorRadius: Radius.elliptical(10, 10),
              onTapOutside: widget.onTapOutside,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                suffix: widget.suffixIcon != null
                    ? null
                    : widget.focusNode != null &&
                            widget.focusNode!.hasFocus &&
                            !(widget.obscureText) &&
                            (!widget.isReadOnly)
                        ? InkWell(
                            onTap: () {
                              widget.textEditingController?.clear();
                            },
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color:
                                  Theme.of(context).textTheme.titleSmall!.color,
                            ),
                          )
                        : null,
                hintMaxLines: 1,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                // errorText: widget.errorText,
                filled: widget.fillColor != null,
                fillColor: widget.fillColor,
                errorMaxLines: 1,
                counterText: '',
                
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                hintText: widget.labelText ?? widget.hintText,
                prefixIcon: widget.prefixIcon,
                hintStyle: TextStyle(
                  color: widget.hintColor ??
                      Theme.of(context).textTheme.bodySmall!.color,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onFieldSubmitted: (data) {
                if (widget.onFieldSubmitted != null) {
                  widget.onFieldSubmitted!(data);
                } else {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              autofocus: widget.focusNode?.hasFocus ?? false,
              autovalidateMode: AutovalidateMode.always,
              cursorOpacityAnimates: true,
              onTap: widget.onTap,
              readOnly: widget.isReadOnly ?? false,
              controller: widget.textEditingController,
              validator: widget.validator,
              focusNode: widget.focusNode,
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium!.color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              onChanged: widget.onChanged,
              textInputAction: widget.textInputAction,
              keyboardType: widget.keyboardType,
              textAlignVertical: TextAlignVertical.center,
              minLines: widget.minLines,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
            ),
          ),
        ],
      ),
    );
  }
}
