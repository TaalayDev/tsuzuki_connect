/**
 * TSUZUKI CONNECT - Background Assets
 * Static fields for background image paths
 */

export class BackgroundAssets {
    static BASE_PATH = 'assets/backgrounds/';

    // Quick access static fields
    static get STREET_MORNING() { return `${this.BASE_PATH}Street_Spring_Day.webp`; }
    static get STREET_EVENING() { return `${this.BASE_PATH}Street_Spring_Evening.webp`; }
    static get STREET_NIGHT() { return `${this.BASE_PATH}Street_Spring_Night.webp`; }

    static get CLASSROOM_DAY() { return `${this.BASE_PATH}Classroom_Day.webp`; }

    static get HALLWAY_DAY() { return `${this.BASE_PATH}School_Hallway_Day.webp`; }

    static get TRAIN_DAY() { return `${this.BASE_PATH}Train_Day.webp`; }
    static get TRAIN_EVENING() { return `${this.BASE_PATH}Train_Evening.webp`; }
    static get TRAIN_NIGHT() { return `${this.BASE_PATH}Train_Night.webp`; }

    static get APARTMENT_DAY() { return `${this.BASE_PATH}Bedroom_Day.webp`; }
    static get APARTMENT_NIGHT() { return `${this.BASE_PATH}Bedroom_Night (1).webp`; }

    static get CAFE_DAY() { return `${this.BASE_PATH}Cafeteria_Day.webp`; }

    static get IZAKAYA_EVENING() { return `${this.BASE_PATH}Restaurant_B.webp`; }

    static get STATION_DAY() { return `${this.BASE_PATH}BusStop_Spring_Day.webp`; }

    static get PARK_DAY() { return `${this.BASE_PATH}Temple_Spring_Day.webp`; }

