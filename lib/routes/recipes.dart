import 'package:flutter/material.dart';
import 'package:grocery_list/utils/AppColors.dart';
import 'package:grocery_list/utils/appBar.dart';
import 'package:grocery_list/utils/navbar.dart';

class RecipePage extends StatefulWidget{
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {

  final List<Map<String, dynamic>> recipes = [
    {
      'title': 'Chicken Salad',
      'image': 'assets/images/chicken_salad.png',
      'ingredients': [
        {'name': 'Chicken breast', 'available': true},
        {'name': 'Tomato', 'available': true},
        {'name': 'Lettuce', 'available': true},
        {'name': 'Olive oil', 'available': false},
        {'name': 'Lemon juice', 'available': false},
      ],
    },
    {
      'title': 'Stuffed Bell Peppers',
      'image': 'assets/images/bell_peppers.png',
      'ingredients': [
        {'name': 'Bell peppers', 'available': true},
        {'name': 'Cooked rice', 'available': false},
        {'name': 'Tomato paste', 'available': true},
        {'name': 'Olive oil', 'available': false},
        {'name': 'Ground chicken', 'available': true},
      ],
    },
    {
      'title': 'Chicken Alfredo Pasta',
      'image': 'assets/images/alfredo.png',
      'ingredients': [
        {'name': 'Fettuccine pasta', 'available': true},
        {'name': 'Chicken breast', 'available': true},
        {'name': 'Heavy cream', 'available': true},
        {'name': 'Garlic', 'available': true},
        {'name': 'Parmesan cheese', 'available': false},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: AppColors.loginBackground,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBarWithArrow(),
          ),
          body: Stack(
            children:[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 2),

                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Suggested Recipes",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child:SizedBox(
                                height: 36,
                                child: TextField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Search...',
                                    prefixIcon: Icon(Icons.search, size: 18),
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 1),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.tune),
                                onPressed: () {
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  recipe['image'],
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                recipe['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              ...recipe['ingredients'].map<Widget>((ingredient) {
                                return Row(
                                  children: [
                                    const Text('\u2023 '),
                                    Expanded(
                                      child: Text(
                                        ingredient['name'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Icon(
                                      ingredient['available'] ? Icons.check_circle : Icons.cancel,
                                      color: ingredient['available'] ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: AppNavBar(currentIndex: 3),
    );
  }
}
