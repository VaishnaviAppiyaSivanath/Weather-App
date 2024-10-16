# Weather App
This is a simple weather app built using Salesforce Lightning Web Components and Apex, which is integrated with an external API to fetch and display weather data for given coordinates.

## Features
* Fetches real-time weather data from an external API
* Displays temperature, humidity, and other weather-related information on a Lightning web component
* Store and display weather information in Salesforce using custom objects

## Usage
The app displays a button labeled "Fetch Weather" when opened.
Click the "Fetch Weather" button to fetch the current weather data for the specified location.
The app displays the weather data, including temperature, humidity and other information, in a formatted manner.

## Deployment
1. Clone the weather app project from the repository
2. Open the project in VS code editor and deploy the package using 'SFDX: Deploy This Source to Org'
3. Create custom setting record for weather api endpoint and API key (to be shared)
4. Assign the permission set OpenWeather_Admin to view the weather app

## 1. Data Model
Custom Objects
* Location__c : Stores location details like Name, Latitude, Longitude
    * Fields
        * Name (Text):  The name of the location
        * Coordinates__c (Geolocation): Latitude and Longitude of the location
* WeatherInfo__c : Stores the weather information retrieved for a location
    * Fields
        * Location__c (Master Detail to Location):  Related Location
        * Current_Temperature__c (Number): Current temperature
        * Description__c (Text) : Weather description information
        * Feels_Like__c (Number) : Feels like temperature
        * Name (Text) : The name of the location

## 2. Apex Controller: WeatherAPIService
The Apex class handles the integration with the external weather API. It uses an HTTP callout to fetch data from the external weather API, processes the response, and returns the data to the WeatherAPIController which then returns the response to the LWC.

## 3. Lightning Web Component: WeatherData
The WeatherData LWC fetches and displays the weather based on the coordinates of the location. It invokes the imperative Apex method fetchWeather and display the weather details. It also stores this information in WeatherInfo__c object by invoking createRecord from uiAPI wire adapter.

## 4. Security Considerations
__Hierarchical Custom Settings for API Key:__
    Anyone with modify all permission has access to legacy named credentials and can reveal keys.API key can be stored in external credentials but can be sent as part of request header only. No option to send them as query param when stored in External Credential. So stored the Endpoint and API key in hierarchical custom settings - protected mode. Set to Org default but can be restricted to a profile / user.

__Profiles and Permission Sets:__
    Ensure the user is assigned with the permission set OpenWeather_Admin to view the weather app

__Sharing Settings:__
    Location set to Public Read/Write

## 5. Future Enhancements
*   __Logging:__ Add Logging Framework to proactively monitor the application
*   __Caching:__ Current implementation creates weather info record everytime fetchWeather button is clicked. As per API doc, weather info is refreshed only in every 10 mins. Recommends making API calls no more than once in 10 minutes for each location. So add custom logic before making an API call. 
*   __Purging:__ Have periodical weather info records purging to avoid data skew.
*   __UI Enhancements:__ User experience can be improved by enabling the user to plot a marker in the map instead of manually allowing them to enter coordinates.
*   __Weather Forecasts:__ Extend the app to display multi-day forecasts by modifying the API call and UI.