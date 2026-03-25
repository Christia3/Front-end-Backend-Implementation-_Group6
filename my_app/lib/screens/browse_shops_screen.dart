import 'package:flutter/material.dart';

class BrowseShopsScreen extends StatefulWidget {
  const BrowseShopsScreen({super.key});

  @override
  State<BrowseShopsScreen> createState() => _BrowseShopsScreenState();
}

class _BrowseShopsScreenState extends State<BrowseShopsScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Grains',
    'Dairy',
    'Meat',
    'Tools',
    'Seeds',
  ];

  // Simple shop data with only essential fields
  final List<Map<String, dynamic>> shops = [
    {
      'name': 'Green Valley Farm',
      'category': 'Vegetables',
      'rating': 4.8,
      'products': 24,
      'location': 'Kigali',
    },
    {
      'name': 'Sunrise Orchard',
      'category': 'Fruits',
      'rating': 4.9,
      'products': 18,
      'location': 'Musanze',
    },
    {
      'name': 'Golden Grain Co',
      'category': 'Grains',
      'rating': 4.5,
      'products': 12,
      'location': 'Rubavu',
    },
    {
      'name': 'Fresh Dairy Farm',
      'category': 'Dairy',
      'rating': 4.7,
      'products': 8,
      'location': 'Kigali',
    },
    {
      'name': 'Organic Harvest',
      'category': 'Vegetables',
      'rating': 4.9,
      'products': 32,
      'location': 'Nyagatare',
    },
    {
      'name': 'Farm Tools Center',
      'category': 'Tools',
      'rating': 4.6,
      'products': 45,
      'location': 'Kigali',
    },
  ];

  List<Map<String, dynamic>> get filteredShops {
    var filtered = shops;

    if (selectedCategory != 'All') {
      filtered = filtered
          .where((shop) => shop['category'] == selectedCategory)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (shop) =>
                shop['name'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                shop['location'].toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Browse Shops',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E6F3D),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search shops...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF1E6F3D),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF1E6F3D),
                    ),
                    onPressed: _showFilterDialog,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Categories Scroll
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: FilterChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF1E6F3D),
                    labelStyle: TextStyle(
                      color: selectedCategory == category
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredShops.length} shops found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                if (searchQuery.isNotEmpty || selectedCategory != 'All')
                  TextButton(
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        selectedCategory = 'All';
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),

          // Shops Grid
          Expanded(
            child: filteredShops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No shops found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = filteredShops[index];
                      return _buildShopCard(shop);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> shop) {
    return GestureDetector(
      onTap: () => _showShopDetails(shop),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Shop Image Placeholder
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E6F3D).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Icon(
                Icons.store,
                size: 50,
                color: Color(0xFF1E6F3D),
              ),
            ),

            // Shop Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E6F3D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      shop['category'],
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1E6F3D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        shop['rating'].toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          shop['location'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${shop['products']} products',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showShopDetails(shop),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E6F3D),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'View Shop',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Shops',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF1E6F3D),
                    labelStyle: TextStyle(
                      color: selectedCategory == category
                          ? Colors.white
                          : Colors.black87,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'All';
                      searchQuery = '';
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Clear All Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showShopDetails(Map<String, dynamic> shop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(shop['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${shop['category']}'),
            const SizedBox(height: 8),
            Text('Rating: ${shop['rating']} ⭐'),
            const SizedBox(height: 8),
            Text('Products: ${shop['products']}'),
            const SizedBox(height: 8),
            Text('Location: ${shop['location']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing ${shop['name']}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6F3D),
            ),
            child: const Text(
              'Browse Products',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
