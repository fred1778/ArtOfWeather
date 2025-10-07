//
//  ContentView.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import SwiftUI
import CoreLocation
import MapKit

enum ActSheets : Identifiable{
    
    case loc, art, set
    
    var id : Int{
        hashValue
    }
}


struct OnbSwipe : View{
    @State private var swiper = false
    @AppStorage("NEEDS_ONBOARDING") var onboarding = false
    var body: some View{
        
        VStack{
        
        Image(systemName: "hand.point.up.left.fill")
            .font(.system(size: 50))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 6, x: 0.0, y: 0.0)
            .offset(x: swiper ? -40 : 40)
            .animation(Animation.easeIn(duration: 3).repeatForever(autoreverses: true))
            
        
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.white)
            .shadow(color: .black, radius: 6, x: 0.0, y: 0.0)

            .frame(width: 150, height: 100, alignment: .center)
            .overlay(
                
                VStack{
        Text("Swipe to move between days")
            .veryFlexiFutura(.black, 12, bold: true)
                
                    HStack{
                    Text("Tap to Dismiss")
                        .veryFlexiFutura(ThemeColours.main, 12, bold: true)

                    } .onTapGesture {
                        onboarding = false
                    }
                    .padding(.top, 20)
                
                
                    
                }
                
            )
            

                   

  

            
            
        }.onAppear(){
            swiper.toggle()
        }
  
        .transition(.scale)
    }
}




struct OnbLabel : View{
    let arrowPoint : Int
    let txt : String
    @AppStorage("NEEDS_ONBOARDING") var ONB = false
    var body: some View{
        
        
        RoundedRectangle(cornerRadius: 5)
            .foregroundColor(.white)
            .shadow(color: .black, radius: 6, x: 0.0, y: 0.0)

            .frame(width: 100, height: 55, alignment: .center)
            .overlay(
                HStack{
                    if arrowPoint == 1{
                        Image(systemName: "arrow.up")
                            .foregroundColor(ThemeColours.main)
                            .imageScale(.large)
                            .font(.system(size: 12))
                    }
                    Text(txt)
                        .veryFlexiFutura(.black, 12, bold: true)
                    
                    if arrowPoint == 3{
                        
                        Image(systemName: "arrow.up")
                            .foregroundColor(ThemeColours.main)
                            .imageScale(.large)

                            .font(.system(size: 12))
                        
                        
                    }
                    
                }.padding(2)
            )
        
        
    }
}

struct TopControl : View {
    
    @Binding var userWasOnCL : Bool
    @Binding var ready : Bool
    @Binding var display : Bool
    @Binding var is_current_loc : Bool
    @Binding var sheetID : ActSheets?
    @Binding var primaryLoc : String
    @Binding var selection : Int
    @Binding var isReturningFav : Bool
    @AppStorage("premium") var PR = false
    @AppStorage("NEEDS_ONBOARDING") var onboarding = false
    @State private var loc_fav_update = false
    @State private var faveLocs = UserDefaults.standard.dictionary(forKey: "saved_locs") as! [String : String]

    @State private var onb_overlay_animate = false
    
    func isCL() -> Bool{
        if MainCache.userLocationOnStart != nil && !userWasOnCL{
            return false
        } else {
            return true
        }
    }
    
