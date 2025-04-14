-- Database creation
CREATE DATABASE WeddingPlanner;
USE WeddingPlanner;

-- Bride and Groom details
CREATE TABLE Couple (
    couple_id INT PRIMARY KEY AUTO_INCREMENT,
    bride_name VARCHAR(100) NOT NULL,
    groom_name VARCHAR(100) NOT NULL,
    wedding_date DATE NOT NULL,
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    budget DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Family members from both sides
CREATE TABLE Family (
    family_id INT PRIMARY KEY AUTO_INCREMENT,
    couple_id INT,
    name VARCHAR(100) NOT NULL,
    relation VARCHAR(50) NOT NULL,
    side ENUM('Bride', 'Groom') NOT NULL,
    contact_number VARCHAR(15),
    role_in_wedding VARCHAR(100),
    FOREIGN KEY (couple_id) REFERENCES Couple(couple_id)
);

-- Wedding events schedule
CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    couple_id INT,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    description TEXT,
    dress_code VARCHAR(100),
    FOREIGN KEY (couple_id) REFERENCES Couple(couple_id)
);

-- Venues for different events
CREATE TABLE Venues (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    capacity INT,
    contact_person VARCHAR(100),
    contact_number VARCHAR(15),
    cost_per_day DECIMAL(10,2),
    amenities TEXT
);

-- Event-Venue mapping
CREATE TABLE EventVenues (
    event_venue_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    venue_id INT,
    booking_date DATE NOT NULL,
    setup_time TIME NOT NULL,
    teardown_time TIME NOT NULL,
    special_requirements TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (venue_id) REFERENCES Venues(venue_id)
);

-- Guest list management
CREATE TABLE Guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    couple_id INT,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_number VARCHAR(15),
    email VARCHAR(100),
    side ENUM('Bride', 'Groom', 'Both') NOT NULL,
    rsvp_status ENUM('Confirmed', 'Pending', 'Declined') DEFAULT 'Pending',
    dietary_restrictions TEXT,
    FOREIGN KEY (couple_id) REFERENCES Couple(couple_id)
);

-- Guest attendance for each event
CREATE TABLE GuestAttendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    event_id INT,
    is_attending BOOLEAN DEFAULT FALSE,
    special_requests TEXT,
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- Hotel accommodations
CREATE TABLE Hotels (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    contact_number VARCHAR(15),
    star_rating INT,
    amenities TEXT,
    cost_per_night DECIMAL(10,2)
);

-- Room bookings for guests
CREATE TABLE RoomBookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT,
    guest_id INT,
    room_type VARCHAR(50) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    room_number VARCHAR(20),
    cost DECIMAL(10,2),
    special_requests TEXT,
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id)
);

-- Vendor categories
CREATE TABLE VendorCategories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Vendors for various services
CREATE TABLE Vendors (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    vendor_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    service_description TEXT,
    cost DECIMAL(10,2),
    rating DECIMAL(3,1),
    FOREIGN KEY (category_id) REFERENCES VendorCategories(category_id)
);

