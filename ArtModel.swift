//
//  ArtModel.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import Foundation
import SwiftUI
import CoreLocation



class CacheManager{
    
    static var cache : NSCache<NSString, UIImage> = {
        var nc = NSCache<NSString, UIImage>()
        nc.countLimit = 7
        nc.totalCostLimit = 0
        
        return nc
    }()
    
    static func emptyCache(){
      //  print("CM * cahce emptied")
        self.cache.removeAllObjects()
    }
    
    static func addToCahce(url: String, image: UIImage){
      //  print("CM * image added to cahce")
        self.cache.setObject(image, forKey: NSString(string: url))
    
    }
    static func getImage(url: String) -> UIImage? {
        
        if let image = self.cache.object(forKey: NSString(string:url)){
            return image
        } else {
            return nil 
        }
        
    }
}


public struct MainCache{
    
    static var imageCache = [String : Image]()
    static var userLocationOnStart : CLLocation?
    static var userLocationDisplay : String?
    static var currentCoord : CLLocationCoordinate2D = CLLocationCoordinate2D()
    static var activeArt = [String]()
}



extension Array where Element == String{
    
    func randomID() -> String{
        var control = 0
        var rand = 0
        while control < 1{
         rand = Int.random(in: 0..<self.count)
            if !MainCache.activeArt.contains(self[rand]){
                print("unique id found")
                control = 1
            } else{
                print("id already in use, getting another")
            }
        }
        return self[rand]
        
    }
    
    
}



// UPDATES FOR 10
public struct ArtLibrary{
    
    static let storm = ["11050", "11319", "439333", "11309", "339802", "11289", "746834", "340873", "12024", "372207", "10497", "335175", "10209", "20768", "438643", "436021", "411170", "635821", "436176", "45287", "830299", "438953", "20639", "728488", "399786", "11131"] //redone
    
    
    
    
    static let drizzle = ["435839", "10946"]
    
    
    
    static let rain = ["57043", "51084", "55415", "36930", "56899", "51087", "45286", "56937", "36971", "51086", "45067", "36521", "14205", "37968", "365456","377646", "437040","436555", "437547", "421657", "11229", "11053", "436787", "441967", "54733", "756750", "386168", "436006", "437585", "343090", "436832", "437102", "339791", "333927", "344847", "352287"] //redone
    
    static let rain_PRM = rain + ["437079", "437518", "10480", "13356", "14426", "436558", "436088", "705480", "49926", "438375", "383807", "355545", "10491", "11311", "13115", "36708", "356875"]
    
    
    
    static let snow = ["55862","56890", "55998", "55417", "10805", "56779", "335206", "36937", "56889", "437686", "436826", "372206", "55685", "55603", "37058", "36535","36513", "383808", "37242", "55987", "435633", /*NEW > */ "682689"] //redone
    
    static let snow_PRM = snow + ["437192", "10207", "13452", "54646", "384597", "752047", "352286", "437269"]
    
    static let clear = ["437683", "10499", "435872", "437980", "459109", "359160", "435839", "438105", "438106", "11307", "438644", "12953", "437682", "437998", "340666", "437427", "437680", "437682", "438677", "437512", "459095", "12534", "404157", "54868", "435750", "363847", "339645", "337306", "437848","10777", "437983", "435909", "438118", "435857", "437039", "339947", "364046", "335081", "397978", "436090", "372671", "435962", "10501", "395780", "459729", "437235", /* NEW > */ "11147"]
    
    static let clear_PRM = clear + ["459114", "435905", "11093", "437300", "435874", "435968", "435878", "11771", "11320", "11314", "11316", "11323", "18447", "333773", "36498", "819449", "10364", "372749", "16869", "11016", "37041", "392343", "385073", "460968", "461529", "438670", "436597", "436084", "438015", "437460"]
    
    static let sun_cloud = ["436064", "437521", "812318", "436599", "438116", "437549", "436005", "437588", "438642", "10464", "437312", "436535", "435646", "373907", "11140", "375834", "812318", "438380", "437587", "437514", "454429", "343087", "438640", "437548", "437380", "283124", "436085", "436324", "437764", "435746", "286336", "436653", "437052", "341086", "340849", "428620", "437426", "459121", "728489", "459111", "11395", "436863", "436890", "339790", "372742", "335621", "10771", "459099", "436205", "435737", "435723", "437517", "437586", "436831", "436081", "459983", "338917", "338197", "372222"]
    
