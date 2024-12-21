import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            //Text(widget.item["caption"]),
            Text("Include Some Details")
          ],
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.item["icon"],
                size: 100,
                color: widget.item["color"],
              ),
              SizedBox(height: 20),
              Text(
                widget.item["caption"],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildCategorySpecificContent(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement post item functionality
                },
                child: Text('Post Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySpecificContent() {
    switch (widget.item["caption"]) {
      case "Cars":
        return _buildCarForm();
      case "Property":
        return _buildPropertyForm();
      case "Mobiles":
        return _buildMobileForm();
      // Add cases for other categories
      default:
        return Text("Form for ${widget.item["caption"]} category");
    }
  }

  Widget _buildCarForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8e61foEH1tVRlDS4OMHtW8UnC_EvBw3Hq9w&s"),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'Title')),
        SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'City')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'veriFiedSeller')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'category')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'description')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'price')),
         SizedBox(height: 10),
        Text("Specifications",style: TextStyle(fontSize: 30),),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'make')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'model')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'mfgYear')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'odoReading')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'inWarranty')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'inWarranty')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'transmissionType')),
         SizedBox(height: 10),
        TextFormField(decoration: InputDecoration(labelText: 'fuelType')),

      ],
    );
  }

  Widget _buildPropertyForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(decoration: InputDecoration(labelText: 'Property Type')),
        TextFormField(decoration: InputDecoration(labelText: 'Bedrooms')),
        TextFormField(decoration: InputDecoration(labelText: 'Bathrooms')),
        TextFormField(decoration: InputDecoration(labelText: 'Area (sq ft)')),
        TextFormField(decoration: InputDecoration(labelText: 'Price')),
      ],
    );
  }

  Widget _buildMobileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(decoration: InputDecoration(labelText: 'Brand')),
        TextFormField(decoration: InputDecoration(labelText: 'Model')),
        TextFormField(decoration: InputDecoration(labelText: 'Storage')),
        TextFormField(decoration: InputDecoration(labelText: 'Condition')),
        TextFormField(decoration: InputDecoration(labelText: 'Price')),
      ],
    );
  }
}
