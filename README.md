# GetirLiteApp

GetirLiteApp is an iOS application developed using Programmatic UI and UIKit framework. It provides various features for browsing products, viewing product details, and managing a shopping cart.

## Features

### 1. Product Listing
- Fetches and displays product data from mock APIs.
- Displays horizontal scrollable list products and vertical scrollable list products together.
- Allows users to click on product items to view details.
- Displays the total amount in the cart.

### 2. Product Detail
- Displays detailed information about a product, including image, name, price, description, and current amount in the cart.
- Allows users to update the quantity of products in the cart using a stepper.

### 3. Shopping Cart
- Displays all items and their quantities in the cart.
- Provides a Checkout button for users to complete their order.
- Shows a meaningful success message upon successful checkout, containing the total cart amount.
- Resets local data and returns to the Product Listing Screen after successful checkout.
- Automatically removes items with a count of zero from the cart.
- Prevents users from accessing the Cart Screen if the cart is empty.

## Usage

To use GetirLiteApp, follow these steps:

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the application on your iOS device or simulator.

## Technologies Used

- Swift
- Programmatic UI
- UIKit
- CoreData

## Credits

This application was developed by Berkcan Arslan.
