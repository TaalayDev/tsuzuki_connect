/// Still-image scene backgrounds. Only the classroom and the main menu keep
/// a video (see `background_video_config.dart`); every other scene background
/// is a picture picked by background id and time of day.
class BackgroundImageConfig {
  BackgroundImageConfig._();

  static const basePath = 'assets/backgrounds/';

  /// Time keys used by the dialogue DSL (`.street('evening')` and so on).
  static const _night = 'night';
  static const _evening = 'evening';

  /// Asset file for each background id: `[day, evening, night]`.
  static const Map<String, List<String>> _files = {
    'street': [
      'Street_Spring_Day.webp',
      'Street_Spring_Evening.webp',
      'Street_Spring_Night.webp',
    ],
    'backstreet': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Afternoon.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'park': ['Park_Summer.webp', 'Park_Autumn.webp', 'Park_Autumn.webp'],
    'park_summer': ['Park_Summer.webp', 'Park_Summer.webp', 'Park_Summer.webp'],
    'park_autumn': ['Park_Autumn.webp', 'Park_Autumn.webp', 'Park_Autumn.webp'],
    'park_winter': ['Park_Winter.webp', 'Park_Winter.webp', 'Park_Winter.webp'],
    'temple': [
      'Temple_Spring_Day.webp',
      'Temple_Spring_Afternoon.webp',
      'Temple_Spring_Night.webp',
    ],
    'tatami_room': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'station': [
      'BusStop_Spring_Day.webp',
      'BusStop_Spring_Afternoon.webp',
      'BusStop_Spring_Night.webp',
    ],
    'train': ['Train_Day.webp', 'Train_Evening.webp', 'Train_Night.webp'],
    'cafe': ['Restaurant_A.webp', 'Restaurant_B.webp', 'Restaurant_B.webp'],
    'cafe_tables': [
      'Restaurant_A.webp',
      'Restaurant_B.webp',
      'Restaurant_B.webp',
    ],
    'izakaya': ['Restaurant_B.webp', 'Restaurant_B.webp', 'Restaurant_B.webp'],
    'apartment': [
      'Livingroom_Day.webp',
      'Livingroom_Day.webp',
      'Livingroom_Night.webp',
    ],
    'livingroom': [
      'Livingroom_Day.webp',
      'Livingroom_Day.webp',
      'Livingroom_Night.webp',
    ],
    'bedroom': [
      'Bedroom_Day.webp',
      'Bedroom_Evening.webp',
      'Bedroom_Night_Dark.webp',
    ],
    'kitchen': ['Kitchen_Day.webp', 'Kitchen_Day.webp', 'Kitchen_Night.webp'],
    'bathroom': [
      'Bathroom_Foggy.webp',
      'Bathroom_Foggy.webp',
      'Bathroom_Foggy.webp',
    ],
    'apartment_exterior': [
      'Apartment_Exterior copy.webp',
      'Apartment_Exterior copy.webp',
      'Apartment_Exterior_Night.webp',
    ],
    'university_building': [
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
    ],
    'hallway': [
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
    ],
    'library': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'home_office': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'shopping_mall': [
      'City_Afternoon.webp',
      'City_Afternoon.webp',
      'City_Night.webp',
    ],
    'sitting_room': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'futon_room': [
      'Futon_Room.webp',
      'Futon_Room.webp',
      'Futon_Room_Night.webp',
    ],
    'laundromat': ['Laundromat.webp', 'Laundromat.webp', 'Laundromat.webp'],
    'city': ['City_Afternoon.webp', 'City_Afternoon.webp', 'City_Night.webp'],
    'apartment_hallway': [
      'Outdoor_Stairs.webp',
      'Outdoor_Stairs.webp',
      'Outdoor_Stairs.webp',
    ],
    'narrow_street': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Afternoon.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'suburban_street': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Afternoon.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'residential_gate': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Afternoon.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'shimokitazawa_street': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Afternoon.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'shimokitazawa_alley': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Afternoon.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'shimokitazawa_morning': [
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Day.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'shimokitazawa_night': [
      'Backstreet_Spring_Night.webp',
      'Backstreet_Spring_Night.webp',
      'Backstreet_Spring_Night.webp',
    ],
    'shimokitazawa_bar': [
      'Restaurant_B.webp',
      'Restaurant_B.webp',
      'Restaurant_B.webp',
    ],
    'harajuku_street': [
      'Street_Spring_Day.webp',
      'Street_Spring_Evening.webp',
      'Street_Spring_Night.webp',
    ],
    'david_apartment': [
      'Livingroom_Day.webp',
      'Livingroom_Day.webp',
      'Livingroom_Night.webp',
    ],
    'margaret_apartment': [
      'Livingroom_Day.webp',
      'Livingroom_Day.webp',
      'Livingroom_Night.webp',
    ],
    'yamamoto_kitchen': [
      'Kitchen_Day.webp',
      'Kitchen_Day.webp',
      'Kitchen_Night.webp',
    ],
    'bookshop': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'bookshop_event_space': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'library_stacks': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'coffee_shop': [
      'Restaurant_A.webp',
      'Restaurant_B.webp',
      'Restaurant_B.webp',
    ],
    'clinic_waiting_room': [
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
    ],
    'clinic_exam_room': [
      'Classroom_Day.webp',
      'Classroom_Day.webp',
      'Classroom_Day.webp',
    ],
    'pharmacy': [
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
    ],
    'community_center_hallway': [
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
      'School_Hallway_Day.webp',
    ],
    'community_center_room': [
      'Sitting_Room.webp',
      'Sitting_Room.webp',
      'Sitting_Room_Dark.webp',
    ],
    'narita_arrivals': [
      'Cafeteria_Day.webp',
      'Cafeteria_Day.webp',
      'Cafeteria_Day.webp',
    ],
    'narita_departures': [
      'Cafeteria_Day.webp',
      'Cafeteria_Day.webp',
      'Cafeteria_Day.webp',
    ],
    'tokyo_train_window': [
      'Train_Day.webp',
      'Train_Evening.webp',
      'Train_Night.webp',
    ],
    'yoyogi_park': ['Park_Summer.webp', 'Park_Autumn.webp', 'Park_Autumn.webp'],
    'phone_screen': [
      'Bedroom_Night_Dark.webp',
      'Bedroom_Night_Dark.webp',
      'Bedroom_Night_Dark.webp',
    ],
    'airport': ['City_Morning.webp', 'City_Afternoon.webp', 'City_Night.webp'],
  };

  static bool hasImage(String? id) => id != null && _files.containsKey(id);

  /// Asset path for [id] at [time], or null when the id has no picture.
  static String? assetFor(String? id, [String? time]) {
    final files = id == null ? null : _files[id];
    if (files == null) return null;
    final index = switch (time) {
      _night => 2,
      _evening => 1,
      _ => 0,
    };
    return '$basePath${files[index]}';
  }
}