-- Event-Vendor mapping
CREATE TABLE EventVendors (
    event_vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    vendor_id INT,
    service_details TEXT,
    start_time TIME,
    end_time TIME,
    cost DECIMAL(10,2),
    payment_status ENUM('Paid', 'Partial', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Catering services
CREATE TABLE Catering (
    catering_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    cuisine_type VARCHAR(100) NOT NULL,
    menu_description TEXT NOT NULL,
    serving_style ENUM('Buffet', 'Plated', 'Family Style') NOT NULL,
    per_plate_cost DECIMAL(10,2),
    minimum_guests INT,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Event catering details
CREATE TABLE EventCatering (
    event_catering_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    catering_id INT,
    estimated_guests INT NOT NULL,
    special_requests TEXT,
    service_time TIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (catering_id) REFERENCES Catering(catering_id)
);

-- Decorations
CREATE TABLE Decorations (
    decoration_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    theme VARCHAR(100),
    color_scheme VARCHAR(100),
    flower_arrangements TEXT,
    lighting_type VARCHAR(100),
    cost DECIMAL(10,2),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Event decorations
CREATE TABLE EventDecorations (
    event_decoration_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    decoration_id INT,
    setup_time TIME NOT NULL,
    teardown_time TIME NOT NULL,
    special_requests TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (decoration_id) REFERENCES Decorations(decoration_id)
);

-- Entertainment options
CREATE TABLE Entertainment (
    entertainment_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    entertainment_type VARCHAR(100) NOT NULL,
    description TEXT,
    duration_minutes INT,
    cost DECIMAL(10,2),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Event entertainment
CREATE TABLE EventEntertainment (
    event_entertainment_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    entertainment_id INT,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    special_requests TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (entertainment_id) REFERENCES Entertainment(entertainment_id)
);

-- Photography/Videography
CREATE TABLE MediaServices (
    media_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    service_type ENUM('Photography', 'Videography', 'Both') NOT NULL,
    package_name VARCHAR(100),
    hours_included INT,
    delivery_timeline VARCHAR(100),
    cost DECIMAL(10,2),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Event media coverage
CREATE TABLE EventMedia (
    event_media_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    media_id INT,
    coverage_start TIME NOT NULL,
    coverage_end TIME NOT NULL,
    special_requests TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (media_id) REFERENCES MediaServices(media_id)
);

-- Transportation services
CREATE TABLE Transportation (
    transport_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    vehicle_type VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    cost_per_hour DECIMAL(10,2),
    minimum_hours INT,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Event transportation
CREATE TABLE EventTransport (
    event_transport_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    transport_id INT,
    pickup_time TIME NOT NULL,
    pickup_location TEXT NOT NULL,
    dropoff_location TEXT NOT NULL,
    special_requests TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (transport_id) REFERENCES Transportation(transport_id)
);

-- Beauty services
CREATE TABLE BeautyServices (
    beauty_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_id INT,
    service_type VARCHAR(100) NOT NULL,
    description TEXT,
    duration_minutes INT,
    cost DECIMAL(10,2),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Event beauty appointments
CREATE TABLE EventBeauty (
    event_beauty_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    beauty_id INT,
    person_id INT, -- could be bride, groom, or family member
    appointment_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    special_requests TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (beauty_id) REFERENCES BeautyServices(beauty_id)
);

-- Wedding checklist items
CREATE TABLE Checklist (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    couple_id INT,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    due_date DATE,
    assigned_to VARCHAR(100),
    status ENUM('Not Started', 'In Progress', 'Completed') DEFAULT 'Not Started',
    notes TEXT,
    FOREIGN KEY (couple_id) REFERENCES Couple(couple_id)
);

-- Budget tracking
CREATE TABLE Budget (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    couple_id INT,
    category VARCHAR(100) NOT NULL,
    estimated_cost DECIMAL(10,2) NOT NULL,
    actual_cost DECIMAL(10,2),
    vendor_id INT,
    payment_status ENUM('Paid', 'Partial', 'Pending') DEFAULT 'Pending',
    payment_date DATE,
    notes TEXT,
    FOREIGN KEY (couple_id) REFERENCES Couple(couple_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Seating arrangements
CREATE TABLE SeatingArrangements (
    seating_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    table_number VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,
    guest_list TEXT, -- or could be normalized further
    special_notes TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- Gifts registry
CREATE TABLE GiftRegistry (
    gift_id INT PRIMARY KEY AUTO_INCREMENT,
    couple_id INT,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    store_name VARCHAR(100),
    price DECIMAL(10,2),
    quantity_requested INT,
    quantity_received INT DEFAULT 0,
    FOREIGN KEY (couple_id) REFERENCES Couple(couple_id)
);

-- Sample data insertion
INSERT INTO VendorCategories (category_name, description) VALUES
('Catering', 'Food and beverage services'),
('Decoration', 'Event decoration and floral arrangements'),
('Entertainment', 'DJ, bands, performers'),
('Photography', 'Photo and video services'),
('Transportation', 'Vehicle rentals'),
('Beauty', 'Hair, makeup, spa services'),
('Venue', 'Event locations'),
('Accommodation', 'Hotels and lodging');

-- Insert sample venues
INSERT INTO Venues (venue_name, address, capacity, contact_person, contact_number, cost_per_day, amenities) VALUES
('Grand Ballroom', '123 Luxury Lane, Mumbai', 500, 'Mr. Sharma', '9876543210', 250000, 'Air conditioning, stage, dance floor, parking'),
('Beachside Resort', '456 Ocean Drive, Goa', 300, 'Ms. Pereira', '8765432109', 180000, 'Pool, beach access, outdoor seating'),
('Garden Palace', '789 Green Road, Bangalore', 400, 'Mr. Patel', '7654321098', 200000, 'Outdoor garden, tent options, parking'),
('Royal Banquet Hall', '321 King Street, Delhi', 600, 'Ms. Singh', '6543210987', 300000, 'Grand ballroom, VIP lounge, valet parking'),
('Poolside Venue', '654 Waterfront, Jaipur', 200, 'Mr. Mehta', '5432109876', 150000, 'Infinity pool, cabanas, bar area');

-- Insert sample hotels
INSERT INTO Hotels (hotel_name, address, contact_number, star_rating, amenities, cost_per_night) VALUES
('Taj Mahal Palace', '1 Apollo Bunder, Mumbai', '9876543210', 5, 'Pool, spa, restaurants, concierge', 25000),
('The Oberoi', 'Nariman Point, Mumbai', '8765432109', 5, 'Beach view, fine dining, business center', 22000),
('ITC Grand Central', '287 Dr Babasaheb Ambedkar Rd, Mumbai', '7654321098', 5, 'Luxury rooms, multiple restaurants, pool', 20000),
('Hyatt Regency', 'Sahar Airport Road, Mumbai', '6543210987', 4, 'Airport shuttle, fitness center, spa', 15000),
('Trident Nariman Point', 'Nariman Point, Mumbai', '5432109876', 4, 'Sea view, conference rooms, restaurants', 18000);

-- Insert sample couple
INSERT INTO Couple (bride_name, groom_name, wedding_date, contact_number, email, address, budget) VALUES
('Priya Sharma', 'Rahul Patel', '2023-12-15', '9123456780', 'priya.rahul@example.com', '456 Wedding Lane, Mumbai', 5000000);

-- Insert family members
INSERT INTO Family (couple_id, name, relation, side, contact_number, role_in_wedding) VALUES
(1, 'Monica', 'Mother', 'Bride', '9123456781', 'Primary coordinator'),
(1, 'Vimal', 'Father', 'Bride', '9123456782', 'Financial decisions'),
(1, 'Sneha', 'Sister', 'Bride', '9123456783', 'Bridesmaid'),
(1, 'Manoj', 'Father', 'Groom', '9123456784', 'Primary coordinator'),
(1, 'Sangeeta', 'Mother', 'Groom', '9123456785', 'Cultural ceremonies'),
(1, 'Radhika', 'Sister', 'Groom', '9123456786', 'Design Decorate-theme');
-- Insert events for 5-day wedding
INSERT INTO Events (couple_id, event_name, event_date, start_time, end_time, description, dress_code) VALUES
-- Day 1: Pool Party
(1, 'Welcome Pool Party', '2023-12-11', '16:00:00', '22:00:00', 'Casual welcome event with poolside fun', 'Casual/Beachwear'),

-- Day 2: Ganesh Pooja and Mehendi
(1, 'Ganesh Pooja', '2023-12-12', '09:00:00', '11:00:00', 'Traditional blessing ceremony', 'Traditional Indian'),
(1, 'Mehendi Ceremony', '2023-12-12', '16:00:00', '21:00:00', 'Henna application and dance', 'Colorful traditional'),

-- Day 3: Haldi and Sangeet
(1, 'Haldi Ceremony', '2023-12-13', '10:00:00', '12:00:00', 'Turmeric application ritual', 'Yellow attire'),
(1, 'Sangeet Night', '2023-12-13', '19:00:00', '23:00:00', 'Musical night with performances', 'Glamorous Indian'),

-- Day 4: Wedding Ceremonies
(1, 'Baraat and Wedding', '2023-12-14', '15:00:00', '20:00:00', 'Main wedding ceremony', 'Bride: Red lehenga, Groom: Sherwani'),
(1, 'Reception', '2023-12-14', '20:30:00', '23:30:00', 'Evening reception with dinner', 'Formal attire'),

-- Day 5: Post-wedding brunch
(1, 'Farewell Brunch', '2023-12-15', '11:00:00', '14:00:00', 'Casual farewell gathering', 'Casual');

-- Assign venues to events
INSERT INTO EventVenues (event_id, venue_id, booking_date, setup_time, teardown_time) VALUES
(1, 5, '2023-12-11', '14:00:00', '23:00:00'), -- Pool party at poolside venue
(2, 3, '2023-12-12', '08:00:00', '12:00:00'), -- Pooja at garden palace
(3, 3, '2023-12-12', '15:00:00', '22:00:00'), -- Mehendi at garden palace
(4, 2, '2023-12-13', '09:00:00', '13:00:00'), -- Haldi at beachside resort
(5, 1, '2023-12-13', '18:00:00', '23:30:00'), -- Sangeet at grand ballroom
(6, 4, '2023-12-14', '14:00:00', '21:00:00'), -- Wedding at royal banquet
(7, 1, '2023-12-14', '19:30:00', '23:59:00'), -- Reception at grand ballroom
(8, 2, '2023-12-15', '10:00:00', '15:00:00'); -- Brunch at beachside resort

-- Insert sample vendors
INSERT INTO Vendors (category_id, vendor_name, contact_person, contact_number, email, address, service_description, cost, rating) VALUES
(1, 'Royal Caterers', 'Mr. Kapoor', '9123456701', 'royal@example.com', '1 Food Street, Mumbai', 'Premium wedding catering', 1500000, 4.8),
(2, 'Floral Dreams', 'Ms. Desai', '9123456702', 'floral@example.com', '2 Flower Lane, Mumbai', 'Wedding decorations', 800000, 4.7),
(3, 'DJ Nights', 'Mr. Malhotra', '9123456703', 'dj@example.com', '3 Music Road, Mumbai', 'Wedding entertainment', 250000, 4.5),
(4, 'Shutterbug Studios', 'Mr. Khan', '9123456704', 'shutterbug@example.com', '4 Camera Street, Mumbai', 'Photography and videography', 600000, 4.9),
(5, 'Luxury Rides', 'Mr. Singh', '9123456705', 'luxury@example.com', '5 Vehicle Avenue, Mumbai', 'Premium car rentals', 200000, 4.6),
(6, 'Glamour Makeovers', 'Ms. Kapoor', '9123456706', 'glamour@example.com', '6 Beauty Plaza, Mumbai', 'Bridal makeup and hair', 150000, 4.8),
(7, 'Grand Venues', 'Mr. Patel', '9123456707', 'venues@example.com', '7 Location Road, Mumbai', 'Venue management', 0, 4.7),
(8, 'Hotel Services', 'Ms. Sharma', '9123456708', 'hotels@example.com', '8 Accommodation Street, Mumbai', 'Guest accommodations', 0, 4.5);

-- Insert catering details
INSERT INTO Catering (vendor_id, cuisine_type, menu_description, serving_style, per_plate_cost, minimum_guests) VALUES
(1, 'Indian Fusion', '5-course meal with starters, main course, desserts', 'Plated', 2500, 100),
(1, 'Continental', 'International cuisine buffet', 'Buffet', 1800, 50),
(1, 'Poolside Snacks', 'Finger foods and cocktails', 'Buffet', 1200, 30);

-- Insert decoration details
INSERT INTO Decorations (vendor_id, theme, color_scheme, flower_arrangements, lighting_type, cost) VALUES
(2, 'Royal Gold', 'Gold and Maroon', 'Rose and marigold centerpieces', 'Chandeliers and fairy lights', 500000),
(2, 'Beach Chic', 'Blue and White', 'Orchids and lilies', 'Lanterns and string lights', 300000),
(2, 'Traditional Mehendi', 'Bright Colors', 'Fresh flowers and drapes', 'Colorful spotlights', 200000);

-- Insert entertainment options
INSERT INTO Entertainment (vendor_id, entertainment_type, description, duration_minutes, cost) VALUES
(3, 'DJ Performance', 'Bollywood and international music', 240, 150000),
(3, 'Live Band', 'Traditional and contemporary songs', 180, 200000),
(3, 'Dance Performance', 'Professional dance troupe', 30, 50000),
(3, 'Photo Booth', 'Fun props and instant prints', 240, 75000);

-- Insert media services
INSERT INTO MediaServices (vendor_id, service_type, package_name, hours_included, delivery_timeline, cost) VALUES
(4, 'Both', 'Platinum Package', 12, '4 weeks for photos, 8 weeks for video', 600000),
(4, 'Photography', 'Gold Package', 8, '3 weeks for photos', 350000),
(4, 'Videography', 'Silver Package', 6, '6 weeks for video', 250000);

-- Insert transportation options
INSERT INTO Transportation (vendor_id, vehicle_type, capacity, cost_per_hour, minimum_hours) VALUES
(5, 'Bridal Car (Rolls Royce)', 4, 10000, 4),
(5, 'Luxury Coach', 40, 5000, 4),
(5, 'Premium Sedan', 4, 3000, 4),
(5, 'Mini Bus', 25, 4000, 4);

-- Insert beauty services
INSERT INTO BeautyServices (vendor_id, service_type, description, duration_minutes, cost) VALUES
(6, 'Bridal Makeup', 'Full bridal makeup with trials', 180, 75000),
(6, 'Groom Makeup', 'Groom styling', 60, 15000),
(6, 'Bridesmaid Makeup', 'Group makeup services', 90, 25000),
(6, 'Hair Styling', 'Traditional hairstyling', 120, 30000),
(6, 'Mehendi Artist', 'Professional henna application', 240, 40000);

-- Assign vendors to events
INSERT INTO EventVendors (event_id, vendor_id, service_details, start_time, end_time, cost, payment_status) VALUES
-- Pool Party
(1, 1, 'Poolside snacks and cocktails', '16:00:00', '22:00:00', 150000, 'Paid'),
(1, 3, 'DJ for pool party', '17:00:00', '21:00:00', 80000, 'Paid'),
(1, 2, 'Beach chic decorations', '14:00:00', '22:00:00', 150000, 'Partial'),

-- Ganesh Pooja
(2, 1, 'Traditional breakfast', '09:00:00', '11:00:00', 50000, 'Paid'),
(2, 2, 'Simple floral decorations', '08:00:00', '12:00:00', 50000, 'Paid'),

-- Mehendi
(3, 6, 'Mehendi artists for all women', '16:00:00', '20:00:00', 120000, 'Paid'),
(3, 3, 'Live folk music', '17:00:00', '21:00:00', 100000, 'Paid'),
(3, 2, 'Colorful mehendi decorations', '15:00:00', '21:00:00', 100000, 'Paid'),
(3, 1, 'Evening snacks and drinks', '18:00:00', '21:00:00', 100000, 'Paid'),

-- Haldi
(4, 2, 'Yellow theme decorations', '09:00:00', '13:00:00', 80000, 'Paid'),
(4, 1, 'Morning refreshments', '10:00:00', '12:00:00', 60000, 'Paid'),

-- Sangeet
(5, 3, 'DJ and dance performances', '19:00:00', '23:00:00', 250000, 'Partial'),
(5, 1, 'Dinner buffet', '20:00:00', '23:00:00', 300000, 'Paid'),
(5, 2, 'Glamorous stage setup', '18:00:00', '23:30:00', 200000, 'Paid'),
(5, 4, 'Full event coverage', '18:00:00', '23:00:00', 150000, 'Paid'),
(5, 3, 'Photo booth', '19:00:00', '23:00:00', 75000, 'Paid'),

-- Wedding
(6, 1, 'Traditional wedding feast', '17:00:00', '20:00:00', 500000, 'Partial'),
(6, 2, 'Royal wedding decorations', '14:00:00', '21:00:00', 300000, 'Partial'),
(6, 4, 'Full wedding coverage', '14:00:00', '20:00:00', 300000, 'Paid'),
(6, 5, 'Baraat horse and carriage', '14:00:00', '16:00:00', 50000, 'Paid'),
(6, 5, 'Guest transportation', '14:00:00', '21:00:00', 100000, 'Paid'),
(6, 6, 'Bridal makeup and hair', '10:00:00', '14:00:00', 75000, 'Paid'),

-- Reception
(7, 1, 'Plated dinner service', '20:30:00', '23:30:00', 400000, 'Partial'),
(7, 3, 'DJ and dance floor', '20:30:00', '23:30:00', 150000, 'Paid'),
(7, 4, 'Event coverage', '20:00:00', '23:30:00', 150000, 'Paid'),
(7, 2, 'Elegant reception decor', '19:30:00', '23:59:00', 200000, 'Partial'),

-- Brunch
(8, 1, 'Brunch buffet', '11:00:00', '14:00:00', 150000, 'Pending'),
(8, 2, 'Simple decorations', '10:00:00', '15:00:00', 50000, 'Pending');

-- Insert sample guests (50 guests)
INSERT INTO Guests (couple_id, name, address, contact_number, email, side, rsvp_status, dietary_restrictions) VALUES
-- Bride's side (25 guests)
(1, 'Aarav Sharma', '101 Family Home, Mumbai', '9111111111', 'aarav@example.com', 'Bride', 'Confirmed', 'None'),
(1, 'Diya Sharma', '101 Family Home, Mumbai', '9111111112', 'diya@example.com', 'Bride', 'Confirmed', 'Vegetarian'),
(1, 'Riya Mehta', '102 Colleague Street, Mumbai', '9111111113', 'riya@example.com', 'Bride', 'Confirmed', 'Vegan'),
(1, 'Vikram Joshi', '103 Friend Lane, Mumbai', '9111111114', 'vikram@example.com', 'Bride', 'Confirmed', 'None'),
(1, 'Ananya Kapoor', '104 Relative Road, Delhi', '9111111115', 'ananya@example.com', 'Bride', 'Confirmed', 'Gluten-free'),
-- Add 20 more bride-side guests...

-- Groom's side (25 guests)
(1, 'Arjun Patel', '201 Family Home, Mumbai', '9111111121', 'arjun@example.com', 'Groom', 'Confirmed', 'None'),
(1, 'Isha Patel', '201 Family Home, Mumbai', '9111111122', 'isha@example.com', 'Groom', 'Confirmed', 'Vegetarian'),
(1, 'Rahul Mehta', '202 Colleague Street, Mumbai', '9111111123', 'rahul@example.com', 'Groom', 'Confirmed', 'None'),
(1, 'Priya Joshi', '203 Friend Lane, Mumbai', '9111111124', 'priya@example.com', 'Groom', 'Pending', 'Lactose intolerant'),
(1, 'Amit Kapoor', '204 Relative Road, Delhi', '9111111125', 'amit@example.com', 'Groom', 'Confirmed', 'None');
-- Add 20 more groom-side guests...

-- Insert guest attendance for events
-- For brevity, just showing sample for first few guests
INSERT INTO GuestAttendance (guest_id, event_id, is_attending, special_requests) VALUES
-- Guest 1 attending all events
(1, 1, TRUE, 'Pool towel needed'),
(1, 2, TRUE, NULL),
(1, 3, TRUE, NULL),
(1, 4, TRUE, NULL),
(1, 5, TRUE, NULL),
(1, 6, TRUE, NULL),
(1, 7, TRUE, NULL),
(1, 8, TRUE, 'Early check-out'),

-- Guest 2 attending most events
(2, 1, TRUE, 'Vegetarian meals only'),
(2, 2, TRUE, NULL),
(2, 3, TRUE, NULL),
(2, 4, TRUE, NULL),
(2, 5, TRUE, NULL),
(2, 6, TRUE, NULL),
(2, 7, TRUE, NULL),
(2, 8, FALSE, 'Cannot attend'),

-- Guest 3 attending some events
(3, 1, FALSE, 'Cannot swim'),
(3, 2, TRUE, NULL),
(3, 3, TRUE, 'Vegan meals only'),
(3, 4, FALSE, 'Work commitment'),
(3, 5, TRUE, NULL),
(3, 6, TRUE, NULL),
(3, 7, TRUE, NULL),
(3, 8, TRUE, NULL);

-- Insert hotel bookings for guests
INSERT INTO RoomBookings (hotel_id, guest_id, room_type, check_in_date, check_out_date, cost, special_requests) VALUES
(1, 1, 'Deluxe Room', '2023-12-11', '2023-12-15', 100000, 'Adjoining rooms if possible'),
(1, 2, 'Deluxe Room', '2023-12-11', '2023-12-14', 75000, 'Vegetarian breakfast'),
(2, 3, 'Executive Suite', '2023-12-11', '2023-12-15', 120000, 'High floor preferred'),
(2, 4, 'Standard Room', '2023-12-12', '2023-12-15', 60000, 'Late check-in'),
(3, 5, 'Deluxe Room', '2023-12-11', '2023-12-15', 80000, 'Airport transfer needed');

-- Insert event catering details
INSERT INTO EventCatering (event_id, catering_id, estimated_guests, special_requests, service_time) VALUES
(1, 3, 80, 'Extra cocktail stations', '16:00:00'),
(2, 1, 50, 'Traditional prasad items', '09:00:00'),
(3, 1, 100, 'Special mehendi snacks', '18:00:00'),
(4, 2, 60, 'Haldi ceremony refreshments', '10:00:00'),
(5, 1, 150, 'Varied cuisine options', '20:00:00'),
(6, 1, 200, 'Traditional wedding feast', '17:00:00'),
(7, 1, 180, 'Plated dinner service', '20:30:00'),
(8, 2, 100, 'Brunch with live stations', '11:00:00');

-- Insert event decorations
INSERT INTO EventDecorations (event_id, decoration_id, setup_time, teardown_time, special_requests) VALUES
(1, 2, '14:00:00', '22:00:00', 'Beach chairs and umbrellas'),
(2, 1, '08:00:00', '12:00:00', 'Simple floral mandap'),
(3, 3, '15:00:00', '21:00:00', 'Colorful floor seating'),
(4, 1, '09:00:00', '13:00:00', 'Yellow flower decorations'),
(5, 1, '18:00:00', '23:30:00', 'Sparkling dance floor'),
(6, 1, '14:00:00', '21:00:00', 'Grand mandap design'),
(7, 1, '19:30:00', '23:59:00', 'Elegant centerpieces'),
(8, 2, '10:00:00', '15:00:00', 'Simple table settings');

-- Insert event entertainment
INSERT INTO EventEntertainment (event_id, entertainment_id, start_time, end_time, special_requests) VALUES
(1, 1, '17:00:00', '21:00:00', 'Poolside music mix'),
(3, 2, '17:00:00', '20:00:00', 'Traditional folk songs'),
(5, 1, '19:00:00', '23:00:00', 'Bollywood and western mix'),
(5, 3, '20:30:00', '21:00:00', 'Surprise performance'),
(5, 4, '19:00:00', '23:00:00', 'Wedding theme props'),
(7, 1, '20:30:00', '23:30:00', 'First dance songs list');

-- Insert event media coverage
INSERT INTO EventMedia (event_id, media_id, coverage_start, coverage_end, special_requests) VALUES
(2, 1, '08:30:00', '11:00:00', 'Ceremony highlights'),
(3, 1, '16:00:00', '21:00:00', 'Mehendi close-ups'),
(5, 1, '18:00:00', '23:00:00', 'Performance coverage'),
(6, 1, '14:00:00', '20:00:00', 'Full ceremony and rituals'),
(7, 1, '20:00:00', '23:30:00', 'Candid shots preferred');

-- Insert event transportation
INSERT INTO EventTransport (event_id, transport_id, pickup_time, pickup_location, dropoff_location, special_requests) VALUES
(6, 1, '14:00:00', 'Groom''s residence', 'Royal Banquet Hall', 'Decorated with flowers'),
(6, 2, '14:30:00', 'Taj Mahal Palace', 'Royal Banquet Hall', 'All guests pickup'),
(6, 2, '20:30:00', 'Royal Banquet Hall', 'Taj Mahal Palace', 'Return trip'),
(7, 3, '20:00:00', 'Taj Mahal Palace', 'Grand Ballroom', 'VIP guests'),
(7, 2, '23:30:00', 'Grand Ballroom', 'Taj Mahal Palace', 'All guests return');

-- Insert beauty appointments
INSERT INTO EventBeauty (event_id, beauty_id, person_id, appointment_time, duration_minutes, special_requests) VALUES
-- Bride's appointments
(3, 5, 1, '14:00:00', 240, 'Intricate mehendi design'),
(5, 1, 1, '15:00:00', 180, 'Sangeet makeup trial'),
(6, 1, 1, '10:00:00', 240, 'Full bridal look'),
(7, 1, 1, '18:00:00', 120, 'Reception touch-up'),

-- Groom's appointments
(6, 2, 2, '12:00:00', 60, 'Traditional groom look'),
(7, 2, 2, '19:00:00', 60, 'Formal reception look'),

-- Bridesmaids
(3, 5, 3, '16:00:00', 120, 'Simple mehendi design'),
(5, 3, 3, '16:00:00', 90, 'Group makeup'),
(6, 3, 3, '11:00:00', 90, 'Traditional look');

-- Insert checklist items
INSERT INTO Checklist (couple_id, item_name, category, due_date, assigned_to, status, notes) VALUES
(1, 'Finalize guest list', 'Planning', '2023-10-01', 'Bride', 'Completed', 'Sent invitations'),
(1, 'Book main venue', 'Venue', '2023-09-15', 'Groom', 'Completed', 'Deposit paid'),
(1, 'Catering tasting', 'Food', '2023-11-01', 'Both', 'Completed', 'Menu finalized'),
(1, 'Bridal outfit fitting', 'Attire', '2023-11-15', 'Bride', 'In Progress', 'Final adjustments needed'),
(1, 'Groom''s sherwani selection', 'Attire', '2023-11-20', 'Groom', 'Not Started', NULL),
(1, 'Create seating chart', 'Planning', '2023-12-01', 'Bride''s mother', 'Not Started', NULL),
(1, 'Finalize music playlist', 'Entertainment', '2023-11-25', 'Groom''s brother', 'Not Started', NULL),
(1, 'Confirm hotel bookings', 'Accommodation', '2023-11-30', 'Groom', 'In Progress', 'Most rooms booked'),
(1, 'Purchase wedding favors', 'Gifts', '2023-12-05', 'Bride''s sister', 'Not Started', NULL),
(1, 'Rehearsal dinner planning', 'Food', '2023-12-10', 'Groom''s parents', 'In Progress', 'Venue booked');

-- Insert budget items
INSERT INTO Budget (couple_id, category, estimated_cost, actual_cost, vendor_id, payment_status, payment_date, notes) VALUES
(1, 'Venue', 1000000, 950000, 7, 'Paid', '2023-09-20', 'Main venue discount'),
(1, 'Catering', 1500000, NULL, 1, 'Partial', NULL, 'Deposit paid'),
(1, 'Decorations', 800000, 750000, 2, 'Partial', '2023-10-15', '50% paid'),
(1, 'Entertainment', 500000, NULL, 3, 'Pending', NULL, 'Contract signed'),
(1, 'Photography', 600000, 300000, 4, 'Partial', '2023-10-01', 'Deposit paid'),
(1, 'Bridal Attire', 300000, 350000, NULL, 'Paid', '2023-08-15', 'Over budget'),
(1, 'Groom Attire', 150000, NULL, NULL, 'Pending', NULL, 'Need final fitting'),
(1, 'Accommodation', 500000, 200000, 8, 'Partial', '2023-09-01', 'Block booking'),
(1, 'Transportation', 200000, NULL, 5, 'Pending', NULL, 'Quotes received'),
(1, 'Miscellaneous', 300000, 50000, NULL, 'Partial', '2023-10-01', 'Initial expenses');

-- Insert seating arrangements
INSERT INTO SeatingArrangements (event_id, table_number, capacity, guest_list, special_notes) VALUES
(5, 'T1', 10, 'Bride, Groom, Parents, Grandparents', 'Head table'),
(5, 'T2', 10, 'Bride''s siblings, cousins', 'Bride''s family'),
(5, 'T3', 10, 'Groom''s siblings, cousins', 'Groom''s family'),
(5, 'T4', 10, 'College friends', 'Near dance floor'),
(5, 'T5', 10, 'Work colleagues', NULL),
(6, 'T1', 10, 'Bride, Groom, Parents, Priest', 'Mandap seating'),
(6, 'T2', 10, 'Close family', 'Front row'),
(6, 'T3', 10, 'Extended family', NULL),
(7, 'T1', 10, 'Bride, Groom, Parents', 'VIP table'),
(7, 'T2', 10, 'Wedding party', NULL),
(7, 'T3', 10, 'Family elders', NULL);

-- Insert gift registry items
INSERT INTO GiftRegistry (couple_id, item_name, description, store_name, price, quantity_requested) VALUES
(1, 'Dinnerware Set', '12-piece fine china set', 'Home & Beyond', 15000, 2),
(1, 'Air Fryer', 'Premium digital air fryer', 'ElectroWorld', 12000, 1),
(1, 'Crystal Vase', 'Hand-cut crystal vase', 'Luxury Living', 8000, 3),
(1, 'Cookware Set', 'Non-stick 10-piece set', 'Kitchen Essentials', 20000, 1),
(1, 'Cash Gift', 'For honeymoon fund', NULL, NULL, NULL),
(1, 'Bed Linens', '1000-thread count king set', 'Sleep Well', 15000, 2),
(1, 'Smart Speaker', 'Latest model with assistant', 'Tech Haven', 10000, 1);


# Basic queries

-- Basic WHERE with comparison operators

-- Greater than
SELECT * FROM Events 
WHERE budget > 100000;

-- Less than
SELECT * FROM Vendors 
WHERE cost < 50000;

-- Equal to
SELECT * FROM Guests 
WHERE side = 'Bride';

-- Not equal to
SELECT * FROM Checklist 
WHERE status != 'Completed';


#COUNT with GROUP BY

-- Count guests by side
SELECT side, COUNT(*) AS guest_count 
FROM Guests 
GROUP BY side;

-- Count events per couple
SELECT couple_id, COUNT(*) AS event_count 
FROM Events 
GROUP BY couple_id;

# 3.HAVING with aggregation

-- Vendors with average cost > 50,000
SELECT category_id, AVG(cost) AS avg_cost 
FROM Vendors 
GROUP BY category_id 
HAVING avg_cost > 50000;

-- Events with more than 50 attending guests
SELECT e.event_name, COUNT(ga.guest_id) AS attending_guests
FROM Events e
JOIN GuestAttendance ga ON e.event_id = ga.event_id
WHERE ga.is_attending = TRUE
GROUP BY e.event_id
HAVING attending_guests > 50;

# 4. Join operations
-- INNER JOIN (Events with their venues)
SELECT e.event_name, v.venue_name
FROM Events e
JOIN EventVenues ev ON e.event_id = ev.event_id
JOIN Venues v ON ev.venue_id = v.venue_id;

-- LEFT JOIN (All couples with their events - shows couples even with no events)
SELECT c.bride_name, c.groom_name, e.event_name
FROM Couple c
LEFT JOIN Events e ON c.couple_id = e.couple_id;

-- Multiple JOINs (Events with venues and vendors)
SELECT e.event_name, v.venue_name, ven.vendor_name
FROM Events e
JOIN EventVenues ev ON e.event_id = ev.event_id
JOIN Venues v ON ev.venue_id = v.venue_id
JOIN EventVendors evd ON e.event_id = evd.event_id
JOIN Vendors ven ON evd.vendor_id = ven.vendor_id;

# Combine examples

-- Events with decoration cost > 100,000
SELECT e.event_name, d.cost AS decoration_cost
FROM Events e
JOIN EventDecorations ed ON e.event_id = ed.event_id
JOIN Decorations d ON ed.decoration_id = d.decoration_id
WHERE d.cost > 100000;

-- Vendors with more than 3 events booked
SELECT v.vendor_name, COUNT(ev.event_id) AS event_count
FROM Vendors v
JOIN EventVendors ev ON v.vendor_id = ev.vendor_id
GROUP BY v.vendor_id
HAVING event_count > 3;

-- Guests attending more than 2 events (using subquery)
SELECT g.name, COUNT(ga.event_id) AS events_attending
FROM Guests g
JOIN GuestAttendance ga ON g.guest_id = ga.guest_id
WHERE ga.is_attending = TRUE
GROUP BY g.guest_id
HAVING events_attending > 2;

-- Budget items where actual cost is less than estimated
SELECT category, estimated_cost, actual_cost
FROM Budget
WHERE actual_cost < estimated_cost
AND couple_id = 1;

-- Family members with specific roles (using LIKE)
SELECT name, relation, role_in_wedding
FROM Family
WHERE role_in_wedding LIKE '%coordinator%';


-- queries run

-- 1. Get all events with their venues and dates
SELECT e.event_name, e.event_date, e.start_time, e.end_time, 
       v.venue_name, v.address
FROM Events e
JOIN EventVenues ev ON e.event_id = ev.event_id
JOIN Venues v ON ev.venue_id = v.venue_id
ORDER BY e.event_date, e.start_time;

-- 2. Get total estimated cost per event
SELECT e.event_name, 
       SUM(ev.cost) AS estimated_cost,
       GROUP_CONCAT(v.vendor_name SEPARATOR ', ') AS vendors
FROM Events e
JOIN EventVendors ev ON e.event_id = ev.event_id
JOIN Vendors v ON ev.vendor_id = v.vendor_id
GROUP BY e.event_id
ORDER BY e.event_date;

-- 3. Get guest list with attendance status for each event
SELECT g.name, g.side, 
       e.event_name, 
       CASE WHEN ga.is_attending THEN 'Yes' ELSE 'No' END AS attending,
       ga.special_requests
FROM Guests g
JOIN GuestAttendance ga ON g.guest_id = ga.guest_id
JOIN Events e ON ga.event_id = e.event_id
ORDER BY g.side, g.name, e.event_date;

-- 4. Get beauty appointments schedule for the bride
SELECT e.event_name, eb.appointment_time,
       bs.service_type, bs.duration_minutes, eb.special_requests
FROM EventBeauty eb
JOIN BeautyServices bs ON eb.beauty_id = bs.beauty_id
JOIN Events e ON eb.event_id = e.event_id
WHERE eb.person_id = 1  -- Assuming bride is person_id 1
ORDER BY e.event_date, eb.appointment_time;

-- 5. Get catering details for all events
SELECT e.event_name, c.cuisine_type, c.menu_description,
       ec.estimated_guests, ec.special_requests
FROM EventCatering ec
JOIN Catering c ON ec.catering_id = c.catering_id
JOIN Events e ON ec.event_id = e.event_id
ORDER BY e.event_date;

-- 6. Budget summary by category
SELECT category, 
       SUM(estimated_cost) AS estimated, 
       SUM(actual_cost) AS actual,
       SUM(estimated_cost) - SUM(IFNULL(actual_cost, 0)) AS remaining
FROM Budget
WHERE couple_id = 1
GROUP BY category
ORDER BY estimated DESC;

-- 7. Get all pending checklist items
SELECT item_name, category, due_date, assigned_to
FROM Checklist
WHERE couple_id = 1 AND status != 'Completed'
ORDER BY due_date;

-- 8. Get transportation schedule for wedding day
SELECT e.event_name, t.vehicle_type, 
       et.pickup_time, et.pickup_location, et.dropoff_location
FROM EventTransport et
JOIN Transportation t ON et.transport_id = t.transport_id
JOIN Events e ON et.event_id = e.event_id
WHERE e.event_date = '2023-12-14'  -- Wedding day
ORDER BY et.pickup_time;

-- 9. Get vendor contact list
SELECT vc.category_name, v.vendor_name, 
       v.contact_person, v.contact_number, v.email
FROM Vendors v
JOIN VendorCategories vc ON v.category_id = vc.category_id
ORDER BY vc.category_name, v.vendor_name;

-- 10. Get hotel bookings summary
SELECT h.hotel_name, COUNT(rb.booking_id) AS bookings,
       SUM(rb.cost) AS total_cost
FROM RoomBookings rb
JOIN Hotels h ON rb.hotel_id = h.hotel_id
GROUP BY h.hotel_name
ORDER BY bookings DESC;

-- stored procedures

-- 1. Procedure to add a new event with basic details
DELIMITER //
CREATE PROCEDURE AddWeddingEvent(
    IN p_couple_id INT,
    IN p_event_name VARCHAR(100),
    IN p_event_date DATE,
    IN p_start_time TIME,
    IN p_end_time TIME,
    IN p_description TEXT,
    IN p_dress_code VARCHAR(100)
)
BEGIN
    INSERT INTO Events (couple_id, event_name, event_date, start_time, end_time, description, dress_code)
    VALUES (p_couple_id, p_event_name, p_event_date, p_start_time, p_end_time, p_description, p_dress_code);
    
    SELECT LAST_INSERT_ID() AS new_event_id;
END //
DELIMITER ;

-- 2. Procedure to assign a venue to an event
DELIMITER //
CREATE PROCEDURE AssignVenueToEvent(
    IN p_event_id INT,
    IN p_venue_id INT,
    IN p_booking_date DATE,
    IN p_setup_time TIME,
    IN p_teardown_time TIME,
    IN p_special_reqs TEXT
)
BEGIN
    INSERT INTO EventVenues (event_id, venue_id, booking_date, setup_time, teardown_time, special_requirements)
    VALUES (p_event_id, p_venue_id, p_booking_date, p_setup_time, p_teardown_time, p_special_reqs);
END //
DELIMITER ;

-- 3. Procedure to add a guest and assign to events
DELIMITER //
CREATE PROCEDURE AddWeddingGuest(
    IN p_couple_id INT,
    IN p_name VARCHAR(100),
    IN p_address TEXT,
    IN p_contact VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_side ENUM('Bride', 'Groom', 'Both'),
    IN p_dietary TEXT,
    IN p_event_ids TEXT  -- Comma-separated list of event IDs to attend
)
BEGIN
    DECLARE v_guest_id INT;
    
    -- Add guest
    INSERT INTO Guests (couple_id, name, address, contact_number, email, side, dietary_restrictions)
    VALUES (p_couple_id, p_name, p_address, p_contact, p_email, p_side, p_dietary);
    
    SET v_guest_id = LAST_INSERT_ID();
    
    -- Add attendance records for each event
    SET @sql = CONCAT('INSERT INTO GuestAttendance (guest_id, event_id, is_attending) 
                      SELECT ', v_guest_id, ', event_id, TRUE FROM Events 
                      WHERE event_id IN (', p_event_ids, ') AND couple_id = ', p_couple_id);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    SELECT v_guest_id AS new_guest_id;
END //
DELIMITER ;

-- 4. Procedure to calculate total wedding cost
DELIMITER //
CREATE PROCEDURE CalculateTotalWeddingCost(IN p_couple_id INT)
BEGIN
    SELECT 
        SUM(estimated_cost) AS total_estimated,
        SUM(IFNULL(actual_cost, 0)) AS total_paid,
        SUM(estimated_cost) - SUM(IFNULL(actual_cost, 0)) AS remaining_balance
    FROM Budget
    WHERE couple_id = p_couple_id;
END //
DELIMITER ;

-- 5. Procedure to generate event schedule
DELIMITER //
CREATE PROCEDURE GenerateEventSchedule(IN p_couple_id INT)
BEGIN
    SELECT 
        e.event_name,
        e.event_date,
        e.start_time,
        e.end_time,
        v.venue_name,
        v.address,
        GROUP_CONCAT(DISTINCT ven.vendor_name SEPARATOR ', ') AS vendors,
        ec.menu_description AS catering,
        ed.theme AS decoration_theme
    FROM Events e
    LEFT JOIN EventVenues ev ON e.event_id = ev.event_id
    LEFT JOIN Venues v ON ev.venue_id = v.venue_id
    LEFT JOIN EventVendors evd ON e.event_id = evd.event_id
    LEFT JOIN Vendors ven ON evd.vendor_id = ven.vendor_id
    LEFT JOIN EventCatering ec ON e.event_id = ec.event_id
    LEFT JOIN Catering c ON ec.catering_id = c.catering_id
    LEFT JOIN EventDecorations edc ON e.event_id = edc.event_id
    LEFT JOIN Decorations ed ON edc.decoration_id = ed.decoration_id
    WHERE e.couple_id = p_couple_id
    GROUP BY e.event_id, e.event_name, e.event_date, e.start_time, e.end_time, 
             v.venue_name, v.address, ec.menu_description, ed.theme
    ORDER BY e.event_date, e.start_time;
END //
DELIMITER ;

-- Views

-- 1. View for event details with vendors
CREATE VIEW EventDetails AS
SELECT 
    e.event_id,
    e.event_name,
    e.event_date,
    e.start_time,
    e.end_time,
    v.venue_name,
    v.address AS venue_address,
    GROUP_CONCAT(DISTINCT ven.vendor_name SEPARATOR ', ') AS vendors,
    GROUP_CONCAT(DISTINCT ven.service_description SEPARATOR ' | ') AS services
FROM Events e
LEFT JOIN EventVenues ev ON e.event_id = ev.event_id
LEFT JOIN Venues v ON ev.venue_id = v.venue_id
LEFT JOIN EventVendors evd ON e.event_id = evd.event_id
LEFT JOIN Vendors ven ON evd.vendor_id = ven.vendor_id
GROUP BY e.event_id, e.event_name, e.event_date, e.start_time, e.end_time, v.venue_name, v.address;

-- 2. View for guest list with attendance summary
CREATE VIEW GuestSummary AS
SELECT 
    g.guest_id,
    g.name,
    g.side,
    g.contact_number,
    g.email,
    COUNT(ga.attendance_id) AS events_invited,
    SUM(CASE WHEN ga.is_attending THEN 1 ELSE 0 END) AS events_attending
FROM Guests g
LEFT JOIN GuestAttendance ga ON g.guest_id = ga.guest_id
GROUP BY g.guest_id, g.name, g.side, g.contact_number, g.email;

-- 3. View for vendor performance
CREATE VIEW VendorPerformance AS
SELECT 
    v.vendor_id,
    v.vendor_name,
    vc.category_name,
    COUNT(ev.event_vendor_id) AS events_contracted,
    SUM(ev.cost) AS total_contract_value,
    AVG(v.rating) AS average_rating
FROM Vendors v
JOIN VendorCategories vc ON v.category_id = vc.category_id
LEFT JOIN EventVendors ev ON v.vendor_id = ev.vendor_id
GROUP BY v.vendor_id, v.vendor_name, vc.category_name;

-- 4. View for budget tracking
CREATE VIEW BudgetTracking AS
SELECT 
    b.category,
    b.estimated_cost,
    b.actual_cost,
    b.estimated_cost - IFNULL(b.actual_cost, 0)) AS remaining,
    (IFNULL(b.actual_cost, 0) / b.estimated_cost) * 100 AS percent_spent,
    b.payment_status,
    v.vendor_name
FROM Budget b
LEFT JOIN Vendors v ON b.vendor_id = v.vendor_id
ORDER BY b.category;

-- 5. View for room booking summary
CREATE VIEW RoomBookingSummary AS
SELECT 
    h.hotel_name,
    COUNT(rb.booking_id) AS bookings,
    SUM(DATEDIFF(rb.check_out_date, rb.check_in_date)) AS room_nights,
    SUM(rb.cost) AS total_revenue
FROM RoomBookings rb
JOIN Hotels h ON rb.hotel_id = h.hotel_id
GROUP BY h.hotel_name
ORDER BY bookings DESC;


# Basic query

SELECT * FROM Couple;

SELECT * FROM Events WHERE couple_id = 1 ORDER BY event_date, start_time;

SELECT e.event_name, COUNT(ga.guest_id) AS attending_guests
FROM Events e
LEFT JOIN GuestAttendance ga ON e.event_id = ga.event_id AND ga.is_attending = TRUE
GROUP BY e.event_id;

SELECT v.vendor_name, vc.category_name 
FROM Vendors v
JOIN VendorCategories vc ON v.category_id = vc.category_id;

SELECT * FROM Guests WHERE rsvp_status = 'Pending';

SELECT SUM(estimated_cost) AS total_budget, 
       SUM(actual_cost) AS total_spent
FROM Budget WHERE couple_id = 1;

SELECT SUM(estimated_cost) AS total_budget, 
       SUM(actual_cost) AS total_spent
FROM Budget WHERE couple_id = 1;

SELECT DISTINCT theme FROM Decorations;

SELECT e.event_name, eb.appointment_time, bs.service_type
FROM EventBeauty eb
JOIN BeautyServices bs ON eb.beauty_id = bs.beauty_id
JOIN Events e ON eb.event_id = e.event_id
WHERE eb.person_id = 1;  -- Assuming person_id 1 is the bride

SELECT side, COUNT(*) AS guest_count 
FROM Guests 
GROUP BY side;

SELECT * FROM Checklist 
WHERE status != 'Completed' 
ORDER BY due_date;

SELECT e.event_name, v.venue_name, c.cuisine_type, c.menu_description
FROM Events e
LEFT JOIN EventVenues ev ON e.event_id = ev.event_id
LEFT JOIN Venues v ON ev.venue_id = v.venue_id
LEFT JOIN EventCatering ec ON e.event_id = ec.event_id
LEFT JOIN Catering c ON ec.catering_id = c.catering_id
ORDER BY e.event_date;

SELECT e.event_name, g.name, g.dietary_restrictions
FROM Guests g
JOIN GuestAttendance ga ON g.guest_id = ga.guest_id
JOIN Events e ON ga.event_id = e.event_id
WHERE g.dietary_restrictions IS NOT NULL AND ga.is_attending = TRUE
ORDER BY e.event_date;

SELECT e.event_name, 
       SUM(ev.cost) AS total_cost,
       GROUP_CONCAT(v.vendor_name SEPARATOR ', ') AS vendors
FROM Events e
JOIN EventVendors ev ON e.event_id = ev.event_id
JOIN Vendors v ON ev.vendor_id = v.vendor_id
GROUP BY e.event_id
ORDER BY total_cost DESC;

SELECT e.event_name, t.vehicle_type, et.pickup_time, et.pickup_location
FROM EventTransport et
JOIN Transportation t ON et.transport_id = t.transport_id
JOIN Events e ON et.event_id = e.event_id
WHERE e.event_date = '2023-12-14'  -- Wedding day
ORDER BY et.pickup_time;

SELECT b.category, b.estimated_cost, b.actual_cost
FROM Budget b
WHERE b.actual_cost > b.estimated_cost AND couple_id = 1;

SELECT item_name, quantity_requested, quantity_received,
       (quantity_received/quantity_requested)*100 AS fulfillment_percentage
FROM GiftRegistry
ORDER BY fulfillment_percentage DESC;

SELECT f.name, f.relation, f.side, f.role_in_wedding,
       c.bride_name, c.groom_name
FROM Family f
JOIN Couple c ON f.couple_id = c.couple_id
ORDER BY f.side, f.relation;

SELECT e.event_name, COUNT(ga.guest_id) AS attending_guests
FROM Events e
JOIN GuestAttendance ga ON e.event_id = ga.event_id AND ga.is_attending = TRUE
GROUP BY e.event_id
ORDER BY attending_guests DESC
LIMIT 3;

SELECT v.vendor_name, ev.event_name, 
       ev.cost, ev.payment_status
FROM EventVendors ev
JOIN Vendors v ON ev.vendor_id = v.vendor_id
ORDER BY ev.payment_status, v.vendor_name;

SELECT g.name, h.hotel_name, rb.room_type, 
       rb.check_in_date, rb.check_out_date
FROM Guests g
JOIN RoomBookings rb ON g.guest_id = rb.guest_id
JOIN Hotels h ON rb.hotel_id = h.hotel_id
ORDER BY h.hotel_name, g.name;




-- Delete the sample couple if they exist
DELETE FROM Couple WHERE bride_name = 'Priya Sharma' AND groom_name = 'Rahul Patel';


-- Alternatively, update the existing couple
UPDATE Couple 
SET bride_name = 'Snoozy', 
    groom_name = 'Himanshu', 
    email = 'himanshu.snoozy@example.com'
WHERE couple_id = 1;


SELECT * FROM Couple;



-- Delete all family members associated with couple_id 1
DELETE FROM Family WHERE couple_id = 1;

-- Insert updated family members for Snoozy (bride) and Himanshu (groom)
UPDATE Couple 
SET bride_name = 'Snoozy', 
    groom_name = 'Himanshu', 
    email = 'himanshu.snoozy@example.com'
WHERE couple_id = 1;


