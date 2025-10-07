//
//  SettingsView.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 06/01/2021.
//

import SwiftUI

struct restore : View{
    let storemanager : AppStoreObserver
    var body: some View{
        
        Button(action: {
            storemanager.restoreTry()
        }){
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(ThemeColours.main)
                .overlay(
                    
                    Text("Restore Premium")
                        .veryFlexiFutura(.white, 18, bold: false)

                
                )
                
                .frame(height: 35)
            
        }
        
    }
}
struct getPremium : View{
    @ObservedObject var storemanager : AppStoreObserver
    @Binding var refire : Bool
    @State private var iap_conf = false
    @AppStorage("premium") var premium = false
    
    var body: some View{
        Button(action:{
            if !premium{
                //iap_conf = true
            storemanager.purchaseTry()
            }
        }){
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(ThemeColours.main)
                .animation(.easeIn)
                .overlay(
                    VStack{
          
                            Image(systemName: "star.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                    Text( premium ? "You've got premium" : "Get Premium for \(storemanager.price_str)")
                            .veryFlexiFutura(.white, 18, bold: false)
               
                        
                        if !premium{
                            
                            HStack{
                            Text("6 day forecast")
                                .veryFlexiFutura(.black, 12, bold: true)
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white))
                                
                            Text("More Artworks")
                                    .veryFlexiFutura(.black, 12, bold: true)
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white))
                                
                            Text("Save Locations")
                                    .veryFlexiFutura(.black, 12, bold: true)
                                    
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white))
                                
                                
                            
                            }.padding(.horizontal, 3)

                        }
                
                    }
                
                )
                .frame(height: premium ? 60 : 100)
                .disabled(premium ? true : false)
                .alert(isPresented: $storemanager.error){
                    Alert(title: Text("Unable to Purchase Item"), message: Text("Please try again"))
                }
             

        }
        
    }
}

struct LowDataToggle : View{
    @AppStorage("low_data_mode") var lowData = false

    let lowPowerModeOFF = "Low Data Mode off. The app will display high-quality images."
    let lowPowerModeON = "Low Data Mode on. The app will display lower-resolution images and consume less data."

    var body: some View{
        
        VStack {
            HStack{
                
                Text("Low Data Mode")
                    .veryFlexiFutura(.primary, 20, bold: false)

                Spacer()
                Toggle("Low Data Mode", isOn: $lowData)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint:ThemeColours.main))

                
                
            }
            HStack {
                Text(lowData ? lowPowerModeON : lowPowerModeOFF)
                    .veryFlexiFutura(ThemeColours.main, 13, bold: false)
                    .multilineTextAlignment(.leading)
                    .animation(.easeIn)
                    .frame(height: 40)
                Spacer()
            }                    .animation(.easeIn)


        }
        
    }
    
    
    
}

struct TempUnitToggle : View{
    

    @AppStorage("temp") var temp = true
    @State var optSel = 1
    
 
    var body: some View{
        HStack{
            Text("Temperature")
                .veryFlexiFutura(.primary, 20, bold: false)

            Spacer()
            HStack{
            Text("℃")
                .veryFlexiFutura(temp ? ThemeColours.main : .primary, 20, bold: false)
                .scaleEffect(temp  ? 1.2 : 1.0)
                .opacity(temp  ? 1.0 : 0.6)
                .animation(.easeIn)
                .onTapGesture {
                    optSel = 1
                    
                   
                        self.temp = true
           
                }
                Spacer()
            
            Text("℉")
                .veryFlexiFutura(temp  ? .primary : ThemeColours.main, 20, bold: false)
                .scaleEffect(temp ? 1.0 : 1.2)
                .opacity(temp  ? 0.6 : 1.0)

                .animation(.easeIn)
                .onTapGesture {
                    optSel = 2
                    self.temp = false

                }
            }.frame(maxWidth: 100)
        }
    }
}

struct WindUnitToggle : View{
    

