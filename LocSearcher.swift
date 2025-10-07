//
//  LocSearcher.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import SwiftUI
import MapKit
import CoreLocation






struct searchBar : View{
    @Binding var input : String
    @Binding var locSearch2 : LocSearch_two
    var body: some View{
        
        
        HStack {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .padding(.vertical, 0)

            TextField("Location search", text: $input)
                .padding(.vertical, 0)
                .veryFlexiFutura(.primary, 20, bold: false)
                .onChange(of: input, perform: { value in
                   // searchSystem.searchFor(input)
                    locSearch2.searchFor(input)
                })
                
            
       
        }.padding(7)
        .overlay(RoundedRectangle(cornerRadius: 25)
                    .stroke(lineWidth: 1.0)
                    .opacity(0.6)
                    .foregroundColor(.primary))
    }
}

struct toggler : View{
    @Binding var onFav : Bool
    var body: some View{
    ZStack{
        HStack(spacing: 0){
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(onFav ? ThemeColours.main : .gray)

                .frame(height: 30, alignment: .center)
                .animation(.easeIn)
                .onTapGesture {
                    onFav = true
                }
                .overlay(
                    Text("Search")
                        .veryFlexiFutura(.white, 15, bold: false)
                        .opacity(onFav ? 1 : 0.6)
                
                )
            
        
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(onFav ? .gray : ThemeColours.main)
                .frame(height: 30, alignment: .center)
                .animation(.easeIn)
                .onTapGesture {
                    onFav = false
                }
                .overlay(
                    Text("Saved Locations")
                        .veryFlexiFutura(.white, 15, bold: false)
                        .opacity(onFav ? 0.6 : 1.0)
                    
                            

                )
            
        }
        
        
        HStack(spacing: 0){
            Spacer()
            Rectangle()
                .foregroundColor(onFav ? ThemeColours.main : .gray)
                .frame(width: 30, height: 30, alignment: .center)
                .animation(.easeIn)
            Rectangle()
                .foregroundColor(onFav ? .gray : ThemeColours.main)
                .frame(width: 30, height: 30, alignment: .center)
                .animation(.easeIn)

            Spacer()
        }
        
    }
    }
}

struct CurrentLocationRow : View{
    let display = MainCache.userLocationDisplay

    var body: some View{
        HStack{
            Image(systemName: "location.fill")
                .foregroundColor(ThemeColours.main)
            
            VStack(alignment: .leading) {
                Text("Your current location")
                    .veryFlexiFutura(.primary, 15, bold: false)
                Text(display!)
                    .veryFlexiFutura(ThemeColours.main, 10, bold: true)
            }
            Spacer()
        }.frame(height: 50)
    }
}


struct favLocRow : View{
    let place : String
    let coord : String
    @State var fav = true
    @Binding var faves : [String : String]
    var body: some View{
        HStack{
            Image(systemName: "star.fill")
                .font(.system(size: 15))
                .foregroundColor(ThemeColours.main)
            Text(place)
                .veryFlexiFutura(.primary, 15, bold: false)
            Spacer()
            
            Image(systemName: "xmark")
                .font(.system(size: 15))
                .foregroundColor(ThemeColours.main)
                .onTapGesture {
                    faves.removeValue(forKey: coord)
                    removeFav(coord, place)
                    fav = false
                }
        }.opacity(1)
        .animation(.easeIn)
    }
}
struct LocationResultRow : View{
    @State var fav = false
    let place : MKLocalSearchCompletion
    var body: some View{
        
        HStack {
            VStack(alignment: .leading){
                Text(place.title)
                    .veryFlexiFutura(.primary, 15, bold: false)
                
              //  Text(place.subtitle)
               //     .veryFlexiFutura(.red, 12, bold: false)

            }
            Spacer()
         

        }
    }
}





struct LocSearcher: View {
    
    @Binding var refire : Bool
    
