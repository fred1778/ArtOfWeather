//
//  Model.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import Foundation
import SwiftUI
import CoreLocation



public func checkForFav(_ loc: String, _ place: String) -> Bool{
    let favs = UserDefaults.standard.dictionary(forKey: "saved_locs")!
    var update = favs as! [String : String]

    if update.values.contains(place){
        return true
    } else {
        return false
    }
    
}


public func addToFav(_ loc: String, _ place: String){
    var favs = UserDefaults.standard.dictionary(forKey: "saved_locs")!
    var update = favs as! [String : String]
    update[loc] = place
    UserDefaults.standard.set(update, forKey: "saved_locs")
    print("ADDED TO FAV: \(place), ARRAY IS NOW: \(update)")
    

}

public func removeFav(_ loc: String, _ pl: String){
    var favs = UserDefaults.standard.dictionary(forKey: "saved_locs")!
    var update = favs as! [String : String]
    if update.values.contains(pl){
        print("update contains PL")
        if let key = update.first(where: {$0.value == pl})?.key{
            print("key found")
            update.removeValue(forKey: key)
        }
    }
    update.removeValue(forKey: loc)
    UserDefaults.standard.set(update, forKey: "saved_locs")
    print("REMOVED TO FAV: \(pl), ARRAY IS NOW: \(update)")


}



public enum LightState : String{
    case day, sunrise, sunset, night
}

public struct GeneralSupport{
    static let settingsURL = URL(string: UIApplication.openSettingsURLString)
}



public struct API{
    static let apiKey = "86bbfd1a9cce2b7a21dda2751616aead"
    static let oneCallBase = "https://api.openweathermap.org/data/2.5/onecall?"
    
   static func requestURL(lat: String, lon: String) -> URL{

        
    let strURL = self.oneCallBase + "lat=" + lat + "&lon=" + lon + "&units=metric&exclude=minutely&appid=" + self.apiKey
    
   
    let url =  URL(string: strURL)!
    
        
        return url
    }
}



struct conformedWeatherObject{
    
    
}

struct WeatherCondition : Codable{
    let id : Int
    let main : String
    let description : String
}


struct CurrentWeather : Codable{
    let temp : Double
    let wind_speed : Double
    let sunrise : Int
    let sunset : Int
    let wind_deg : Double
    let weather : [WeatherCondition]

    
    
}

struct DayTemp : Codable{
    let min : Double
    let max : Double
    
}
struct DayWeather : Codable{
    
    let dt : Int
    let sunrise : Int
    let sunset : Int
    let temp : DayTemp
    let weather : [WeatherCondition]
    let wind_speed : Double
    let wind_deg : Double
    
}

struct Response : Codable{

    let timezone_offset : Int
    let current : CurrentWeather
    let hourly : [Hourly]
    let daily : [DayWeather]
    
}

struct Hourly : Codable{
    
    let dt : Int
    let temp : Double
    let weather : [WeatherCondition]
}

extension Int{
    
    
    func dateTimeConvertToTime(tz_offset: Int) -> String{
        var formattedHour = ""
        let rawDate = Date(timeIntervalSince1970: Double(self))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(secondsFromGMT: tz_offset)
        formatter.locale = Locale.current
        formatter.pmSymbol = "PM"
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formattedHour = formatter.string(from: rawDate)
        return formattedHour
    }
    
    
    
    
    
}



public func isItDark(sunrise: Int, sunset: Int, targetTime: Int?) -> LightState{
    
    let currentTime = Date().timeIntervalSince1970
    
    var opTime = currentTime
    if targetTime != nil{
        opTime = Double(targetTime!)
    }
    
    let sunriseRange = Double(sunrise - 1800)...Double(sunrise + 1800)
    let sunsetRange = Double(sunset - 1800)...Double(sunset + 1800)
    var state : LightState = .day
    
    if sunriseRange.contains(opTime){
//        print("its sunrise period")
        state = .sunrise
    }
    if sunsetRange.contains(opTime){
 //       print("it's sunset period")
        state = .sunset
    }
    if opTime < Double(sunrise - 1800){
  //      print("its dark - before sunrise period")
        state = .night
    }
    if opTime > Double(sunset + 1800){
   //     print("its dark - after sunset period")
        state = .night

    }
    return state
    
}



public func windRender(_ speed : Double, _ direction: Double, isKMH: Bool) -> String{
    
    let compassPoint = ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"]
    
    
    let kmh = speed * 3.6
   // print(kmh)
    var basicWind = 0
    if !isKMH{
        let convert = kmh/1.609
    ///    print(convert)
        basicWind = Int(convert.rounded())
    } else{
    //    print(basicWind)
        basicWind = Int(kmh.rounded())
    }
    
    
    var out = ""
    
    let bearing_index = Int((direction/22.5).rounded()) 
  //  print(bearing_index)
    let bearing_str = compassPoint[bearing_index]
    
    out = String(basicWind) + " " + bearing_str
 //   print("WIND CAL   \(basicWind) with dir \(bearing_str)")
    return out
}

extension CLLocationCoordinate2D{
    func stringConvert() -> String{
        
        var LAT = String(self.latitude)
        var LON =  String(self.longitude)
        
        return LAT + "*" + LON
        
    }
}

extension String{
    
    
    func getCoordsFromLiteral() -> CLLocationCoordinate2D{
        
        let str_arrays = self.components(separatedBy: "*")
        let lat = Float(str_arrays[0])!
        let lon = Float(str_arrays[1])!
        
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        
        
    }
}