    func localStatusCheck() -> Bool{
       

        if faveLocs.values.contains(primaryLoc){
            return true
        } else {
            return false
        }
    }
    
    
    func imgReadyValidation() -> Bool{
    
        if selection == 1{
            return true
        }
        
        if MainCache.imageCache.count >= selection{
            print("IRV true")

            return true
        } else {
            print("IRV false")
            return false
        }
    
    }
    var body: some View{
        
        HStack{
            Image(systemName: "gearshape.fill")
                .font(.system(size: 25))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 3, x: 0, y: 0)

                .onTapGesture {
                    self.display.toggle()
                    self.sheetID = .set
                }
                .overlay(
                    
                    VStack{
                        
                        if onboarding{
                   
                    OnbLabel(arrowPoint: 1, txt: "Open settings")
                        .offset(x: 25, y: onb_overlay_animate ? 45 : 50)
                        .animation(Animation.easeIn(duration: 2).repeatForever(autoreverses: true))
                        }
                    }
                )
            
            Spacer()
            
            HStack {
                if is_current_loc || isCL(){
                Image(systemName: "location.fill")
                    .font(.system(size: 19))
                    .padding(.leading, 5)

                }
                Text(primaryLoc)
                    .veryFlexiFutura(.black, 17, bold: false)
                    .padding(.horizontal, 5)
                
               if PR{
                if primaryLoc != "Getting Location..." && !is_current_loc && !isCL(){
                    Image(systemName:   isReturningFav ? "star.fill"  :"star")
                    .font(.system(size: 19))
                    .foregroundColor(ThemeColours.main)
                    .padding(.trailing, 5)
                   
                    .onTapGesture {
                        print("tap")
                        
                        loc_fav_update.toggle()
                        self.isReturningFav.toggle()
                        if !checkForFav(MainCache.currentCoord.stringConvert(), primaryLoc){
                            addToFav(MainCache.currentCoord.stringConvert(), self.primaryLoc)
                        //    print("adding loc")
                        } else {
                            removeFav(MainCache.currentCoord.stringConvert(), primaryLoc)
                           // print("removing loc")
                        }
                        
                        
                    }
                        .onChange(of: primaryLoc, perform: {value in
                            self.loc_fav_update = checkForFav(MainCache.currentCoord.stringConvert(), primaryLoc)
                        
                        })
                }
                }
            
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .opacity(0.6)
            
            )
            .animation(.easeIn)
            
                    .onTapGesture {
                       
                        self.display.toggle()
                        self.sheetID = .loc
                        
            }
            .overlay(
                
                VStack{
                    if onboarding{
                OnbLabel(arrowPoint: 1, txt: "Change Location")
                    .offset(y: onb_overlay_animate ?  45 : 50)
                    .animation(Animation.easeIn(duration: 2).repeatForever(autoreverses: true))
                    }
                }
            )
                
                
            Spacer()
            Image(systemName: "paintpalette.fill")
                .opacity(ready ? 1 : 0.5)
                .animation(.easeIn)
                .font(.system(size: 25))
                .foregroundColor(.white)
                .onTapGesture {
             //       print("art info display")
                    if ready{
                    self.display.toggle()
                    self.sheetID = .art
                    }

                }
                .shadow(color: .black, radius: 3, x: 0, y: 0)
                .overlay(
                    VStack{
                        if onboarding{
                
                    OnbLabel(arrowPoint: 3, txt: "More about the art")
                        .offset(x: -30, y: onb_overlay_animate  ? 45 : 50)
                        .animation(Animation.easeIn(duration: 2).repeatForever(autoreverses: true))

                        }
                    }
                )

            
            
            
        }.padding()
        .onAppear(){
            onb_overlay_animate.toggle()
        }
    }
}
struct ContentView: View {
    
    let APO : AppStoreObserver
    
    @AppStorage("premium") var premium = false
    @AppStorage("NEEDS_ONBOARDING") var onboarding = false
    
    @State private var sparkPlug = true
    
    
    @State private var locDisplay = "Getting Location..."
    @State private var locDismissWithResult = false
    @State private var artInfoDisplay = false
    @State private var cl_unauth_warning = false
    @State private var isCurrentLocDisp = true
    @State private var searchRetrunItem : MKPlacemark?
    @State private var activeSheet : ActSheets?
    @State private var selection = 1
    @State private var isReturningFav = false
    @State private var is_on_user_cl = true
    @State private var reAuthLoc = false
    
    @State private var currentCoord : CLLocationCoordinate2D?
    
