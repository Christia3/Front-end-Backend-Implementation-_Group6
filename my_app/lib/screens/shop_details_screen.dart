import 'package:flutter/material.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final TextEditingController shopNameController = TextEditingController(
    text: 'Green Acres Farm',
  );
  final TextEditingController shopAddressController = TextEditingController(
    text: '123 Farm Road, Kigali',
  );
  final TextEditingController shopPhoneController = TextEditingController(
    text: '+250 788 123 456',
  );
  final TextEditingController shopEmailController = TextEditingController(
    text: 'info@greenacres.com',
  );
  final TextEditingController shopDescriptionController = TextEditingController(
    text:
        'We provide fresh organic produce directly from our farm to your table.',
  );

  bool isShopActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Details'),
        backgroundColor: const Color(0xFF1E6F3D),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveShopDetails,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Logo
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E6F3D),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _changeShopLogo,
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Shop Information
            const Text(
              'Shop Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: shopNameController,
              decoration: const InputDecoration(
                labelText: 'Shop Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: shopAddressController,
              decoration: const InputDecoration(
                labelText: 'Shop Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: shopPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: shopEmailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: shopDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Shop Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Shop Status
            const Text(
              'Shop Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Shop Active'),
              subtitle: const Text('Accept orders from customers'),
              value: isShopActive,
              onChanged: (value) {
                setState(() {
                  isShopActive = value;
                });
              },
              activeColor: const Color(0xFF1E6F3D),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _changeShopLogo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Shop Logo'),
        content: const Text('Choose an option'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Shop logo updated!')),
              );
            },
            child: const Text('Choose from Gallery'),
          ),
        ],
      ),
    );
  }

  void _saveShopDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shop details saved successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    shopNameController.dispose();
    shopAddressController.dispose();
    shopPhoneController.dispose();
    shopEmailController.dispose();
    shopDescriptionController.dispose();
    super.dispose();
  }
}
