# Weather App
This is a simple weather app built using Salesforce Lightning Components. The app allows users to fetch and display weather data for a given location.

## Features
* Fetches real-time weather data from an external API
* Displays temperature, humidity, and other weather-related information
* Provides a user-friendly interface using Salesforce Lightning Components

## Getting Started
1. Clone the weather app project from the repository
2. Open the project in VS code editor and deploy the package using 'SFDX: Deploy This Source to Org'.
3. Create custom setting record for weather api endpoint and API key (to be shared)
4. Assign the permission set OpenWeather_Admin to view the weather app

## Usage
The app displays a button labeled "Fetch Weather" when opened.
Click the "Fetch Weather" button to fetch the current weather data for the specified location.
The app displays the weather data, including temperature, humidity, and other information, in a formatted manner.