    static let sun_cloud_PRM = sun_cloud + ["437760", "430831", "694642", "437299", "18354", "387593", "10154", "10796", "437515", "348833", "10788", "435966", "11851", "10589", "11312", "11225", "11518", "12719", "12754", "11042", "10934","335559", "382611", "399852", "436849", "364366", "437307", "461366", "382625", "438738", "11121", "55441", "10150", "337499", "435983", "267425", "435793","436647", "437589", "435673", "435987", "437935", "360450", "335617"]
    
    
    static let clouds = [ "435809", "438642", "727706", "394482", "437987", "437519", "438641", "437914", "436241", "436559", "437876", "359577", "335792", "436830", "437521", "339156", "343607","359578", "341197", "438374", "437308", "436441", "436556", "436536", "437102", "435842", "21693", "436557", "436575", "11227", "437094", "438113", "12672", "436062", "10155", "10216", "11113", "435775", "696941", "335189", "335485", "436451", "437657", "437545", "436057", "459115", "436083", "435877", "436595", "10215", "341093", "363061", "335099", "333916", "460046", "441755" , "11234", "341792", "339896", "334286", "335689", "11977", "459113", "437473", "437461", "11233", "435707", "375871", "363587", "10584", "13379", "10149", "355597", "11910", "14202", "11253"]
    
    
    static let clouds_PRM = clouds + ["11317", "11318", "11370", "11381", "11543", "11623", "12711", "12802", "10944", "13357", "13453", "13454", "20421", "355390", "339733", "382737", "359573", "334350", "437041", "459122", "12757", "372170", "359579", "364367", "383818", "348320", "343089", "356768", "365455", "14836", "10456", "337325", "728490", "335604", "335203", "771718", "395093"]
    
    
    static let sunset = ["435773", "11326", "11324", "11329", "11325", "11897", "437941", "437095", "342992", "437191", "438849", "10872", "37362", "782303", "333939", "420448", "437975", "10983", "747611", "436833", "11230", "11328", "11255", "10945", "683207", "11909", "359580", "438951"]
    
    
    
    static let sunrise = ["435907", "370637", "10158", "436086", "11235", "11017"]
    
    static let mist = ["337874", "341667", "11308", "437852", "437854", "341195", "56611"]

    static let mist_PR = mist + ["12842", "417459", "10151", "54687", "356984", "51293", "647000"]
    
    
    static let clear_night = ["459189", "438417", "336486", "57058", "11305", "439343", "333877", "57039", "437979", "359382", "54709", "359883", "436632", "16577", "11127", "11979", "441379", "53682"]
    
    static let clear_night_PRM = clear_night + ["54197", "55553", "283255", "382342", "56591", "437349", "362646"]
    static let cloud_night = ["441379", "441769", "438954", "10455", "337516", "359576","437080", "10183", "436596", "437886"]
    
    
   static func WTHR_IMG_REPORT(){
    
    let total = self.clear.count + self.sun_cloud.count + self.clouds.count + self.snow.count + self.rain.count + self.mist.count + self.drizzle.count +  self.storm.count  + self.sunrise.count + self.sunset.count + self.cloud_night.count + self.clear_night.count
        
        print("* * * *  WTHR IMG REPORT * * * * *")
        print("CLEAR: ------- \(self.clear.count)")
        print("SUNCLOUD: -\(self.sun_cloud.count)")
        print("CLOUD: ------ \(self.clouds.count)")
        print("SNOW:---------- \(self.snow.count)")
        print("RAIN: ----------\(self.rain.count)")
        print("MIST: ----------\(self.mist.count)")

        print("DRIZZLE: --- \(self.drizzle.count)")
        print("STORM: ------- \(self.storm.count)")
        print("SUNRISE: --- \(self.sunrise.count)")
        print("SUNSET: ----- \(self.sunset.count)")
        print("NT_CLR:  \(self.clear_night.count)")
        print("NT_CLOUD:\(self.cloud_night.count)")
        print("**********************************")
        print("TOTAL ___________ \(total)")
        
    }
  
}



