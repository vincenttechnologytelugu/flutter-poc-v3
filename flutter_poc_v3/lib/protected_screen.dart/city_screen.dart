  import 'package:flutter/material.dart';
import 'local_area_screen.dart';

class CityScreen extends StatefulWidget {
  final String selectedState;

  const CityScreen({super.key, required this.selectedState});

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
        return ['Mumbai', 'Pune', 'Nagpur', 'Thane', 'Nashik',
        'Solapur', 'Sangli', 'Satara', 'Kolhapur', 'Aurangabad',

        'Nanded', 'Amravati', 'Akola', 'Jalgaon', 'Ichalkaranji',
        'Parbhani', 'Wardha', 'Osmanabad', 'Hingoli', 'Nandurbar',
        'Dhule', 'Buldana', 'Jalna', 'Gadchiroli', 'Washim',
        'Yavatmal', 'Chandrapur', 'Gondia', 'Bhandara', 'Nagpur',
        'Sangli', 'Satara', 'Kolhapur', 'Aurangabad',

      
     
     
        
        ];
      case 'Karnataka':
        return ['Bangalore', 'Mysore', 'Hubli', 'Mangalore','ron',
        'Mysore', 'Hubli', 'Mangalore', 'Dharwad', 'Bidar', 'Belagavi',
        'Tumakuru', 'Gulbarga', 'Chikkaballapur', 'Raichur', 'Hassan', 'Shimoga',
        'Davanagere', 'Gadag', 'Kolar', 'Haveri', 'Udupi',
        'Hospet', 'Chamarajanagar', 'Koppal', 'Mandya', 'Raichur', 'Shimoga',
        'Davanagere', 'Gadag', 'Kolar', 'Haveri', 'Udupi',
        'Hospet', 'Chamarajanagar', 'Koppal', 'Mandya', 'Raichur', 'Shimoga', 'Davanagere', 'Gadag', 'Kolar', 'Haveri', 'Udupi',
   


        
        ];
        case 'Gujarat':
        return ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar',
        'Jamnagar', 'Junagadh', 'Gandhinagar', 'Dahod', 'Navsari', 'Bharuch',
        'Anand', 'Kheda', 'Panchmahal', 'Narmada', 'Mahesana', 'Aravalli',
        'Botad', 'Amreli', 'Gir Somnath', 'Tapi', 'Chhota Udaipur', 'Kachchh',
        'Surat', 'Vadodara', 'Rajkot', 'Bhavnagar',
        'Jamnagar', 'Junagadh', 'Gandhinagar', 'Dahod', 'Navsari', 'Bharuch',
        ];
        case 'Rajasthan':
        return ['Jaipur', 'Udaipur', 'Jodhpur', 'Kota', 'Alwar', 'Bikaner',
        'Jaisalmer', 'Ajmer', 'Bhilwara', 'Sikar', 'Bharatpur', 'Pali', 'Churu',
        'Chittorgarh', 'Barmer', 'Bundi', 'Dausa', 'Sawai Madhopur', 'Karauli',
        'Nagaur', 'Sriganganagar', 'Baran', 'Sawai Madhopur', 'Karauli',
        'Nagaur', 'Sriganganagar'
        
        ];

      case 'Tamil Nadu':
        return ['Chennai', 'Coimbatore', 'Madurai', 'Tiruchirappalli', 'Salem',
        'Kanchipuram', 'Vellore', 'Sivaganga', 'Nagapattinam', 'Theni', 'Tirunelveli',
        'Kumbakonam', 'Karaikudi', 'Kanchipuram', 'Vellore', 'Sivaganga', 'Nagapattinam', 'Theni', 'Tirunelveli', 'Kumbakonam', 'Karaikudi',
        'Kanchipuram', 'Vellore', 'Sivaganga', 'Nagapattinam', 'Theni', 'Tirunelveli', 'Kumbakonam', 'Karaikudi', 'Kanchipuram', 'Vellore', 'Sivaganga', 'Nagapattinam', 'Theni', 'Tirunelveli', 'Kumbakonam', 'Karaikudi',
      ];
        case 'Uttar Pradesh':
        return ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Prayagraj',

        'Meerut', 'Allahabad', 'Gorakhpur', 'Aligarh', 'Modinagar', 'Moradabad',
        'Noida', 'Bareilly', 'Saharanpur', 'Hapur', 'Bahraich', 'Budaun',
        'Bijnor', 'Etawah', 'Firozabad', 'Farrukhabad', 'Fatehpur', 'Faizabad',
        'Ghaziabad', 'Gurgaon', 'Gorakhpur', 'Aligarh', 'Modinagar', 'Moradabad',
        
        ];
        
        case 'West Bengal':
        return ['Kolkata', 'Asansol', 'Siliguri', 'Durgapur', 'Howrah',

        'Ranchi', 'Bardhaman', 'Kharagpur', 'Baharampur', 'Malda', 'Shiliguri',
        'Kolkata', 'Asansol', 'Siliguri', 'Durgapur', 'Howrah',

        
        ];
        
        case 'Andhra Pradesh':
        return ['Visakhapatnam', 'Vijayawada', 'Guntur', 'Tirupati', 'Nellore',
        'Kurnool', 'Kadapa', 'Anantapur', 'Vizianagaram', 'Rajahmundry', 'Kakinada',
        'Vijayanagaram', 'Eluru', 'Adoni', 'Chittoor', 'Nandyal', 'Kavali',
        'Nellore', 'Kurnool', 'Kadapa', 'Anantapur', 'Vizianagaram', 'Rajahmundry', 'Kakinada',
       


        
        ];
        case 'Telangana':
        return ['Hyderabad', 'Warangal', 'Nizamabad', 'Karimnagar', 'Khammam',

        'Ranga Reddy', 'Nalgonda', 'Khammam', 'Warangal', 'Nizamabad', 'Karimnagar',

        
        ];
        
        case 'Kerala':
        return ['Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur', 'Palakkad',
        'Alappuzha', 'Kollam', 'Kottayam', 'Kannur', 'Malappuram', 'Palakkad',
    
        'Palakkad',
        
        ];
        
        case 'Bihar':
        return ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur', 'Darbhanga',

        'Siwan', 'Muzaffarpur', 'Darbhanga', 'Siwan', 'Muzaffarpur', 'Darbhanga',
        

        
        ];
        case 'Assam':
        return ['Guwahati', 'Silchar', 'Dibrugarh', 'Jorhat', 'Tezpur',
        'Nagaon', 'Dhubri',

        
        ];
        
        case 'Jharkhand':
        return ['Ranchi', 'Jamshedpur', 'Dhanbad', 'Bokaro Steel City', 'Deoghar',



        
        ];
        
        case 'Odisha':
        return ['Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur',
        'Paradip', 'Balasore', 'Puri', 'Bhubaneswar', 'Cuttack', 'Rourkela', 'Berhampur', 'Sambalpur',
       
        ];
        case 'Chhattisgarh':
        return ['Raipur', 'Bilaspur', 'Durg', 'Bhilai', 'Korba',
        'Raipur', 'Bilaspur', 'Durg', 
      
      
        
        ];
        
        case 'Haryana':
        return ['Faridabad', 'Gurgaon', 'Panipat', 'Ambala', 'Yamunanagar',

        'Rohtak', 'Hisar', 'Jind', 'Sonipat', 'Karnal', 'Panchkula', 'Bhiwani',
        
        ];
        
        case 'Punjab':
        return ['Ludhiana', 'Amritsar', 'Jalandhar', 'Patiala', 'Bathinda',

      
        
        ];
        case 'Himachal Pradesh':
        return ['Shimla', 'Manali', 'Dharamshala', 'Solan', 'Kullu',
        'Kangra', 'Hamirpur', 'Bilaspur', 'Shimla', 'Manali',
         ];
        
        case 'Jammu and Kashmir':
        return ['Srinagar', 'Jammu', 'Anantnag', 'Baramulla', 'Kathua',
        'Srinagar', 'Jammu', 'Anantnag', 

        
        ];
        
        case 'Uttarakhand':
        return ['Dehradun', 'Haridwar', 'Roorkee', 'Rajgarh', 'Haldwani',
        'Nainital', 'Mussoorie', 'Dehradun', 'Haridwar', 'Roorkee', 'Rajgarh', 'Haldwani',
       
        
        ];
        case 'Goa':
        return ['Panaji', 'Margao', 'Vasco da Gama', 'Mapusa', 'Ponda',

        
        ];
        
        case 'Madhya Pradesh':
        return ['Bhopal', 'Indore', 'Gwalior', 'Jabalpur', 'Ujjain',


        
        ];
        
        case 'Manipur':
        return ['Imphal', 'Thoubal', 'Bishnupur', 'Churachandpur', 'Kakching',

        
        ];
        case 'Tripura':
        return ['Agartala', 'Udaipur', 'Dharmanagar', 'Belonia', 'Kailasahar',

        
        ];
        
        case 'Arunachal Pradesh':
        return ['Itanagar', 'Naharlagun', 'Pasighat', 'Roing', 'Zoho',
        
        
        ];
        
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
        case 'Puducherry':
        return ['Pondicherry', 'Karaikal', 'Mahe', 'Yanam', 'Puducherry'];
        case 'Chandigarh':
        return ['Chandigarh', 'Mohali', 'Panchkula', 'Zirakpur', 'Kharar'];
        case 'Dadra and Nagar Haveli':
        return ['Silvassa', 'Daman', 'Diu', 'Dadra', 'Gandhinagar', 'Ahmedabad',

        ];
        case 'Ladakh':
        return ['Leh', 'Kargil', 'Naharlagun', 'Bareilly', 'Rampur', 'Lucknow'];
        
       
      
     

        

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
