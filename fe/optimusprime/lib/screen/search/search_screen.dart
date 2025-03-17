import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showFilter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            GoRouter.of(context).go('/products');
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm ...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              setState(() {
                _showFilter = !_showFilter;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Center(
              child: Text(
                "Tìm kiếm   ...",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            right: _showFilter ? 0 : -MediaQuery.of(context).size.width * 0.75,
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bộ lọc',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('Giá',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                              decoration: InputDecoration(hintText: 'Từ'))),
                      Text(' - '),
                      Expanded(
                          child: TextField(
                              decoration: InputDecoration(hintText: 'Đến'))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Hãng:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButtonFormField(items: [], onChanged: (value) {}),
                  SizedBox(height: 16),
                  Text('Loại:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text('Loại 1'))),
                      SizedBox(width: 8),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {}, child: Text('Loại 2'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorOption extends StatelessWidget {
  final Color color;
  final String label;

  const ColorOption({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color, radius: 16),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
