# CS310_Project
Application Name: **GroceryList**+

Group Members:
**Ahmet Aldırmaz - 32269** | **Burhan Naci Ulusu - 32295** | **Emirhan Oğuz - 32135** 

**Eylül Pelin Kılıç - 32547** | **Kerem Sırtıkızıl - 32298** | **Yiğit Onur Yılmaz - 31981** 

Main Purpose:
* **GroceryList+** is designed to help users manage their shopping lists efficiently while also tracking the expiration dates of food items. The app minimizes food waste by reminding users of   expiring groceries and suggesting meal ideas based on available ingredients.

Target Audience:
* People looking to reduce food waste.
* Busy professionals who want to organize grocery shopping efficiently.

Key Features:
* **Smart Shopping List:** Users can create and organize shopping lists, categorize items, and mark purchased items.
* **Barcode Scanner:** Scan product barcodes to auto-fill grocery details such as name and category.
* **Expiry Date Tracking:** Users can input expiry dates manually or retrieve them from a product database. The app provides timely reminders for expiring food.
* **Family Sync Feature:** Multiple users can share and update a common grocery list in real time.
* **Offline Mode:** Allows users to access their grocery list and expiry tracker even without an internet connection.

Platform:
* The app will be developed using Flutter, ensuring compatibility across both Android and iOS

Data Storage:
* Grocery items and shopping lists (stored in SQLite for offline access or Firebase for cloud storage).
* User preferences and expiry date notifications (local storage or Firestore).
* Scanned barcode data and retrieved product information (cached for quick access).

Unique Selling Point:
* Unlike traditional grocery list apps, GroceryList+ actively prevents food waste by tracking expiry dates and offering meal planning suggestions based on expiring groceries. The barcode    scanner integration simplifies adding new items, and the family sync feature allows collaborative shopping list management.

Challenges:
* **Barcode Accuracy & User Engagement:** Ensuring reliable product details from barcode scanning is crucial while also motivating users to consistently input expiry dates.
* **Notification & Syncing Issues:** Designing reminders that are useful but non-intrusive while maintaining smooth real-time updates for shared grocery lists across multiple devices.
* **Performance & Storage Optimization:** Efficiently managing database storage for offline access while keeping the app fast and responsive.
