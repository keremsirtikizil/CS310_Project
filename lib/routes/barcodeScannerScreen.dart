import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingItem{
  String name;
  double price;
  String amount;
  String expiry;
  ShoppingItem(this.name, this.price, this.amount, this.expiry);
}


Future<Map<String, dynamic>?> fetchProductInfo(String barcode) async {
  final url = Uri.parse('https://api.upcitemdb.com/prod/trial/lookup?upc=$barcode');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return data['items'][0]; 
      }
    } else {
      print('Failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return null;
}

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


class BarcodeScannerScreen extends StatefulWidget{
  const BarcodeScannerScreen({super.key});
  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>{
  bool showManualInput = false;
  final TextEditingController _manualBarcodeController = TextEditingController();
  final MobileScannerController _cameraController = MobileScannerController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBarWithArrow(),
      body: SingleChildScrollView(child:Column(
        children: [
          if(!showManualInput)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("Scanning... Hold the Device Steady"),
            ),

          !showManualInput ?
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              clipBehavior: Clip.hardEdge,
              child: MobileScanner(
                controller: _cameraController,
                onDetect: (capture) async {
                  final barcodes = capture.barcodes;
                  if(barcodes.isNotEmpty){
                    final code = barcodes.first.rawValue;
                    if(code != null){
                      final product = await fetchProductInfo(code);
                      if(product != null){
                        final title = product['title'] ?? 'Unknown';
                        final brand = product['brand'] ?? 'Unknown';
                        final newItem = await Navigator.pushNamed(
                          context, '/product-details', arguments: {'barcode': code, 'title': title, 'brand': brand}
                        );
                        if(newItem != null && context.mounted){
                          Navigator.pop(context, newItem);
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Product not found in the database"),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          );
                      }
                      //Navigator.pushNamed(context, '/product-details');
                    }
                  }
                }
                
              ),
            )
          :
            Container(
              height: 300,
              alignment: Alignment.center,
              child: const Text(
              "You can now enter the barcode manually.", 
              textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height:16),
          
          if(!showManualInput)
          ElevatedButton(
            onPressed: () {
              setState(() {
                showManualInput = true;
                _cameraController.stop();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade800,
              foregroundColor: Colors.white,
            ),
            child: const Text('Enter the barcode manually.')  
          ),
          

          if(showManualInput)
            Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                  children: [
                    TextField(
                      controller: _manualBarcodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Manual Barcode Entry",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async{
                        final barcode = _manualBarcodeController.text.trim();
                        if (barcode.isNotEmpty) {
                          final product = await fetchProductInfo(barcode);
                        if(product != null){
                        final title = product['title'] ?? 'Unknown';
                        final brand = product['brand'] ?? 'Unknown';
                        final newItem = await Navigator.pushNamed(
                          context, '/product-details', arguments: {'barcode': barcode, 'title': title, 'brand': brand}
                        );
                        if(newItem != null && context.mounted){
                          Navigator.pop(context, newItem);
                        } 
                          
                        
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Product not found in the database"),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          );
                      }
                          //Navigator.pushNamed(context, '/product-details');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                      ),
                      child: const Text("Save"),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() {
                      showManualInput = false;
                      _cameraController.start();
                    }),
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
                    ),
                      child: const Text("Scan with Camera") 
                    ),
                  ],
                ),

            )  
        ],
      ),
      ), 
      
    );
  }

}
