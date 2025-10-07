//
//  DesignSupport.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import Foundation
import SwiftUI

struct cardTextTitleStyle : ViewModifier{
    
    let colour : Color
    func body(content: Content) -> some View {
        content
            .font(.custom("Baskerville", size: 28))
            .foregroundColor(colour)
        
        
    }

    
    
}


struct ThemeColours{
    static let main = Color(UIColor.init(red: 101/255.0, green: 123/255.0, blue: 131/255.0, alpha: 1))
}
struct detailSerifStyle : ViewModifier{
    
    let colour : Color
    func body(content: Content) -> some View {
        content
            .font(.custom("Baskerville", size: 18))
            .foregroundColor(colour)
        
        
    }

    
    
}



struct cardTextBodyStyle : ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Baskerville", size: 22))
            .foregroundColor(.black)
        
        
    }

    
    
}

struct adpaptiveTextBody : ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Baskerville", size: 22))
        
        
    }

    
    
}













struct highLevelStyleBlack : ViewModifier{
    let colour : Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura", size: 18))
            .foregroundColor(colour)
        
        
    }

    
    
}
struct highestLevelStyle : ViewModifier{
    let colour : Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura", size: 30))
            .foregroundColor(colour)
        
        
    }

    
    
}







struct captionFTC : ViewModifier{
    let colour : Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura-Bold", size: 13))
            .foregroundColor(colour)
    }
 
}






struct flexiFTC : ViewModifier{
    
    func body(content: Content) -> some View {
        content
          .font(.custom("Futura-Bold", size: 12))
    }
 
}

struct flexiFTCSizable : ViewModifier{
    let size : CGFloat
    let colour : Color
    let bold : Bool
    func body(content: Content) -> some View {
        content
            .font(.custom(bold ? "Futura-Bold" : "Futura", size: size))
          .foregroundColor(colour)
    }
 
}


struct flexiBaskSizable : ViewModifier{
    let size : CGFloat
    let colour : Color
    func body(content: Content) -> some View {
        content
          .font(.custom("Baskerville", size: size))
          .foregroundColor(colour)
    }
 
}








struct smallHeadingFTC : ViewModifier{
    let colour : Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Futura-Bold", size: 18))
            .foregroundColor(colour)
        
    }

    
    
}








extension View{
    func cardBodyStyle() -> some View{
        modifier(cardTextBodyStyle())
    }
    
    func highLevelBlack(_ colour: Color) -> some View{
        modifier(highLevelStyleBlack(colour: colour))
    }
    
    func cardTitleStyle(_ colour : Color) -> some View{
        modifier(cardTextTitleStyle(colour: colour))
    }
    func generalBodyText() -> some View{
        modifier(adpaptiveTextBody())
    }
    func captionStyleFTC(_ colour: Color) -> some View{
        modifier(captionFTC(colour: colour))
    }
    
    func smallHeadingFT(_ colour: Color) -> some View{
        modifier(smallHeadingFTC(colour: colour))
    }
    func majorTitleFT(_ colour: Color) -> some View{
        modifier(highestLevelStyle(colour: colour))
    }
    
    func detailSerif(_ colour: Color) -> some View{
        modifier(detailSerifStyle(colour: colour))
    }
    
    func flexiFutura() -> some View{
        modifier(flexiFTC())
    }
    
    func veryFlexiFutura(_ colour: Color, _ size: CGFloat, bold: Bool) -> some View{
        modifier(flexiFTCSizable(size: size, colour: colour, bold: bold))
    }
    
    func veryFlexiBaskerville(_ colour: Color, _ size: CGFloat) -> some View{
        modifier(flexiBaskSizable(size: size, colour: colour))
    }
    
}
