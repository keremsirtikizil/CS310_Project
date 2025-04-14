import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;

  const AppNavBar({super.key, required this.currentIndex});

  void _navigate(int index, BuildContext context) {
      if( index==0 && index !=currentIndex){
        Navigator.pushNamed(context, '/financing');
        
      }
      else if(index==1 && index !=currentIndex){
        Navigator.pushNamed(context, '/add');
      }
      else if(index== 2 && index !=currentIndex){
        Navigator.pushNamed(context, '/home');
      }
      else if(index ==3 && index !=currentIndex){
        Navigator.pushNamed(context, '/inventory');
      }
      else if(index==4 && index !=currentIndex){
        Navigator.pushNamed(context, '/settings');
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromRGBO(245, 230, 200, 1),
      elevation: 8,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 40,
      currentIndex: currentIndex,
      onTap: (index) => _navigate(index, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: '',
        ),
      ],
    );
  }
}
