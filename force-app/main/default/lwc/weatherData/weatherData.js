import { LightningElement, api, wire } from 'lwc';
import IMAGES from '@salesforce/resourceUrl/WeatherIcons';
import { createRecord, getRecord, getFieldValue } from 'lightning/uiRecordApi';
import fetchWeather from '@salesforce/apex/WeatherApiController.fetchWeather';
import WEATHERINFO_OBJECT from "@salesforce/schema/WeatherInfo__c";

export default class WeatherData extends LightningElement {
    @api recordId;
    weatherResponse;
    currentWeather;
    isVisible = false;
    weatherIcon;
    cloudy = IMAGES+'/WeatherIcons/Cloudy.gif';
    sunny = IMAGES+'/WeatherIcons/sunny.gif';
    rainy = IMAGES+'/WeatherIcons/rainy.gif';
    error;    

    async fetchWeather() {

        try {
            const response = await fetchWeather({recordId : this.recordId});
            console.log('response!');
            console.log(response);
            await this.setWeatherData(response);
        } catch(error) {
            this.error = error;
            console.error(this.error);
        }
        
    }

    async setWeatherData(response) {
       
        if(response == null) {
            throw new Error('No weather data!');
        }
        
        this.isVisible = true;
        this.weatherResponse = response;
        if(response.weather !=null && response.weather.length > 0 ) {
            this.currentWeather = response.weather[0];
            // Default to cloudy. Based on weather icon values, images can be updated
            this.weatherIcon = this.cloudy;
        }

        const fields = {};
        fields['Weather_Location__c'] = this.recordId;
        fields['Current_Temperature__c'] = this.weatherResponse.main.temp;
        fields['Feels_Like__c'] = this.weatherResponse.main.feels_like;
        fields['Description__c'] = this.currentWeather.description;
        fields['Name'] = this.weatherResponse.name;
        const recordInput = {
            apiName: WEATHERINFO_OBJECT.objectApiName,
            fields: fields
        };
        
    
        //Invoke createRecord
        const weatherInfo = await createRecord(recordInput);
        console.log('weather info created with id: ', weatherInfo);
          
    }
}