    @ObservedObject var locSearch2 = LocSearch_two()
    @Binding var dismissKey : Bool
    @Binding var returning : MKPlacemark?
    @Binding var sheetControl : ActSheets?
    @Binding var userWasOnCL : Bool
    @Binding var loc_display : String
    @State private var viewMode = true
    @Binding var isReturningFav : Bool
    @AppStorage("premium") var prem = false
    @State private var faveLocs = UserDefaults.standard.dictionary(forKey: "saved_locs")!
    @State var input = ""
    
    let APO : AppStoreObserver


    func CLReturn(){
        
        MainCache.imageCache.removeAll()

        self.returning = MKPlacemark(coordinate: MainCache.userLocationOnStart!.coordinate)
        self.dismissKey = true
        self.isReturningFav = false
        self.userWasOnCL = true
        self.sheetControl = nil
        self.loc_display = MainCache.userLocationDisplay!
        
        
        
    }
    
    
    func SRReturn(){
        print("succesful return")
       // CacheManager.emptyCache()

        self.returning = locSearch2.returnedPlace
        self.dismissKey = true
        self.isReturningFav = false

        self.userWasOnCL = false
        self.sheetControl = nil

        
        
    }
    
    func isCL() -> Bool{
        if MainCache.userLocationOnStart != nil && !userWasOnCL{
            return true
        } else {
            return false
        }
    }
    
    
    var body: some View {
        VStack{
            
            topDismissButton(sheetControl: $sheetControl)
            
         
            toggler(onFav: $viewMode)
                .padding(.bottom, 10)
            
            
        if viewMode{
                HStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .padding(.vertical, 0)

                    TextField("Location search", text: $input)
                        .padding(.vertical, 0)
                        .veryFlexiFutura(.primary, 20, bold: false)
                        .onChange(of: input, perform: { value in
                           // searchSystem.searchFor(input)
                            locSearch2.searchFor(input)
                        })

               
                }.padding(7)
                .overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1.0)
                            .opacity(0.6)
                            .foregroundColor(.primary))
            
            
                
            List{
               
                if isCL(){
                CurrentLocationRow()
                    .onTapGesture {
                        CLReturn()
                    }
                }
                
                if self.input != ""{
                ForEach(locSearch2.comp_results, id: \.self){ result in
                    
                   LocationResultRow(place: result)
                    
                        
                    .onTapGesture {
                        var serchRes = self.locSearch2.proceedOnTap(result)

                    }
                        .onChange(of: locSearch2.returnedPlace, perform: { value in
                            if locSearch2.returnedPlace != nil{
                                
                            SRReturn()
                            }
                            
                        })
                    
                }

                }
                }
            
                } else {
                    
                    savedLocView(returning: $returning, dismissKey: $dismissKey, isReturningFav: $isReturningFav, userWasOnCL: $userWasOnCL, sheetControl: $sheetControl, loc_display: $loc_display, refire: $refire, APO: APO)
                    
                }
        
        
            
        }.padding()

        }
        
    }

    

extension Dictionary where Key == String{
    
    
    func keyArray() -> [String]{
    
        var rawKeys = self.keys
        var strKeys = [""]
        for key in rawKeys{
            var stk = String(key)
            strKeys.append(stk)
        }
        return strKeys
    }
}

struct savedLocView : View{
    
    @Binding var returning : MKPlacemark?
    @Binding var dismissKey : Bool
    @Binding var isReturningFav : Bool
    @Binding var userWasOnCL : Bool
    @Binding var sheetControl : ActSheets?
    @Binding var loc_display : String
    @Binding var refire : Bool

     var APO : AppStoreObserver

    @AppStorage("premium") var PR = false
    
    @State private var faveLocs = UserDefaults.standard.dictionary(forKey: "saved_locs") as! [String : String]
    