    @ObservedObject var weatherInfo = WeatherArtInfo()
    @ObservedObject var locater = LocationFetcher()
    @State var sheetViews = [WeatherArtSheet]()
    @State var loaded = false
    @State var artOverpass : ArtObject = ArtObject(title: "", culture: "", period: "", artistDisplayName: "", artistDisplayBio: "", artistNationality: "", objectDate: "", medium: "", artistBeginDate: "", artistEndDate: "", primaryImage: "", primaryImageSmall: "")
    
    @AppStorage("premium") var PREMIUM_UNLOCK = false
    init(apo: AppStoreObserver){
     
        APO = apo
        locater.authenticate()

    }
    
    var body: some View {
        
        ZStack {
            ZStack{
        
                    
                VStack{
                    TopControl(userWasOnCL: $is_on_user_cl, ready: $weatherInfo.ready, display: $artInfoDisplay, is_current_loc: $isCurrentLocDisp, sheetID: $activeSheet, primaryLoc: $locDisplay, selection: $selection, isReturningFav: $isReturningFav)
                    Spacer()


                }
                .zIndex(2)
                if loaded{
                                   
                        
                    MainTabbedDisplay(selection: $selection, sheetViews: self.sheetViews)
                        .padding(0)



                } else {
                    ErrorManagementView(locaterDeny: $locater.locationDenied, weatherInfoError: $weatherInfo.weatherLoadError, actSheets: $activeSheet, recheck: $reAuthLoc)
                    
                }
                
            
            
            
            }.onChange(of: self.weatherInfo.ready, perform: { value in
                
                print("recharge called by change of ready state. Ready state is \(value)")
                self.recharger(value)
            })

            .onChange(of: self.reAuthLoc, perform: { value in
                if value == true{
                    self.locater.reAuthenticateOnRequest()
                }
            })
            .onChange(of: self.locater.hasGotCurrentLoc, perform: { value in
                
                print("/////////////////// location got")
                    let loc = locater.lastKnownLocation
                
                self.locater.primaryLoc?.geocode(completion: { (places, error) in
                    if error == nil{
                    self.locDisplay = places!.first!.locality ?? "???????"
                        MainCache.userLocationDisplay = self.locDisplay
                    }
                })
                
                    self.currentCoord = loc
                    weatherInfo.getWeatherArtData(lat: String(loc.latitude), lon: String(loc.longitude))

                
                
            })
            
            .sheet(item: $activeSheet, onDismiss:{
                print("dismiss")
                
                
                if locDismissWithResult{
                    
                    if searchRetrunItem != nil{
                        print("location searcher has dismissed with new location")
                        
                        let newLoc = self.searchRetrunItem!.coordinate
                        self.currentCoord = self.searchRetrunItem!.coordinate
                        MainCache.currentCoord = newLoc
                        weatherInfo.ready = false
                       // MainCache.imageCache.removeAll()
                        MainCache.imageCache.removeAll(keepingCapacity: false)
                        print("toggling ready on sheet dismiss to \(weatherInfo.ready)")
                        if !isReturningFav{
                        self.locDisplay = self.is_on_user_cl ?  MainCache.userLocationDisplay! : (self.searchRetrunItem!.locality ?? self.searchRetrunItem!.title ?? "n/a")
                        }
                        self.isCurrentLocDisp = false
                        self.loaded = false
                      //  self.isReturningFav = false
                        self.selection = 1
                        weatherInfo.getWeatherArtData(lat: String(newLoc.latitude), lon: String(newLoc.longitude))
                        
                    }
           
        
                    self.locDismissWithResult = false
                    
                }
                if sparkPlug{
                    weatherInfo.ready = false

                    self.isCurrentLocDisp = false
                    self.loaded = false
                    self.isReturningFav = false
                    self.selection = 1
                    
                    
                    weatherInfo.getWeatherArtData(lat: String(self.currentCoord!.latitude), lon: String(self.currentCoord!.longitude))
                    sparkPlug = false
                }
         
                
                
                
            }){ item in
                switch item{
                case .loc:
                    LocSearcher(refire: $sparkPlug, dismissKey: $locDismissWithResult, returning: $searchRetrunItem, sheetControl: $activeSheet, userWasOnCL: $is_on_user_cl, loc_display: $locDisplay, isReturningFav: $isReturningFav, APO: APO)

                case .art:
                    ArtDetailView(artInfo: $artOverpass, sheetControl: $activeSheet)
                    
                case .set:
                    SettingsView(act_sheet: $activeSheet, refire: $sparkPlug, storemanager: APO)

                }
        }
            
            VStack {
                Spacer()
                if loaded{
                   dayView(selection: $selection, days: weatherInfo.weatherData!.daily)
                }
            
            }
        }
      
        .onAppear(){
            
            if sparkPlug{
            self.locater.start()
                sparkPlug = false
            }

        }
    }
    
