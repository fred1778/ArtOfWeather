//
//  onboardingView.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 18/01/2021.
//

import SwiftUI

struct O1 : View{
    @Binding var selection : Int
    @State private var entry = false
    var body: some View{
        VStack{
            Text("Welcome to the Art of Weather")
                .multilineTextAlignment(.center)
                .veryFlexiFutura(.white, 40, bold: false)
                .opacity(entry ? 1 : 0)
                .animation(.easeIn)
            
        }.onAppear(){
            entry.toggle()
        }
        
    }
}
struct O2 : View{
    @Binding var selection : Int
    @State private var entry = false
    let tag = 2
    var body: some View{
        
        GeometryReader{ geo in
        VStack{
          
          
            Image("help")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .scaleEffect(tag == selection ? 1.2 : 0.6)
                .opacity(tag == selection ? 1 : 0.6)
                .animation(.easeIn)


          
        
            
        }.onAppear(){
            entry.toggle()
        }
        }
    }
}
struct onboardingView: View {
    @Binding var onboarding : Bool
    @State private var selection = 1
    var body: some View {
        
        TabView(selection: $selection){
            
               O1(selection: $selection)
                .tag(1)
            
            O2(selection: $selection)
                .tag(2)
                .onTapGesture {
                    onboarding.toggle()
                }
            
        }.tabViewStyle(PageTabViewStyle())
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
        
        
        
        
        
    }
}

