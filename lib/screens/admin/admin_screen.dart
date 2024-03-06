import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    Key? key, // Add this line to declare key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Admin',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onSearch: (String) {},
      ),
      body: ListView(
        children: [
          _buildListItem(context, 'Cars', '/car'),
          _buildListItem(context, 'Brands', '/brand'),
          _buildListItem(context, 'Sub Brands', '/subbrand'),
          _buildListItem(context, 'Colors', '/color'),
          _buildListItem(context, 'Fuels', '/fuel'),
          _buildListItem(context, 'Owners', '/owner'),
          _buildListItem(context, 'Banners', '/banner'),
          _buildListItem(context, 'Sub Brands Filter', '/subbrandfilter'),
          _buildListItem(context, 'Social', '/social'),
          _buildListItem(context, 'Mela Owner', '/melaowner'),

          // Add more items as needed
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // Navigate to the relevant page based on the route
        Navigator.pushNamed(context, route);
      },
    );
  }
}