    func recharger(_ value : Bool){
        print("recharge")
        
        if !loaded{
            print("recharge2 - data not loaded to view, checking to see if ready")

        if value{
            print("recharge3 - data is ready, loading sheets")

            
            MainCache.activeArt.removeAll()
            self.sheetViews.removeAll()
            self.sheetViews = [WeatherArtSheet]()
            
            sheetViews.append(WeatherArtSheet(info: weatherInfo.currentWeather, artPass: $artOverpass, sel: $selection, tag: 1))
            sheetViews.append(WeatherArtSheet(info: weatherInfo.tomorrowWeather, artPass: $artOverpass, sel: $selection, tag: 2))
            sheetViews.append(WeatherArtSheet(info: weatherInfo.datWeather, artPass: $artOverpass, sel: $selection, tag: 3))
            sheetViews.append(WeatherArtSheet(info: weatherInfo.lastWeather, artPass: $artOverpass, sel: $selection, tag: 4))
         
            sheetViews.append(WeatherArtSheet(info: weatherInfo.nextWeather, artPass: $artOverpass, sel: $selection, tag: 5))
            sheetViews.append(WeatherArtSheet(info: weatherInfo.SIX_weather, artPass: $artOverpass, sel: $selection, tag: 6))
        //    sheetViews.append(WeatherArtSheet(info: weatherInfo.SEVEN_weather, artPass: $artOverpass, sel: $selection, tag: 7))
            
            
            
            
            locDismissWithResult = false
            loaded.toggle()
        }
            
            
        }
    }
    
    
}

struct MainTabbedDisplay : View{
    @Binding var selection : Int
    @AppStorage("premium") var premium = false
    @AppStorage("NEEDS_ONBOARDING") var onboarding = false
    let sheetViews : [WeatherArtSheet]
    var body: some View{
        
        
        TabView(selection: $selection){
        
   
        sheetViews[0]

            .tag(1)
            
        sheetViews[1]
            .tag(2)
        sheetViews[2]
            .tag(3)
        sheetViews[3]
            .tag(4)
            
            
    if premium{
        sheetViews[4]
           .tag(5)
            
        sheetViews[5]
           .tag(6)
            
    //    sheetViews[6]
    //       .tag(7)
        
            }
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
        .zIndex(1)
        .onAppear(){
            UIScrollView.appearance().bounces = false
        }
        .overlay(
            VStack{
                if onboarding{
                OnbSwipe()
                }
            }
        
        )

        
        
        
        
        
        
    }
}


struct ErrorManagementView : View{
    @Binding var locaterDeny : Bool
    @Binding var weatherInfoError : Bool
    @Binding var actSheets : ActSheets?
    @Binding var recheck : Bool
    
    var body: some View{
        
        if !self.locaterDeny{
            if !weatherInfoError{
            loadingView(isWeather: true)
            } else{
                
                errorView(isWeather: true)
            }
        } else if self.locaterDeny{
            
            noCLAuthView(locSys: $recheck, searchShow: $actSheets)
            
        }
    }
}
