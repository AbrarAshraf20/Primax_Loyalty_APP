// lib/core/utils/pakistan_locations.dart
// This file contains data for Pakistani provinces and their cities

class PakistanLocation {
  static const Map<String, List<String>> provincesWithCities = {
    'Punjab': [
      'Lahore', 'Rawalpindi', 'Faisalabad', 'Multan', 'Gujranwala', 
      'Sialkot', 'Bahawalpur', 'Sargodha', 'Sahiwal', 'Sheikhupura',
      'Jhang', 'Rahim Yar Khan', 'Gujrat', 'Kasur', 'Okara', 
      'Wah Cantonment', 'Dera Ghazi Khan', 'Muzaffargarh', 'Chakwal',
      'Chiniot', 'Kamoke', 'Hafizabad', 'Attock', 'Bahawalnagar',
      'Mianwali', 'Jhelum', 'Khanewal', 'Burewala', 'Pakpattan',
      'Vehari', 'Khushab', 'Mandi Bahauddin', 'Lodhran', 'Bhakkar',
      'Layyah', 'Narowal', 'Nankana Sahib', 'Murree', 'Toba Tek Singh',
      'Chichawatni', 'Kot Addu', 'Pattoki'
    ],
    'Sindh': [
      'Karachi', 'Hyderabad', 'Sukkur', 'Larkana', 'Nawabshah',
      'Mirpur Khas', 'Jacobabad', 'Shikarpur', 'Khairpur', 'Tando Adam',
      'Dadu', 'Thatta', 'Badin', 'Tando Allahyar', 'Matiari',
      'Naushahro Feroze', 'Shaheed Benazirabad', 'Ghotki', 'Sanghar',
      'Umerkot', 'Kashmor', 'Kandhkot', 'Kotri'
    ],
    'Khyber Pakhtunkhwa': [
      'Peshawar', 'Mardan', 'Swat', 'Abbottabad', 'Kohat',
      'Bannu', 'Dera Ismail Khan', 'Nowshera', 'Mingora', 'Charsadda',
      'Mansehra', 'Swabi', 'Haripur', 'Malakand', 'Batkhela',
      'Lakki Marwat', 'Paharpur', 'Karak', 'Hangu', 'Chitral',
      'Tank', 'Timergara', 'Dir', 'Shabqadar', 'Topi',
      'Daggar', 'Alpuri', 'Besham', 'Saidu Sharif'
    ],
    'Balochistan': [
      'Quetta', 'Turbat', 'Khuzdar', 'Chaman', 'Hub',
      'Sibi', 'Zhob', 'Gwadar', 'Kalat', 'Dera Murad Jamali',
      'Dera Allah Yar', 'Mastung', 'Nushki', 'Loralai', 'Pishin',
      'Jaffarabad', 'Awaran', 'Kharan', 'Musakhel', 'Barkhan',
      'Ziarat', 'Uthal', 'Panjgur'
    ],
    'Islamabad Capital Territory': [
      'Islamabad'
    ],
    'Gilgit-Baltistan': [
      'Gilgit', 'Skardu', 'Chilas', 'Astore', 'Gahkuch',
      'Khaplu', 'Shigar', 'Aliabad', 'Karimabad', 'Hunza',
      'Ghanche', 'Nagar', 'Darel', 'Tangir', 'Ghizer'
    ],
    'Azad Jammu and Kashmir': [
      'Muzaffarabad', 'Mirpur', 'Kotli', 'Bhimber', 'Rawalakot',
      'Bagh', 'Hattian', 'Poonch', 'Neelum', 'Haveli',
      'Sadhnuti', 'Pallandri'
    ]
  };

  // Get a list of all provinces
  static List<String> get provinces => provincesWithCities.keys.toList();

  // Get cities for a given province
  static List<String> getCitiesForProvince(String province) {
    return provincesWithCities[province] ?? [];
  }

  // Get all cities across all provinces
  static List<String> get allCities {
    final allCities = <String>[];
    provincesWithCities.values.forEach((cities) {
      allCities.addAll(cities);
    });
    return allCities..sort();
  }

  // Search cities by query
  static List<String> searchCities(String query) {
    if (query.isEmpty) return [];
    
    final searchQuery = query.toLowerCase();
    return allCities
        .where((city) => city.toLowerCase().contains(searchQuery))
        .toList();
  }
}