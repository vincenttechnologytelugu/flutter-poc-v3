// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/controllers/location_controller.dart';
import 'package:flutter_poc_v3/controllers/products_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LocalAreaScreen extends StatefulWidget {
  final String selectedState;
  final String selectedCity;

  const LocalAreaScreen({
    super.key,
    required this.selectedState,
    required this.selectedCity,
  });

  @override
  State<LocalAreaScreen> createState() => _LocalAreaScreenState();
}

class _LocalAreaScreenState extends State<LocalAreaScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> areas = [];
  List<String> filteredAreas = [];

  @override
  void initState() {
    super.initState();
    areas = getAreasForCity(widget.selectedCity);
    filteredAreas = areas;
    _searchController.addListener(_filterAreas);
  }

  List<String> getAreasForCity(String city) {
    // Add your area data here based on the city
    switch (city) {
      case 'Mumbai':
        return [
          'Andheri',
          'Bandra',
          'Colaba',
          'Dadar',
          'Dombivali',
          'Ghatkopar',
          'Jogeshwari',
          'Kandivali',
          'Khar',
          'Mira Bhayandar',
          'Mulund',
          'Pandavpura',
          'Thane',
          'Ulhasnagar',
          'Vasai',
          'Vikhroli',
          'Worli'
        ];

      case 'Chennai':
        return [
          'Anna Nagar',
          'Tambaram',
          'Adyar',
          'Velachery',
          'Pallavaram',
          'Kilpauk',
          'Chetpet',
          'Koyambedu',
          'Chennai Central',
          'Perambur',
          'Vadapalani',
          'Tambaram',
          'Pallavaram',
          'Kilpauk',
          'Chetpet',
          'Koyambedu',
          'Chennai Central',
          'Perambur',
          'Vadapalani',
          'Tambaram',
          'Pallavaram',
          'Kilpauk',
          'Chetpet',
          'Koyambedu',
          'Chennai Central',
          'Perambur',
          'Vadapalani',
          'Tambaram',
          'Pallavaram',
          'Kilpauk',
          'Chetpet',
          'Koyambedu',
          'Chennai Central',
          'Perambur',
          'Vadapalani',
        ];
      case 'Kolkata':
        return [
          'New Town',
          'Salt Lake City',
          'Howrah',
          'Dum Dum',
          'Kolkata',
          'Howrah',
          'Dum Dum',
          'Kolkata',
          'Howrah',
          'Dum Dum',
        ];
      case 'Hyderabad':
        return [
          'Secunderabad',
          'Kukatpally',
          'Gachibowli',
          'Madhapur',
          'Hitech City',
          'Banjara Hills',
          'Ameerpet',
          'Koti',
          'LB Nagar',
          'Himayatnagar',
          'Miyapur'
        ];
      case 'Pune':
        return [
          'Aundh',
          'Baner',
          'Kothrud',
          'Shivajinagar',
          'Bavdhan',
          'Dehu Road',
          'Kondhwa',
          'Wakad',
          'Bhosari',
          'Bhawani Peth',
        ];
      case 'Ahmedabad':
        return [
          'Navrangpura',
          'Sarkhej',
          'Gandhinagar',
          'Bhavnagar',
          'Vadodara',
          'Rajkot',
          'Surat',
          'Gandhinagar',
          'Bhavnagar',
          'Vadodara',
          'Rajkot',
          'Surat',
          'Gandhinagar',
          'Bhavnagar',
          'Vadodara',
          'Rajkot',
          'Surat',
        ];
      case 'Jaipur':
        return [
          'Mansarovar',
          'Malviya Nagar',
          'C Scheme',
          'Jawahar Nagar',
          'Malviya Nagar',
          'C Scheme',
          'Jawahar Nagar',
          'Malviya Nagar',
          'C Scheme',
          'Jawahar Nagar',
        ];

      case 'Lucknow':
        return [
          'Gomti Nagar',
          'Hazratganj',
          'Barabanki',
          'Lakhnawala',
          'Gomti Nagar',
          'Hazratganj',
          'Barabanki',
          'Lakhnawala',
          'Gomti Nagar',
          'Hazratganj',
          'Barabanki',
          'Lakhnawala',
        ];
      case 'Kanpur':
        return [
          'Kanpur Nagar',
          'Agra',
          'Lucknow',
          'Farrukhabad',
          'Kanpur Nagar',
          'Agra',
          'Lucknow',
          'Farrukhabad',
          'Kanpur Nagar',
          'Agra',
          'Lucknow',
          'Farrukhabad',
        ];

      case 'Noida':
        return ['Sector 62', 'Sector 63', 'Sector 64', 'Sector 65'];
      case 'Bangalore':
        return [
          'Whitefield',
          'Koramangala',
          'Indiranagar',
        ];
      case 'Bihar':
        return [
          'Patna',
          'Gaya',
          'Bhagalpur',
          'Munger',
          'Darbhanga',
          'Bihar Sharif',
          'Muzaffarpur',
          'Buxar',
          'Nalanda',
          'Purnia',
        ];

      case 'Jharkhand':
        return [
          'Ranchi',
          'Dhanbad',
          'Jamshedpur',
          'Bokaro',
          'Ranchi',
          'Dhanbad',
          'Jamshedpur',
          'Bokaro',
          'Ranchi',
          'Dhanbad',
          'Jamshedpur',
          'Bokaro',
        ];

      case 'Odisha':
        return [
          'Bhubaneswar',
          'Cuttack',
          'Rourkela',
          'Berhampur',
        ];
        case 'Miyapur':
        return [
          'Miyapur',
          'Gachibowli',
          'Kukatpally',
          'Khajaguda',
        ];
      case 'Kerala':
        return [
          'Thiruvananthapuram',
          'Kochi',
          'Kozhikode',
          'Kollam',
        ];
      case 'West Bengal':
        return ['Kolkata', 'Howrah', 'Dum Dum', 'Siliguri'];

      case 'Uttar Pradesh':
        return ['Agra', 'Lucknow', 'Varanasi', 'Prayagraj'];

      case 'Maharashtra':
        return ['Mumbai', 'Pune', 'Nagpur', 'Nashik'];
      case 'Gujarat':
        return ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot'];

      case 'Rajasthan':
        return ['Jaipur', 'Udaipur', 'Jodhpur', 'Kota'];

      case 'Tamil Nadu':
        return ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli'];
      case 'Telangana':
        return ['Hyderabad', 'Warangal', 'Nizamabad', 'Karimnagar'];
      case 'Karnataka':
        return ['Bangalore', 'Mysore', 'Hubli-Dharwad', 'Mangalore'];

      case 'Andhra Pradesh':
        return ['Vizag', 'Tirupati', 'Kurnool', 'Anantapur'];

      case 'Assam':
        return ['Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat'];
      case 'Haryana':
        return ['Faridabad', 'Gurgaon', 'Panipat', 'Ambala'];

      case 'Chhattisgarh':
        return ['Raipur', 'Bilaspur', 'Korba', 'Durg'];

      case 'Himachal Pradesh':
        return ['Shimla', 'Manali', 'Dharamshala', 'Kullu'];
      case 'Madhya Pradesh':
        return ['Bhopal', 'Indore', 'Jabalpur', 'Gwalior'];

      case 'Manipur':
        return ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur'];

      case 'Meghalaya':
        return ['Shillong', 'Tura', 'Jowai', 'Nongpoh'];
      case 'Nagaland':
        return ['Kohima', 'Dimapur', 'Mokokchung', 'Tuensang'];

      case 'Sikkim':
        return ['Gangtok', 'Namchi', 'Mangan', 'Ravangla'];

      case 'Tripura':
        return ['Agartala', 'Udaipur', 'Dharmanagar', 'Kailashahar'];
      case 'Uttarakhand':
        return ['Dehradun', 'Haridwar', 'Roorkee', 'Haldwani'];

      case 'Goa':
        return ['Panjim', 'Margao', 'Vasco Da Gama', 'Mapusa'];

      case 'Arunachal Pradesh':
        return ['Itanagar', 'Tawang', 'Bomdila', 'Pasighat'];
      case 'Jammu and Kashmir':
        return ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla'];

      case 'Ladakh':
        return ['Kargil', 'Leh', 'Zanskar', 'Pangong'];

      case 'Punjab':
        return ['Chandigarh', 'Ludhiana', 'Amritsar', 'Jalandhar'];
      case 'Uttaranchal':
        return ['Dehradun', 'Haridwar', 'Roorkee', 'Haldwani'];

      case 'Andaman and Nicobar Islands':
        return [
          'Port Blair',
          'Car Nicobar',
          'Mayabunder',
          'North and Middle Andaman'
        ];

      case 'Dadra and Nagar Haveli and Daman and Diu':
        return ['Daman', 'Diu', 'Dadra and Nagar Haveli', 'Silvassa'];
      case 'Delhi':
        return ['New Delhi', 'Gurgaon', 'Noida', 'Faridabad'];

      case 'Lakshadweep':
        return ['Kavaratti', 'Minicoy', 'Agatti', 'Androth'];

      case 'Puducherry':
        return ['Pondicherry', 'Karaikal', 'Mahe', 'Yanam'];
      case 'Chandigarh':
        return ['Chandigarh', 'Ambala', 'Karnal', 'Zirakpur'];

      case 'Daman and Diu':
        return ['Daman', 'Diu', 'Dadra and Nagar Haveli', 'Silvassa'];
      case 'Vijayawada':
        return ['AshokNagar', 'Sing Nagar', 'Auto Nagar'];
      case 'Bhopal':
        return ['Bhopal', 'Indore', 'Jabalpur', 'Gwalior'];
      case 'Indore':
        return ['Indore', 'Bhopal', 'Jabalpur', 'Gwalior'];
      case 'Jabalpur':
        return ['Jabalpur', 'Bhopal', 'Indore', 'Gwalior'];
      case 'Gwalior':
        return ['Gwalior', 'Bhopal', 'Indore', 'Jabalpur'];

      case 'Udaipur':
        return ['Udaipur', 'Jaipur', 'Jodhpur', 'Kota'];
      case 'Jodhpur':
        return ['Jodhpur', 'Udaipur', 'Jaipur', 'Kota'];
          case 'tiruvuru':
        return ['tiruvuru'];

      case 'Kota':
        return ['Kota', 'Udaipur', 'Jaipur', 'Jodhpur'];
        case 'vissannapeta':
        return ['kalagara', 'ramachandrapuram', 'putrela', 'korlamanda',

       
'Chandrupatla', 'Kondaparva', 'Maremanda', 'Narasapuram', 'Tata Kuntla', 'Tella Devarapalle', 'Vemireddipalle', 'Vissannapeta'	

        
        ];
        case "Hindupur":
        return ['Hindupur', 
        'Bevina Halli',
'Brahmanapalli', 'Chennampalli', 'Chinthalapalle', 'Chowdahalli', 
'Doddaballapur', 'Gundlahalli', 'Hindupur', 'Honnali', 'Kambadur', 'Karnataka', 'Kothapalle', 'Maddikera', 'Madhugiri', 'Madhugiri Taluk', 'Madhugiri Town', 'Nallur', 'Narasimharajapura', 'Narasimharajapura Taluk', 'Narasimharajapura Town'
        ];
        

      default:
        return ['Area 1', 'Area 2', 'Area 3'];
    }
  }



  void _filterAreas() {
    setState(() {
      filteredAreas = areas
          .where((area) =>
              area.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _updateLocation(String area) async {
    final locationController = Get.find<LocationController>();

    // Fix: Pass both city and state as positional arguments
    locationController.setManualLocation(
        widget.selectedCity, widget.selectedState);

    try {
      final response = await http.get(
        Uri.parse(
          'http://13.200.179.78/adposts?location=$area&city=${widget.selectedCity}&state=${widget.selectedState}',
        ),
      );

      if (response.statusCode == 200) {
        final productsController = Get.find<ProductsController>();
        productsController.updateProducts(response.body);
      }
    } catch (e) {
      log('Error fetching ads: $e');
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Area in ${widget.selectedCity}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Area',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAreas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredAreas[index], style:  TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                       fontFamily: GoogleFonts.sanchez().fontFamily,
                    ),),
                  onTap: () => _updateLocation(filteredAreas[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