extension Int{
    
    func getSFIcon(lightState: LightState?) -> String{
        var obj = ""
        
        switch self{
        
        case 200...299:
            obj = "cloud.bolt.rain"
            
     //   print("strom")
            
        case 300...399:
            obj = "cloud.drizzle"
    //    print("drizzle")
            
            
        case 500...599:
            obj =  "cloud.rain"

    //    print("rain")
            
            
        case 600...699:
            obj = "cloud.snow"

     //   print("snow")
            
        case 800:
            obj =  "sun.max"
            if lightState == .night{
                obj = "moon.stars"
            }

   //     print("clear")
            
            
            
            
        case 803...805:
            obj = "cloud"

    //    print("clouds")
        case 801...802:
            
        obj = "cloud.sun"
   //         print("part cloudy")
            if lightState == .night{
                obj = "cloud.moon"
            }
        case 701:
            obj =  "cloud.fog"

 //       print("mist")
            
        default:
            obj =  "cloud"

    //        print("other")
            
        
        }
        
    //    print(self)
        
        return obj
    }
    
    
    
    
    
    func getArtID(isDark: LightState?) -> String{
        
        let PR = UserDefaults.standard.bool(forKey: "premium")
        
        
        var obj = ""
        
        if isDark != nil{
            print("is it dark? \(isDark!.rawValue)")
        }
        switch self{
        
        case 200...299:
            obj =  ArtLibrary.storm.randomID()
            
        print("strom")
        case 300...399:
            obj = ArtLibrary.drizzle.randomID()
       print("drizzle")
        case 500...599:
            obj = PR ? ArtLibrary.rain_PRM.randomID() : ArtLibrary.rain.randomID()

        print("rain")
        case 600...699:
            obj =  PR ? ArtLibrary.snow_PRM.randomID() : ArtLibrary.snow.randomID()

        print("snow")
            
            
        case 800:
          
            
            obj =  ArtLibrary.clear.randomID()
            
            
            if isDark == .night{
                print("night")

                obj =  PR ? ArtLibrary.clear_night_PRM.randomID() : ArtLibrary.clear_night.randomID()
            }
            
            if PR{
            if isDark == .sunset{
                obj = ArtLibrary.sunset.randomID()
            }
            
                if isDark == .sunrise{
                    obj = ArtLibrary.sunrise.randomID()
                }
            }
            
            
         print("clear")
            
            
        case 803...805:
            obj =  PR ? ArtLibrary.clouds_PRM.randomID() : ArtLibrary.clouds.randomID()
            if isDark == .night{
                obj = ArtLibrary.cloud_night.randomID()
            }

        print("clouds")
            
            
        case 801...802:
            
            obj =  PR ? ArtLibrary.sun_cloud_PRM.randomID() : ArtLibrary.sun_cloud.randomID()
            
            if isDark == .night{
                
                obj = (ArtLibrary.cloud_night + ArtLibrary.clear_night).randomID()
            }
            
            if PR{
            if isDark == .sunset{
                obj = ArtLibrary.sunset.randomID()
            }
            }
            
            
            
            
            print("part cloud")
        case 701:
            obj =  ArtLibrary.mist.randomID()

        print("mist")
            
            
        default:
            obj =  ArtLibrary.clouds.randomID()

            print("other")
        
        }
  //      print(">>>>>>>>>>>>>>>> \(obj)")
        return obj
    }
}




public struct ArtAPI{
    
    // we will draw from arrays of objectIDs whcich all have public domain art
    
    static let root = "https://collectionapi.metmuseum.org/public/collection/v1/objects/"
    
    static func getObject(_ obj_ID: String) -> URL{
        let strURL = root + obj_ID
        return URL(string: strURL)!
        
    }
}
struct ArtObject : Codable {
    
    let title : String
    let culture : String
    let period : String
    let artistDisplayName : String
    let artistDisplayBio : String
    let artistNationality : String
    let objectDate : String
    let medium : String
    let artistBeginDate : String
    let artistEndDate : String
    
    let primaryImage : String
    let primaryImageSmall : String

}