    static PATHS = {
        // Classroom
        'classroom': {
            'morning': 'Classroom_Day.webp',
            'afternoon': 'Classroom_Day.webp',
            'evening': 'Classroom_Day.webp', // Fallback
            'night': 'Classroom_Day.webp'    // Fallback
        },
        // Hallway
        'hallway': {
            'morning': 'School_Hallway_Day.webp',
            'afternoon': 'School_Hallway_Day.webp',
            'evening': 'School_Hallway_Day.webp',
            'night': 'School_Hallway_Day.webp'
        },
        // Street
        'street': {
            'morning': 'Street_Spring_Day.webp',
            'afternoon': 'Street_Spring_Day.webp',
            'evening': 'Street_Spring_Evening.webp',
            'night': 'Street_Spring_Night.webp'
        },
        // Backstreet (can be used for 'street' too or separate)
        'backstreet': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        // Apartment
        'apartment': {
            'morning': 'Livingroom_Day.webp',
            'afternoon': 'Livingroom_Day.webp',
            'evening': 'Livingroom_Night.webp',
            'night': 'Livingroom_Dark.webp'
        },
        // Cafe / Cafeteria
        'cafe': {
            'morning': 'Cafeteria_Day.webp',
            'afternoon': 'Cafeteria_Day.webp',
            'evening': 'Cafeteria_Day.webp',
            'night': 'Cafeteria_Day.webp'
        },
        // Restaurant / Izakaya
        'izakaya': {
            'morning': 'Restaurant_A.webp',
            'afternoon': 'Restaurant_A.webp',
            'evening': 'Restaurant_B.webp',
            'night': 'Restaurant_B.webp'
        },
        // Train
        'train': {
            'morning': 'Train_Day.webp',
            'afternoon': 'Train_Day.webp',
            'evening': 'Train_Evening.webp',
            'night': 'Train_Night.webp'
        },
        // Station / Bus Stop
        'station': {
            'morning': 'BusStop_Spring_Day.webp',
            'afternoon': 'BusStop_Spring_Afternoon.webp',
            'evening': 'BusStop_Spring_Afternoon.webp',
            'night': 'BusStop_Spring_Night.webp'
        },
        // Park / Temple
        'park': {
            'morning': 'Temple_Spring_Day.webp',
            'afternoon': 'Temple_Spring_Afternoon.webp',
            'evening': 'Temple_Spring_Afternoon.webp',
            'night': 'Temple_Spring_Night.webp'
        },
        // City
        'city': {
            'morning': 'City_Morning.webp',
            'afternoon': 'City_Morning.webp',
            'evening': 'City_Afternoon.webp',
            'night': 'City_Night.webp'
        },
        // Bathroom
        'bathroom': {
            'morning': 'Bathroom.webp',
            'afternoon': 'Bathroom.webp',
            'evening': 'Bathroom.webp',
            'night': 'Bathroom.webp'
        },
        // Bedroom
        'bedroom': {
            'morning': 'Bedroom_Day.webp',
            'afternoon': 'Bedroom_Day.webp',
            'evening': 'Bedroom_Evening.webp',
            'night': 'Bedroom_Night_Dark.webp'
        },
        // Laundromat
        'laundromat': {
            'morning': 'Laundromat.webp',
            'afternoon': 'Laundromat.webp',
            'evening': 'Laundromat.webp',
            'night': 'Laundromat.webp'
        },
        // Living room
        'livingroom': {
            'morning': 'Livingroom_Day.webp',
            'afternoon': 'Livingroom_Day.webp',
            'evening': 'Livingroom_Night.webp',
            'night': 'Livingroom_Dark.webp'
        },
        // Apartment Exterior
        'apartment_exterior': {
            'morning': 'Apartment_Exterior.webp',
            'afternoon': 'Apartment_Exterior.webp',
            'evening': 'Apartment_Exterior_Night.webp',
            'night': 'Apartment_Exterior_Night.webp'
        },
        // Kitchen
        'kitchen': {
            'morning': 'Kitchen_Day.webp',
            'afternoon': 'Kitchen_Day.webp',
            'evening': 'Kitchen_Night.webp',
            'night': 'Kitchen_Night.webp'
        },
        'kitchen_small': {
            'morning': 'Small_Apartment_Kitchen.webp',
            'afternoon': 'Small_Apartment_Kitchen.webp',
            'evening': 'Small_Apartment_Kitchen_Night.webp',
            'night': 'Small_Apartment_Kitchen_Night.webp'
        },
        // Japanese Rooms
        'futon_room': {
            'morning': 'Futon_Room.webp',
            'afternoon': 'Futon_Room.webp',
            'evening': 'Futon_Room_Night.webp',
            'night': 'Futon_Room_Night.webp'
        },
        'sitting_room': {
            'morning': 'Sitting_Room.webp',
            'afternoon': 'Sitting_Room.webp',
            'evening': 'Sitting_Room_Dark.webp',
            'night': 'Sitting_Room_Dark.webp'
        },
        // Onsen
        'onsen_exterior': {
            'morning': 'Onsen_Building.webp',
            'afternoon': 'Onsen_Building.webp',
            'evening': 'Onsen_Building_Night.webp',
            'night': 'Onsen_Building_Night.webp'
        },
        // Stairs
        'stairs': {
            'morning': 'Outdoor_Stairs.webp',
            'afternoon': 'Outdoor_Stairs.webp',
            'evening': 'Outdoor_Stairs.webp',
            'night': 'Outdoor_Stairs.webp'
        },
        // Street Variations
        'street_rain': {
            'morning': 'Street_Spring_Rain.webp',
            'afternoon': 'Street_Spring_Rain.webp',
            'evening': 'Street_Spring_Rain.webp',
            'night': 'Street_Spring_Rain.webp'
        },
        'street_summer': {
            'morning': 'Street_Summer_Day.webp',
            'afternoon': 'Street_Summer_Day.webp',
            'evening': 'Street_Summer_Evening.webp',
            'night': 'Street_Summer_Night.webp'
        },
        'street_summer_stars': {
            'morning': 'Street_Summer_Stars.webp',
            'afternoon': 'Street_Summer_Stars.webp',
            'evening': 'Street_Summer_Stars.webp',
            'night': 'Street_Summer_Stars.webp'
        },
        'street_autumn': {
            'morning': 'Street_Autumn_Day.webp',
            'afternoon': 'Street_Autumn_Day.webp',
            'evening': 'Street_Autumn_Evening.webp',
            'night': 'Street_Autumn_Night.webp'
        },
        // Backstreet Seasonal
        'backstreet_summer': {
            'morning': 'Backstreet_Summer_Day.webp',
            'afternoon': 'Backstreet_Summer_Afternoon.webp',
            'evening': 'Backstreet_Summer_Night.webp',
            'night': 'Backstreet_Summer_Night.webp'
        },
        // Park/Temple Seasonal
        'park_summer': {
            'morning': 'Temple_Summer_Day.webp',
            'afternoon': 'Temple_Summer_Afternoon.webp',
            'evening': 'Temple_Summer_Night.webp',
            'night': 'Temple_Summer_Night.webp'
        },
        // Station Seasonal
        'station_summer': {
            'morning': 'BusStop_Summer_Day.webp',
            'afternoon': 'BusStop_Summer_Afternoon.webp',
            'evening': 'BusStop_Summer_Night.webp',
            'night': 'BusStop_Summer_Night.webp'
        },
        // Train Extras
        'train_rain': {
            'morning': 'Train_Day_Rain.webp',
            'afternoon': 'Train_Day_Rain.webp',
            'evening': 'Train_Night_Rain.webp',
            'night': 'Train_Night_Rain.webp'
        },
        'train_beach': {
            'morning': 'Train_beach.webp',
            'afternoon': 'Train_beach.webp',
            'evening': 'Train_beach.webp',
            'night': 'Train_beach.webp'
        },
        'train_tunnel': {
            'morning': 'Train_Tunnel.webp',
            'afternoon': 'Train_Tunnel.webp',
            'evening': 'Train_Tunnel.webp',
            'night': 'Train_Tunnel.webp'
        },
        // Story 5 custom ids mapped to existing backgrounds
        'suburban_street': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        'narrow_street': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        'residential_gate': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        'pharmacy': {
            'morning': 'Restaurant_A.webp',
            'afternoon': 'Restaurant_A.webp',
            'evening': 'Restaurant_A.webp',
            'night': 'Restaurant_A.webp'
        },
        'yamamoto_kitchen': {
            'morning': 'Kitchen_Day.webp',
            'afternoon': 'Kitchen_Day.webp',
            'evening': 'Kitchen_Day.webp',
            'night': 'Kitchen_Day.webp'
        },
        'community_center_hallway': {
            'morning': 'School_Hallway_Day.webp',
            'afternoon': 'School_Hallway_Day.webp',
            'evening': 'School_Hallway_Day.webp',
            'night': 'School_Hallway_Day.webp'
        },
        'community_center_room': {
            'morning': 'Classroom_Day.webp',
            'afternoon': 'Classroom_Day.webp',
            'evening': 'Classroom_Day.webp',
            'night': 'Classroom_Day.webp'
        },
        'david_apartment': {
            'morning': 'Livingroom_Day.webp',
            'afternoon': 'Livingroom_Day.webp',
            'evening': 'Livingroom_Night.webp',
            'night': 'Livingroom_Dark.webp'
        },
        'margaret_apartment': {
            'morning': 'Bedroom_Day.webp',
            'afternoon': 'Bedroom_Day.webp',
            'evening': 'Bedroom_Evening.webp',
            'night': 'Bedroom_Night_Dark.webp'
        },
        'clinic_waiting_room': {
            'morning': 'Sitting_Room.webp',
            'afternoon': 'Sitting_Room.webp',
            'evening': 'Sitting_Room_Dark.webp',
            'night': 'Sitting_Room_Dark.webp'
        },
        'clinic_exam_room': {
            'morning': 'Bathroom.webp',
            'afternoon': 'Bathroom.webp',
            'evening': 'Bathroom.webp',
            'night': 'Bathroom.webp'
        },
        // Story 6 custom ids
        'home_office': {
            'morning': 'Bedroom_Day.webp',
            'afternoon': 'Bedroom_Day.webp',
            'evening': 'Bedroom_Evening.webp',
            'night': 'Bedroom_Night_Dark.webp'
        },
        'phone_screen': {
            'morning': 'Bedroom_Day.webp',
            'afternoon': 'Bedroom_Day.webp',
            'evening': 'Bedroom_Evening.webp',
            'night': 'Bedroom_Night_Dark.webp'
        },
        'library_stacks': {
            'morning': 'Classroom_Day.webp',
            'afternoon': 'Classroom_Day.webp',
            'evening': 'Classroom_Day.webp',
            'night': 'Classroom_Day.webp'
        },
        'apartment_hallway': {
            'morning': 'School_Hallway_Day.webp',
            'afternoon': 'School_Hallway_Day.webp',
            'evening': 'School_Hallway_Day.webp',
            'night': 'School_Hallway_Day.webp'
        },
        'coffee_shop': {
            'morning': 'Cafeteria_Day.webp',
            'afternoon': 'Cafeteria_Day.webp',
            'evening': 'Cafeteria_Day.webp',
            'night': 'Cafeteria_Day.webp'
        },
        'bookshop_event_space': {
            'morning': 'Cafeteria_Day.webp',
            'afternoon': 'Cafeteria_Day.webp',
            'evening': 'Cafeteria_Day.webp',
            'night': 'Cafeteria_Day.webp'
        },
        // Story 7 custom ids
        'narita_arrivals': {
            'morning': 'BusStop_Spring_Day.webp',
            'afternoon': 'BusStop_Spring_Afternoon.webp',
            'evening': 'BusStop_Spring_Afternoon.webp',
            'night': 'BusStop_Spring_Night.webp'
        },
        'narita_departures': {
            'morning': 'BusStop_Spring_Day.webp',
            'afternoon': 'BusStop_Spring_Afternoon.webp',
            'evening': 'BusStop_Spring_Afternoon.webp',
            'night': 'BusStop_Spring_Night.webp'
        },
        'tokyo_train_window': {
            'morning': 'Train_Day.webp',
            'afternoon': 'Train_Day.webp',
            'evening': 'Train_Evening.webp',
            'night': 'Train_Night.webp'
        },
        'shimokitazawa_street': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        'shimokitazawa_alley': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        'shimokitazawa_morning': {
            'morning': 'Backstreet_Spring_Day.webp',
            'afternoon': 'Backstreet_Spring_Afternoon.webp',
            'evening': 'Backstreet_Spring_Afternoon.webp',
            'night': 'Backstreet_Spring_Night.webp'
        },
        'shimokitazawa_night': {
            'morning': 'Backstreet_Summer_Day.webp',
            'afternoon': 'Backstreet_Summer_Afternoon.webp',
            'evening': 'Backstreet_Summer_Night.webp',
            'night': 'Backstreet_Summer_Night.webp'
        },
        'shimokitazawa_bar': {
            'morning': 'Restaurant_A.webp',
            'afternoon': 'Restaurant_A.webp',
            'evening': 'Restaurant_B.webp',
            'night': 'Restaurant_B.webp'
        },
        'harajuku_street': {
            'morning': 'Street_Summer_Day.webp',
            'afternoon': 'Street_Summer_Day.webp',
            'evening': 'Street_Summer_Evening.webp',
            'night': 'Street_Summer_Night.webp'
        },
        'university_building': {
            'morning': 'Apartment_Exterior.webp',
            'afternoon': 'Apartment_Exterior.webp',
            'evening': 'Apartment_Exterior_Night.webp',
            'night': 'Apartment_Exterior_Night.webp'
        },
        'yoyogi_park': {
            'morning': 'Temple_Spring_Day.webp',
            'afternoon': 'Temple_Spring_Afternoon.webp',
            'evening': 'Temple_Spring_Afternoon.webp',
            'night': 'Temple_Spring_Night.webp'
        },
        'bookshop': {
            'morning': 'Cafeteria_Day.webp',
            'afternoon': 'Cafeteria_Day.webp',
            'evening': 'Cafeteria_Day.webp',
            'night': 'Cafeteria_Day.webp'
        }
    };

    /**
     * Get the full path for a background based on ID and time of day
     */
    static getPath(id, timeOfDay = 'afternoon') {
        const bg = this.PATHS[id] || this.PATHS['street']; // Fallback to street
        const file = bg[timeOfDay] || bg['afternoon'] || Object.values(bg)[0];
        return `${this.BASE_PATH}${file}`;
    }
}
