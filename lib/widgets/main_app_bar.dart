import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  MainAppBar({
    Key? key,
    @required this.appBar,
    @required this.title,
    this.scrollController,
    this.leading,
    this.iconButtons,
    this.centerTitle,
  }) : super(key: key);
  final AppBar? appBar;
  final String? title;
  final ScrollController? scrollController;
  final bool? leading;
  final List<Widget>? iconButtons;
  final bool? centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(appBar!.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: centerTitle,
      leading: leading == true ? BackButton(color: Colors.black) : null,
      title: TextButton(
        child: Text(
          title!,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        style: TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
        onPressed: scrollController != null
            ? () {
                scrollController!.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            : null,
      ),
      actions: iconButtons,
    );
  }
}
