
import 'package:flutter/material.dart';
import 'package:grocery_list/utils/navbar.dart';
import 'package:grocery_list/routes/barcodeScannerScreen.dart';



class AppBarWithArrow extends StatelessWidget implements PreferredSizeWidget {
  
  
  const AppBarWithArrow({super.key});


  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70), 
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 182, 190, 98),
        flexibleSpace: Stack(
          alignment: Alignment.center,
          children: [
            //back button
            Positioned(
              left: 0,
              top: 50,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => {Navigator.pop(context)}, // Go back
              ),
            ),
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

class ProductDetails extends StatefulWidget{
  const ProductDetails({super.key});
  @override
  State<ProductDetails> createState () => _ProductDetailsState();
} 

class _ProductDetailsState extends State<ProductDetails>{
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountCountroller = TextEditingController();

  String selectedCategory = 'Dairy';

  final List<String> categoryOptions = [
    'Dairy',
    'Fruits & Vegetables',
    'Meat & Fish',
    'Beverages'
  ];


  @override
  Widget build(BuildContext context){
    final args =  ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = args['title'];
    final String brand = args['brand'];
    final String barcode = args['barcode'];

    return Scaffold(
      appBar: AppBarWithArrow(),
      body: Center(
        child: Column(
          children: [
            Text('Product name: $title', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Product brand: $brand', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Product barcode: $barcode', style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Please enter the additional details below"),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Please enter the price \$", border: OutlineInputBorder()),
              
            ),
            TextField(
              controller: _dateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(labelText: "Please enter the date of expiry: dd-mm-yyyy", border: OutlineInputBorder()),

            ),
            TextField(
              controller: _amountCountroller,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(labelText: "Please enter the amount", border: OutlineInputBorder()),

            ),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Select a category",
                border: OutlineInputBorder(),
              ),
              items: categoryOptions.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

        ElevatedButton(
              onPressed: () {
                final double ? price  = double.parse(_priceController.text);
                final String ? expiry = _dateController.text.trim();
                final String  amount = _amountCountroller.text.trim();
                final String category = selectedCategory;

                if(price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please enter the price!!!",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    )
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                            
                              
                          
                  ));
                }else if(expiry == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please enter the expiry date!!!",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    )
                    ),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                            
                              
                          
                  ));

                }else{
                  final newItem = ShoppingItem(title, price, amount , expiry, category);
                  Navigator.pop(context,newItem);

                }

              },
              child: const Text("Save the Product to List"),
              
            ),
          ]
        ),
      ),
      bottomNavigationBar: AppNavBar(currentIndex: 1,),
      
    );
  }
}