    func FRReturn(fav: String){
        
        
        MainCache.imageCache.removeAll()
        self.returning = MKPlacemark(coordinate: fav.getCoordsFromLiteral())
        self.dismissKey = true
        self.isReturningFav = true
        self.userWasOnCL = false
        self.sheetControl = nil
        self.loc_display = UserDefaults.standard.dictionary(forKey: "saved_locs")![fav] as! String
        
    
        
        
        
    }
    
    
    var body: some View{
        VStack{
            
            
  if PR{
        List{
        if faveLocs.keyArray().count > 1{

            ForEach(faveLocs.keyArray(), id: \.self){ fav in
            
            if fav != ""{
                favLocRow(place: faveLocs[fav] as! String, coord: fav, faves: $faveLocs)
                .onTapGesture {
                    
                    print(faveLocs)
                
                    FRReturn(fav: fav)
                    print("returning fave for view : \(fav)")
                }
            
                
            }
        }
            
        } else {
            
            saveExampleView()
            

        }
        }
  } else {
    Spacer()
    
    getPremiumLocSr(store: APO, refire: $refire)
    
  }
            Spacer()
            
            
        }
    }
}
struct getPremiumLocSr : View{
    
    @ObservedObject var store :  AppStoreObserver
    @Binding var refire : Bool
    @AppStorage("premium") var premium = false
    var body: some View{
        
        RoundedRectangle(cornerRadius: 12)
            .foregroundColor(ThemeColours.main)
            .shadow(color: .black, radius: 6, x: 0, y: 0)
            .frame(height: 300)
            .overlay(
                
                VStack{
                    HStack{
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Text("Upgrade to Premium to save your favourite locations" )
                        .multilineTextAlignment(.center)
                        .veryFlexiFutura(.white, 20, bold: false)
                        .minimumScaleFactor(0.5)

                        .padding(.bottom, 15)
                    
                    Text("You'll also get...")
                        .veryFlexiFutura(.white, 20, bold: false)
                    
                    
                    HStack{

                    Text("Wider Range of Art")
                        .padding()
                        .frame(height: 70)

                        .veryFlexiFutura(.white, 13, bold: true)
                        .multilineTextAlignment(.center)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                        .opacity(0.5))
                        
                        Spacer()
                        Text("6 Day Forecast")
                            .padding()
                            .frame(height: 70)
                            .veryFlexiFutura(.white, 13, bold: true)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white)
                                            .opacity(0.5))
                        
                      
                        
                        
                    }
                    Spacer()
                    Button(action:{
                        store.purchaseTry()
                    }){
                        
                        Text("GET PREMIUM FOR \(store.price_str)")
                            .padding()
                            .foregroundColor(.white)
                            .veryFlexiFutura(.white, 16, bold: false)
                            .minimumScaleFactor(0.5)
                            .onAppear{
                                print(store.price_str)
                            }

                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.white)
                            
                            )
                        
                    }
                    
                }.padding()
            
                .alert(isPresented: $store.error){
                    Alert(title: Text("Unable to Purchase Item"), message: Text("Please try again"))
                }
                .onChange(of: store.didMoveToPremium, perform: { value in
                    if premium{
                        print("refire")
                        self.refire = true
                        
                    }
                    
                })
            
            
            )
        
        
    }
}

struct saveExampleView : View{
    @State private var animate = false
    var body: some View{
        
        HStack{
            Text("Save locations by tapping the star next to them")
                .veryFlexiFutura(.primary, 15, bold: false)
                .padding(.vertical, 10)

            Spacer()
            HStack{
            Text("London")
                .veryFlexiFutura(.black, 12, bold: false)
                .padding(.horizontal, 5)

                Spacer()
            Image(systemName: animate ? "star.fill"  : "star")
                .font(.system(size: 15))
                .scaleEffect(animate ? 1.2 : 1.0)
                .foregroundColor(ThemeColours.main)
                .animation(Animation.easeIn.repeatForever(autoreverses: true))
                .padding(.horizontal, 5)
            }
            .frame(width: 110)
            .onAppear(){
                animate.toggle()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.gray)
                    .opacity(0.6)
            
            )
        }
    }
}
