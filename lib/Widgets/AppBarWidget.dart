import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppBarWidget(
      {super.key,
      required this.appBarTitle,
      this.appBarLeading,
      this.appBarAction});

  final Widget? appBarTitle;
  final Widget? appBarLeading;
  final List<Widget>? appBarAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          toolbarHeight: 84,
          backgroundColor: const Color(0xFF112D55),
          centerTitle: true,
          title: appBarTitle is Column || appBarTitle is Text
              ? DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: 'Playfair_Display',
                    fontSize: 35,
                    color: Colors.white,
                  ),
                  child: appBarTitle!,
                )
              : appBarTitle,
          leading: appBarLeading,
          actions: appBarAction,
        ),
        Divider(color: Colors.white,),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
