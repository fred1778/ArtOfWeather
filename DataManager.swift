//
//  DataManager.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import Foundation
import SwiftUI


struct sheetModel {
   
    
    
    
    var  temp : Double = 0.0
    var  tempMin : Double = 0.0
    var  windspeed : Double = 0.0
    var  windDirection : Double = 0.0
    var  weather : WeatherCondition = WeatherCondition(id: 999, main: "", description: "")

    // for today forc
    
    var today_temp_max : Double = 0.0
    var today_temp_min : Double = 0.0
    var today_weather : WeatherCondition = WeatherCondition(id: 999, main: "", description: "")
    var today_hourly : [Hourly] = [Hourly(dt: 0, temp: 0.0, weather: [WeatherCondition(id: 0, main: "", description: "")])]
    
    var timezoneOffset : Int = 0
    
    var sunrise : Int = 0
    var sunset : Int = 0
    
}


class WeatherArtInfo : ObservableObject{
    
    @Published var ready = false
    
    
    @Published var weatherData : Response?
    @Published var artworkData : ArtObject = ArtObject(title: "", culture: "", period: "", artistDisplayName: "", artistDisplayBio: "", artistNationality: "", objectDate: "", medium: "", artistBeginDate: "", artistEndDate: "", primaryImage: "", primaryImageSmall: "")
    @Published var artworkImage : Image?
    @Published var currentWeather  = sheetModel()
  //  @Published var todayWeather = sheetModel()
    @Published var tomorrowWeather = sheetModel()
    @Published var datWeather = sheetModel()
    @Published var lastWeather = sheetModel()
    @Published var nextWeather = sheetModel()
    
    @Published var SIX_weather = sheetModel()
    @Published var SEVEN_weather = sheetModel()

    
    
    @Published var weatherLoadError = false
    
    
    
    @AppStorage("premium") var premium = false
    
    
    
    func getWeatherArtData(lat: String, lon: String){
        self.weatherLoadError = false

        let request = URLRequest(url: API.requestURL(lat: lat, lon: lon))
        print(request.url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
           // print("first url session begin")

            if let error = error{
                print(error)
                
                DispatchQueue.main.async {
                    
                
                self.weatherLoadError = true
                }
            }
            if let data = data{
                
                DispatchQueue.main.async {
                    
                    self.weatherData = self.decodeAndParse(data)
                    
                   
                  //  print(self.weatherData)
      
                    

                    
           //         self.getArtForID(idFromCondition: weatherData.)
                }
                
                
            }
            
        })
        task.resume()
        
    }
    
    func decodeAndParse(_ data: Data) -> Response?{
        
        let decoder = JSONDecoder()
    //    print(data)
        do{
            let weather = try decoder.decode(Response.self, from: data)
           // print(weather)
            
            self.currentWeather = sheetModel(temp: weather.current.temp, windspeed: weather.current.wind_speed, windDirection: weather.current.wind_deg, weather: weather.current.weather[0], today_temp_max: weather.daily[0].temp.max, today_temp_min:  weather.daily[0].temp.min, today_weather: weather.daily[0].weather[0], today_hourly: weather.hourly, timezoneOffset: weather.timezone_offset, sunrise: weather.current.sunrise, sunset: weather.current.sunset)
            
            self.tomorrowWeather = sheetModel(temp: weather.daily[1].temp.max, tempMin: weather.daily[1].temp.min, windspeed: weather.daily[1].wind_speed, windDirection: weather.daily[1].wind_deg, weather: weather.daily[1].weather[0], timezoneOffset: weather.timezone_offset)
            
            self.datWeather = sheetModel(temp: weather.daily[2].temp.max, tempMin: weather.daily[2].temp.min, windspeed: weather.daily[2].wind_speed, windDirection: weather.daily[2].wind_deg, weather: weather.daily[2].weather[0], timezoneOffset: weather.timezone_offset)
            
            self.lastWeather = sheetModel(temp: weather.daily[3].temp.max, tempMin: weather.daily[3].temp.min, windspeed: weather.daily[3].wind_speed, windDirection: weather.daily[3].wind_deg,weather: weather.daily[3].weather[0], timezoneOffset: weather.timezone_offset)
            
            
            if premium{
            self.nextWeather = sheetModel(temp: weather.daily[4].temp.max, tempMin: weather.daily[4].temp.min, windspeed: weather.daily[4].wind_speed, windDirection: weather.daily[4].wind_deg, weather: weather.daily[4].weather[0],  timezoneOffset: weather.timezone_offset)
            
            self.SIX_weather = sheetModel(temp: weather.daily[5].temp.max, tempMin: weather.daily[5].temp.min, windspeed: weather.daily[5].wind_speed, windDirection: weather.daily[5].wind_deg, weather: weather.daily[5].weather[0],  timezoneOffset: weather.timezone_offset)
            
            
          //  self.SEVEN_weather = sheetModel(temp: weather.daily[6].temp.max, tempMin: weather.daily[6].temp.min, windspeed: weather.daily[6].wind_speed, windDirection: weather.daily[6].wind_deg, weather: weather.daily[6].weather[0],  timezoneOffset: weather.timezone_offset)

            }
         //   print("has recieved and loaded, setting ready to true")
            self.ready = true
  
            
            return weather
        } catch{
            print(error)
            return nil
        }
        
        
        
    }
    
    
    
    ///- MARK :  ART STUFF
    

        
    }
    

class ArtData : ObservableObject{
    
    
    
    @Published var artworkData : ArtObject?
    @Published var artworkImage : Image?
    @Published var readyForImg = false
    @AppStorage("low_data_mode") var lowData = false
    
    func artDataParse(_ data: Data) -> ArtObject?{
        
        print("art data parse")
        
        let decoder = JSONDecoder()
        do{
            let artData = try decoder.decode(ArtObject.self, from: data)
            
            self.getImageForURL(url: lowData ? artData.primaryImageSmall : artData.primaryImage)
            
            return artData
        } catch{
            print(error)
            return nil
        }
    }
    
    
    func getArtForID(idFromCondition: String){
        
        let request = URLRequest(url: ArtAPI.getObject(idFromCondition))
       
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error{
                print(error)
            }
            if let data = data{
                
                DispatchQueue.main.async {
                    
                    self.artworkData = self.artDataParse(data)
                    
                }
                
                
            }
            
        })
        task.resume()
        
    }

    func getImageForURL(url: String) {
        
      //  print("imageget called")
        guard let imgURL = URL(string: url) else {
        //    print("url error")
            return}
        
        URLSession.shared.dataTask(with: URLRequest(url: imgURL), completionHandler: { (data, response, error) -> Void in
       //     print("img sesh")
            if let error = error{
                print(error)
            }
            if let data = data{
            //    print("img fetch8")

                DispatchQueue.main.async {
                 //   print("img fetch")
                    
                    self.artworkImage = Image(uiImage: UIImage(data: data) ?? UIImage(imageLiteralResourceName: "default"))
                    
                    MainCache.imageCache[url] = self.artworkImage
                //    CacheManager.addToCahce(url: url, image: UIImage(data: data)!)
                    
                 //   print("MCHE IC COUNT: \(MainCache.imageCache.count)")
                  
                }
            }
            
        })
        .resume()
    
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
