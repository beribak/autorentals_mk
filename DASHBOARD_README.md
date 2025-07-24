# Car Management Dashboard

This dashboard provides a comprehensive interface for managing your car rental fleet in the EliteRentals application.

## Features

### Dashboard Overview
- **Statistics Cards**: View total cars, available cars, rented cars, and daily revenue potential
- **Fleet Status**: Quick overview of your entire car inventory
- **Modern Dark Theme**: Consistent with the EliteRentals brand

### Car Management
- **Add New Cars**: Complete form with validation for all car details
- **Edit Existing Cars**: Update car specifications, pricing, and availability
- **Delete Cars**: Remove cars from the fleet with confirmation
- **Image Preview**: Live preview of car images when entering URLs
- **Status Management**: Toggle car availability (available/rented)

### Form Features
- Brand, Model, Year, and Price per Day fields
- Description textarea for detailed car information
- Image URL with live preview
- Availability checkbox
- Comprehensive validation with error messages
- Responsive design for mobile and desktop

### Table Features
- **Responsive Design**: Adapts to different screen sizes
- **Car Thumbnails**: Visual preview of each car
- **Status Badges**: Clear visual indicators for car availability
- **Action Buttons**: Quick access to edit and delete functions
- **Hover Effects**: Enhanced user experience with smooth animations

## Usage

### Accessing the Dashboard
1. Navigate to `/admin` or click "Dashboard" in the navigation
2. View the dashboard overview with fleet statistics

### Adding a New Car
1. Click "Add New Car" button
2. Fill in all required fields:
   - Brand (e.g., BMW, Mercedes, Audi)
   - Model (e.g., M5, S-Class, A8)
   - Year (1900 - current year + 1)
   - Price per Day (minimum €0)
   - Image URL (live preview available)
   - Description (detailed car information)
   - Availability status
3. Click "Add Car" to save

### Editing a Car
1. Click "Edit" button next to any car in the table
2. Modify the desired fields
3. Use "View Car" to preview changes on the customer-facing page
4. Click "Update Car" to save changes

### Deleting a Car
1. Click "Delete" button next to any car
2. Confirm deletion in the popup dialog
3. Car will be permanently removed from the database

## Technical Details

### Routes
- `GET /admin` - Dashboard overview
- `GET /admin/cars` - Car management table
- `GET /admin/cars/new` - Add new car form
- `POST /admin/cars` - Create new car
- `GET /admin/cars/:id/edit` - Edit car form
- `PATCH /admin/cars/:id` - Update car
- `DELETE /admin/cars/:id` - Delete car

### Controllers
- `Admin::ApplicationController` - Base admin controller
- `Admin::CarsController` - Car management functionality

### Views
- `admin/cars/index.html.erb` - Dashboard and car table
- `admin/cars/new.html.erb` - New car form
- `admin/cars/edit.html.erb` - Edit car form

### Styling
- `dashboard.css` - Complete dashboard styling
- Matches existing EliteRentals dark theme
- Responsive design with mobile optimizations
- Smooth animations and hover effects

### JavaScript
- `dashboard_controller.js` - Stimulus controller for enhanced interactions
- Live image preview functionality
- Enhanced form interactions

## Security Notes

The current implementation does not include authentication. In a production environment, you should:

1. Add admin authentication to `Admin::ApplicationController`
2. Implement proper authorization checks
3. Add CSRF protection for all forms
4. Validate and sanitize all user inputs
5. Implement proper session management

## Responsive Design

The dashboard is fully responsive and adapts to different screen sizes:

- **Desktop**: Full table with all columns visible
- **Tablet**: Some columns hidden to save space
- **Mobile**: Optimized layout with stacked buttons and simplified table

## Browser Support

The dashboard supports all modern browsers and uses:
- CSS Grid and Flexbox for layouts
- CSS Custom Properties for theming
- Stimulus for JavaScript interactions
- Progressive enhancement principles
