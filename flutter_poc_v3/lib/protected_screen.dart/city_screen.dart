import 'package:flutter/material.dart';
import 'local_area_screen.dart';

class CityScreen extends StatefulWidget {
  final String selectedState;

  const CityScreen({Key? key, required this.selectedState}) : super(key: key);

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> cities = [];
  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    // Add cities based on selected state
    cities = getCitiesForState(widget.selectedState);
    filteredCities = cities;
    _searchController.addListener(_filterCities);
  }

  List<String> getCitiesForState(String state) {
    // Add your city data here based on the state
    // This is a sample list
    switch (state) {
      case 'Maharashtra':
        return ['Mumbai', 'Pune', 'Nagpur', 'Thane', 'Nashik'];
      case 'Karnataka':
        return ['Bangalore', 'Mysore', 'Hubli', 'Mangalore'];
        case 'Gujarat':
        return ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar'];
        case 'Rajasthan':
        return ['Jaipur', 'Udaipur', 'Jodhpur', 'Kota', 'Ajmer'];

      case 'Tamil Nadu':
        return ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem'];
        case 'Uttar Pradesh':
        return ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Prayagraj'];
        
        case 'West Bengal':
        return ['Kolkata', 'Asansol', 'Siliguri', 'Durgapur', 'Howrah'];
        
        case 'Andhra Pradesh':
        return ['Visakhapatnam', 'Vijayawada', 'Guntur', 'Tirupati', 'Nellore'];
        case 'Telangana':
        return ['Hyderabad', 'Warangal', 'Nizamabad', 'Karimnagar', 'Khammam'];
        
        case 'Kerala':
        return ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur', 'Palakkad'];
        
        case 'Bihar':
        return ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Darbhanga'];
        case 'Assam':
        return ['Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat', 'Tezpur'];
        
        case 'Jharkhand':
        return ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro Steel City', 'Deoghar'];
        
        case 'Odisha':
        return ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur'];
        case 'Chhattisgarh':
        return ['Raipur', 'Bilaspur', 'Durg', 'Bhilai', 'Korba'];
        
        case 'Haryana':
        return ['Faridabad', 'Gurgaon', 'Panipat', 'Ambala', 'Yamunanagar'];
        
        case 'Punjab':
        return ['Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala', 'Bathinda'];
        case 'Himachal Pradesh':
        return ['Shimla', 'Manali', 'Dharamshala', 'Solan', 'Kullu'];
        
        case 'Jammu and Kashmir':
        return ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla', 'Kathua'];
        
        case 'Uttarakhand':
        return ['Dehradun', 'Haridwar', 'Roorkee', 'Rajgarh', 'Haldwani'];
        case 'Goa':
        return ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda'];
        
        case 'Madhya Pradesh':
        return ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur', 'Ujjain'];
        
        case 'Manipur':
        return ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur', 'Kakching'];
        case 'Tripura':
        return ['Agartala', 'Udaipur', 'Dharmanagar', 'Belonia', 'Kailasahar'];
        
        case 'Arunachal Pradesh':
        return ['Itanagar', 'Naharlagun', 'Pasighat', 'Roing', 'Zoho'];
        
        case 'Nagaland':
        return ['Kohima', 'Dimapur', 'Mokokchung', 'Tuensang', 'Wokha'];
        case 'Sikkim':
        return ['Gangtok', 'Namchi', 'Mangan', 'Rabdna', 'Gyalshing'];
        
        case 'Meghalaya':
        return ['Shillong', 'Tura', 'Nongpang', 'Williamnagar', 'Jowai'];
        
        case 'Mizoram':
        return ['Aizawl', 'Lunglei', 'Champhai', 'Saiha', 'Serchhip'];
        case 'Andaman and Nicobar Islands':
        return ['Port Blair', 'Car Nicobar', 'Mayiladuthurai', 'Chittoor', 'Kavaratti'];
        
        case 'Dadra and Nagar Haveli and Daman and Diu':
        return ['Daman', 'Diu', 'Dadra', 'Silvassa', 'Gandhinagar'];
        
        case 'Lakshadweep':
        return ['Kavaratti', 'Agatti', 'Minicoy', 'Androth', 'Kalpeni'];
        case 'Delhi':
        return ['New Delhi', 'Gurgaon', 'Noida', 'Faridabad', 'Ghaziabad'];
        

      // Add more states and their cities
      default:
        return ['City 1', 'City 2', 'City 3']; // Default cities
    }
  }

  void _filterCities() {
    setState(() {
      filteredCities = cities
          .where((city) =>
              city.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select City in ${widget.selectedState}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search City',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredCities[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocalAreaScreen(
                          selectedState: widget.selectedState,
                          selectedCity: filteredCities[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
