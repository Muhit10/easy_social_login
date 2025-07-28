import 'package:flutter/material.dart';

/// Customizable social login button widget
class SocialLoginButton extends StatelessWidget {
  /// Button text
  final String text;
  
  /// Button icon
  final Widget? icon;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;
  
  /// Button background color
  final Color? backgroundColor;
  
  /// Text color
  final Color? textColor;
  
  /// Button border radius
  final BorderRadius? borderRadius;
  
  /// Button padding
  final EdgeInsetsGeometry? padding;
  
  /// Button height
  final double? height;
  
  /// Button width
  final double? width;
  
  /// Text style
  final TextStyle? textStyle;
  
  /// Button border
  final BorderSide? border;
  
  /// Loading state
  final bool isLoading;
  
  /// Loading widget
  final Widget? loadingWidget;
  
  /// Button elevation
  final double? elevation;

  const SocialLoginButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.height,
    this.width,
    this.textStyle,
    this.border,
    this.isLoading = false,
    this.loadingWidget,
    this.elevation,
  });

  /// Pre-configured Google Sign-In button
  factory SocialLoginButton.google({
    Key? key,
    String text = 'Sign in with Google',
    VoidCallback? onPressed,
    bool isLoading = false,
    double? height,
    double? width,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Widget? loadingWidget,
  }) {
    return SocialLoginButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      height: height ?? 50,
      width: width,
      backgroundColor: Colors.white,
      textColor: const Color(0xFF757575),
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      textStyle: textStyle ?? const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      border: const BorderSide(color: Color(0xFFDDDDDD)),
      loadingWidget: loadingWidget,
      elevation: 2,
      icon: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://developers.google.com/identity/images/g-logo.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  /// Pre-configured Facebook Login button
  factory SocialLoginButton.facebook({
    Key? key,
    String text = 'Continue with Facebook',
    VoidCallback? onPressed,
    bool isLoading = false,
    double? height,
    double? width,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Widget? loadingWidget,
  }) {
    return SocialLoginButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      height: height ?? 50,
      width: width,
      backgroundColor: const Color(0xFF1877F2),
      textColor: Colors.white,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      textStyle: textStyle ?? const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      loadingWidget: loadingWidget,
      elevation: 2,
      icon: const Icon(
        Icons.facebook,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: elevation,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            side: border ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? loadingWidget ?? 
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Theme.of(context).primaryColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: textStyle?.copyWith(color: textColor) ?? 
                        TextStyle(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Row of social login buttons
class SocialLoginButtonRow extends StatelessWidget {
  /// List of social login buttons
  final List<Widget> buttons;
  
  /// Spacing between buttons
  final double spacing;
  
  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;
  
  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  const SocialLoginButtonRow({
    super.key,
    required this.buttons,
    this.spacing = 16,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: buttons
          .expand((button) => [button, SizedBox(width: spacing)])
          .take(buttons.length * 2 - 1)
          .toList(),
    );
  }
}

/// Column of social login buttons
class SocialLoginButtonColumn extends StatelessWidget {
  /// List of social login buttons
  final List<Widget> buttons;
  
  /// Spacing between buttons
  final double spacing;
  
  /// Main axis alignment
  final MainAxisAlignment mainAxisAlignment;
  
  /// Cross axis alignment
  final CrossAxisAlignment crossAxisAlignment;

  const SocialLoginButtonColumn({
    super.key,
    required this.buttons,
    this.spacing = 16,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: buttons
          .expand((button) => [button, SizedBox(height: spacing)])
          .take(buttons.length * 2 - 1)
          .toList(),
    );
  }
}