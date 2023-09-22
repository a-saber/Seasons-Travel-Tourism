import 'package:flutter/material.dart';
import 'package:seasons/core/resources_manager/colors_manager.dart';

import 'default_app_bar.dart';

class BasicView extends StatelessWidget {
  const BasicView({super.key, required this.child, this.bottomPadding = 75});

  final double bottomPadding ;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
            child: Center(child: child,)
        )
    );
  }
}

class BasicView3 extends StatelessWidget {
  const BasicView3({super.key, required this.child, this.bottomPadding = 20});

  final double bottomPadding ;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: Center(child: child,)
    );
  }
}


class BasicView2 extends StatelessWidget {
  const BasicView2({super.key,
    required this.appbarTitle,
    this.buttonText,
    this.scaffoldKey,
    required this.children,
    this.onTap,
    this.enableCondition,
    this.verticalPadding = 20,
    this.button,
    this.action,
  });

  final GlobalKey? scaffoldKey ;
  final double verticalPadding ;
  final String appbarTitle;
  final String? buttonText;
  final List<Widget> children;
  final Widget? button;
  final Widget? action;
  final void Function()? onTap;
  final bool? enableCondition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: defaultAppBar(
        context: context,
        text: appbarTitle,
        action: action
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: children,
                ),
                SizedBox(height: 20,),
                button??
                InkWell(
                  onTap: enableCondition!? onTap : null,
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: enableCondition!?ColorsManager.primaryColor:Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                      buttonText!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Cairo",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
