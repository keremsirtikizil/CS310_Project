import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';

class AppBarWithArrow extends StatelessWidget implements PreferredSizeWidget {
  
  
  const AppBarWithArrow({super.key});


  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70), 
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:AppColors.appBarColor ,
        flexibleSpace: Stack(
          alignment: Alignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top:20),
              child: Center(child: Image.asset('assets/images/grocery+_logo.png', height: 60,),)
            )
          ],
        ),
      )
    );
  }
  @override 
  Size get preferredSize => Size.fromHeight(70);

}