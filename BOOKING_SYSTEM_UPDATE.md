# Booking System Update - Email Inquiry System

## What was changed

The original booking system has been replaced with an email-based inquiry system. Instead of directly creating bookings in the database, users now fill out an inquiry form that sends emails to both the company and the customer.

## New Features

### 1. Booking Inquiry System
- **Controller**: `BookingInquiriesController` 
- **Routes**: 
  - `GET /booking_inquiries/new` - General inquiry form
  - `GET /cars/:car_id/inquiry/new` - Car-specific inquiry form
  - `POST /booking_inquiries` - Submit inquiry
  - `GET /booking_inquiries/confirmation` - Confirmation page

### 2. Email Functionality
- **Mailer**: `BookingInquiryMailer`
- **Two emails sent per inquiry**:
  1. To company (`contact@autorentals.mk`) with inquiry details
  2. To customer with confirmation and next steps

### 3. Updated User Interface
- All "Резервирај сега" (Book Now) buttons changed to "Испрати барање" (Send Inquiry)
- New inquiry form with all necessary fields:
  - Customer information (name, email, phone)
  - Rental dates (start/end)
  - Pickup location
  - Optional message
- Confirmation page explaining next steps

## Email Templates

### Company Email (`new_inquiry`)
- Contains all customer details
- Shows requested car (if applicable)
- Includes rental dates and location preferences
- Available in both HTML and text formats

### Customer Confirmation Email (`inquiry_confirmation`)
- Thanks customer for their inquiry
- Shows what they requested
- Explains next steps (contact within 2 hours)
- Provides company contact information
- Available in both HTML and text formats

## Technical Changes

### Files Added:
- `app/controllers/booking_inquiries_controller.rb`
- `app/mailers/booking_inquiry_mailer.rb`
- `app/views/booking_inquiries/new.html.erb`
- `app/views/booking_inquiries/confirmation.html.erb`
- `app/views/booking_inquiry_mailer/new_inquiry.html.erb`
- `app/views/booking_inquiry_mailer/new_inquiry.text.erb`
- `app/views/booking_inquiry_mailer/inquiry_confirmation.html.erb`
- `app/views/booking_inquiry_mailer/inquiry_confirmation.text.erb`

### Files Modified:
- `config/routes.rb` - Added inquiry routes, kept existing booking routes for viewing only
- `app/views/cars/show.html.erb` - Updated booking button
- `app/views/cars/index.html.erb` - Updated booking buttons
- `app/mailers/application_mailer.rb` - Updated from email
- `config/environments/development.rb` - Added email configuration for testing

### Existing Booking System
- **Kept intact** for viewing existing bookings
- Routes for `bookings#index`, `bookings#show`, `bookings#cancel` still work
- No new bookings can be created through the old system

## Development Configuration

Emails in development are saved to `tmp/mail/` as files for testing purposes.

## Next Steps for Production

1. Configure SMTP settings in production environment
2. Set up proper email delivery service (SendGrid, Mailgun, etc.)
3. Update email addresses to actual company email
4. Consider adding admin interface to manage inquiries

## User Experience Flow

1. User browses cars
2. Clicks "Испрати барање" (Send Inquiry)
3. Fills out inquiry form with dates and details
4. Submits form
5. Receives confirmation page
6. Gets confirmation email
7. Company receives inquiry email
8. Company contacts customer within 2 hours to finalize booking

This approach gives you complete control over the booking process while maintaining a professional customer experience.
