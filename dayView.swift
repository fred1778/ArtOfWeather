//
//  dayView.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 06/01/2021.
//

import SwiftUI

struct dayView: View {
    @Binding var selection : Int
    @AppStorage("premium") var PR = false
    var days : [DayWeather]
    let passiveGrey = Color(UIColor.systemGray)
    let passiveOpac = 0.4
    var targetedDays : [String]{
        var target = [DayWeather]()
        target.append(days[1])
        target.append(days[2])
        target.append(days[3])
        target.append(days[4])
        target.append(days[5])
       // target.append(days[6])

        return target.dayDTList(full: PR)
    }
    var body: some View {
        
    GeometryReader{ geo in

        VStack {
            Spacer()
            ZStack{
                
                   Rectangle()
                    .frame(width: geo.size.width, height: 15)
                    .foregroundColor(.white)
                    .overlay(
                        HStack{
                            Spacer()
                            
                            Text("TODAY")
                                .captionStyleFTC(selection == 1 ? ThemeColours.main : passiveGrey)
                                .frame(width: geo.size.width * (PR ? 0.15 : 0.15))
                                .opacity(selection == 1 ? 1 : passiveOpac)
                                .scaleEffect(selection ==  1 ? 1.1 : 1)
                                .animation(.easeInOut)
                            
                            Spacer()
                            
                            Text(targetedDays[0])
                                .captionStyleFTC(selection == 2 ? ThemeColours.main : passiveGrey)
                                .frame(width: geo.size.width * (PR ? 0.14 : 0.24))
                                .opacity(selection == 2 ? 1 : passiveOpac)
                                .scaleEffect(selection ==  2 ? 1.1 : 1)

                                .animation(.easeInOut)

                        =-098765Spacer()
                            Text(targetedDays[1])
                                .captionStyleFTC(selection == 3 ? ThemeColours.main : passiveGrey)
                                .frame(width: geo.size.width * (PR ? 0.14 : 0.24))
                                .opacity(selection == 3 ? 1 : passiveOpac)
                                .scaleEffect(selection ==  3 ? 1.1 : 1)

                                .animation(.easeInOut)


                            Spacer()
                            Text(targetedDays[2])
                                .captionStyleFTC(selection == 4 ? ThemeColours.main : passiveGrey)
                                .frame(width: geo.size.width * (PR ? 0.14 : 0.24))
                                .opacity(selection == 4  ? 1 : passiveOpac)
                                .scaleEffect(selection ==  4 ? 1.1 : 1)

                                .animation(.easeInOut)

                            Spacer()

                            
                            if PR{
                                
                                Text(targetedDays[3])
                                    .captionStyleFTC(selection == 5 ? ThemeColours.main : passiveGrey)
                                    .frame(width: geo.size.width * (PR ? 0.14 : 0.24))
                                    .opacity(selection == 5 ? 1 : passiveOpac)
                                    .scaleEffect(selection ==  5 ? 1.1 : 1)

                                    .animation(.easeInOut)

                                Spacer()
                                Text(targetedDays[4])
                                    .captionStyleFTC(selection == 6 ? ThemeColours.main : passiveGrey)
                                    .frame(width: geo.size.width * (PR ? 0.14 : 0.24))
                                    .opacity(selection == 6 ? 1 : passiveOpac)
                                    .scaleEffect(selection ==  6 ? 1.1 : 1)

                                    .animation(.easeInOut)

                                Spacer()
                              /*  Spacer()
                                Text(targetedDays[4])
                                    .captionStyleFTC(selection == 7 ? .red : passiveGrey)
                                    .frame(width: geo.size.width / (PR ? 15 : 4))
                                    .opacity(selection == 7 ? 1 : passiveOpac)
                                    .animation(.easeInOut)*/


                            }
                            
                    
                            
                            
                        }.frame(width: geo.size.width)
                    )
        
            
             /*   HStack {
                    Rectangle()
                            .frame(width: geo.size.width / (PR == true && selection > 3 ? 14 : 4), height: 15)
                            .foregroundColor(.red)
                        .offset(x: (geo.size.width/(PR ? 7 : 4)) * CGFloat(selection - 1))
                        .animation(.linear)
                        .shadow(radius: 20 )
                        .overlay(
                            Text(selection.dayLabel(dt_list: self.targetedDays))
                                .captionStyleFTC(.white)

                                .offset(x: (geo.size.width/(PR ? 7 : 4)) * CGFloat(selection - 1))
                                .animation(.easeIn)

                        )
                    Spacer()
                }*/
                        
            
             
                

                    
                
            }
        }
        
        }
        
    }
}


extension Int{
    
    func dayLabel(dt_list: [String]) -> String{
        
        var day = ""
        
        switch self{
        case 1:
            day = "TODAY"
        case 2:
            day = "TOMORROW"
        case 3:
            day = dt_list[0]
        case 4:
            day = dt_list[1]
        case 5:
            day = dt_list[2]
        case 6:
            day = dt_list[3]
        case 7:
            day = dt_list[4]
        
        default:
            day = "ERROR"
        
        
        
        }
        
        return day
        
    }
}

extension Array where Element == DayWeather{
    
    func dayDTList(full: Bool) -> [String]{
        var days = [String]()
        let dayformat = full ? "EE" : "EEEE"
        
        for day in self{
            
            let timestamp = Date(timeIntervalSince1970: Double(day.dt))
            let format = DateFormatter()
            format.locale = Locale.current
            format.dateFormat = dayformat
            days.append(format.string(from: timestamp).uppercased(with: Locale.current))
        
        }
        return days
    
        
    }
    
}