    @AppStorage("wind") var wind = true
    @State var optSel = 1
    
 
    var body: some View{
        HStack{
            Text("Wind Speed")
                .veryFlexiFutura(.primary, 20, bold: false)

            Spacer()
            HStack{
            Text("kmh")
                .veryFlexiFutura(wind ? ThemeColours.main : .primary, 20, bold: false)
                .scaleEffect(wind  ? 1.2 : 1.0)
                .opacity(wind  ? 1.0 : 0.6)
                .animation(.easeIn)
                .onTapGesture {
                    optSel = 1
                    
                   
                        self.wind = true
           
                }
                Spacer()
            
            Text("mph")
                .veryFlexiFutura(wind  ? .primary : ThemeColours.main, 20, bold: false)
                .scaleEffect(wind ? 1.0 : 1.2)
                .opacity(wind  ? 0.6 : 1.0)
                .animation(.easeIn)
                .onTapGesture {
                    optSel = 2
                        self.wind = false
              
                }
            }.frame(maxWidth: 100)
        }
    }
}


struct SettingsView: View {
    
    @Binding var act_sheet : ActSheets?
    @Binding var refire : Bool
    @AppStorage("premium") var premium = false
    @ObservedObject var storemanager : AppStoreObserver

    var body: some View {
       // ScrollView(.vertical){
        VStack{
            
            
            HStack {
                Spacer()
                Text("Settings")
                    .veryFlexiFutura(.primary, 35, bold: false)
                    .underline(color: ThemeColours.main)
                 
                Spacer()
                Button(action:{
                    self.act_sheet = nil
                }){
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(ThemeColours.main)
                    .padding(0)

                }
            }

            
            WindUnitToggle()
                .padding(.top, 20)
         TempUnitToggle()
            .padding(.top, 20)
        LowDataToggle()
            .padding(.top, 20)
        
            getPremium(storemanager: storemanager, refire: $refire)
            .padding(.top, 35)
        
            if !premium{
            restore(storemanager: storemanager)
                .padding(.top, 15)
            }

            Spacer()
            
            AboutSection()
                .padding(.top, 20)
            //Spacer()
            
        }.padding()
        .onChange(of: storemanager.didMoveToPremium, perform: { value in
            if premium{
                self.refire = true
                
            }
            
        })
            
            
        
        
    }
}

struct AboutSection : View{
    
    
    let datestr = "1-3-24"
    var body: some View{
        VStack{
            
            
            Text("Version 2 Dev Build " + datestr)
                .foregroundColor(.blue)
            
            
          /*  Text("About")
                .veryFlexiFutura(.primary, 35, bold: false)
          
                .background(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(ThemeColours.main)
                    .offset(y: 30)
                
                )
                .padding(.bottom, 14)*/
            HStack{
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    
             Text("Weather data provided by")
                .veryFlexiFutura(.primary, 14, bold: false)
                LinkText(text: "OpenWeatherMap", link: "https://openweathermap.org")

                Spacer()
            }
            .padding(.bottom, 4)
            HStack{
                Image(systemName: "paintpalette.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Text("Artwork provided by")
                .veryFlexiFutura(.primary, 14, bold: false)
                LinkText(text: "The Met Museum", link: "https://www.metmuseum.org")
                Spacer()
            }            .padding(.bottom, 4)

            HStack{
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
       
            LinkText(text: "Privacy Policy", link: "https://artofweather.wordpress.com")
            Spacer()
            }
        }
        
    }
}

struct LinkText : View{
    let text : String
    let link : String
    var body: some View{
        Text(text)
            .veryFlexiFutura(ThemeColours.main, 14, bold: false)
            .overlay(
            Rectangle()
                .foregroundColor(ThemeColours.main)
                .frame(height: 2)
                .offset(y: 10)
            )
            .onTapGesture {
                if let url = URL(string: link){
                    UIApplication.shared.open(url)
                }
            }

    }
}
extension String{
    
    
    func getUDKey() -> String{
        var key = ""
        
        switch self{
        
        case "Temperature":
            key =  "temp"
            
        case "Wind Speed":
            key =  "wind"
        default:
            key = "ERROR_NO_MATCHING_KEY"
        }
        
        
        return key
    }
}

extension Double{
    
    func temperatureFormat(_ degC: Bool) -> String{
        var ctf = 9.0/5.0
        var out = ""
        var round = 0.0
        var inted = 0
        var suffix = "°"
        if degC{
            
            round = self.rounded()
            
        } else{
            
            round = ((self * ctf) + 32 ).rounded()
        }
        inted = Int(round)
        out = String(inted) + suffix
        
        return out
    }
}
