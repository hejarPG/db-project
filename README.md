# Online Services Marketplace (Database Implementation)

This project is a database implementation for an online platform that connects people who offer services with those who need them. The database is designed to store and manage user profiles, service listings, requests, and interactions efficiently.

## Database Structure

The database follows a structured approach to organize and manage platform data effectively. It includes the following key components:

### 1. **Users Table**
   - Stores user details such as name, contact information, and account type (service provider or customer).
   - Tracks user authentication data (hashed passwords, login details).
   - Manages user ratings and reviews.

### 2. **Services Table**
   - Contains details about services offered by users.
   - Includes service descriptions, pricing, and availability.
   - Links to the service provider’s user profile.

### 3. **Requests Table**
   - Stores customer service requests.
   - Tracks request details such as type of service, budget, and deadline.
   - Connects users with potential service providers.

### 4. **Transactions Table**
   - Logs service transactions between users.
   - Stores payment details, status updates, and completion records.
   
### 5. **Messages Table**
   - Stores conversations between users for service negotiations.
   - Maintains timestamps and user references for tracking communication.

### 6. **Reviews Table**
   - Stores user ratings and feedback for services.
   - Helps in maintaining trust and service quality.

## How It Works

1. Users and services are stored in a structured database.
2. Service requests and interactions are logged and managed.
3. The database ensures data integrity and quick retrieval.

This implementation focuses on the backend data structure, ensuring smooth and efficient management of an online service marketplace.
