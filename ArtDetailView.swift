//
//  ArtDetailView.swift
//  Weather2
//
//  Created by Fred Clamp-Gray on 05/01/2021.
//

import SwiftUI


struct topDismissButton : View{
    
    @Binding var sheetControl : ActSheets?

    var body: some View{
        HStack{
            Spacer()
            
            Button(action:{
                self.sheetControl = nil
            }){
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(ThemeColours.main)
                .padding(0)

            }.frame(height: 10)
            .padding(.bottom, 10)

        }
        
    }
}


struct artWorkInfoBlock : View{
    @Binding var artWork : ArtObject
    var dateTxtHandler : String{
        var str = ""
        str = artWork.objectDate == "n.d." || artWork.objectDate == "" ? "Date uncertain" : artWork.objectDate

        return str
    }
    var body: some View{
        HStack(alignment: .top){
            

            Text(dateTxtHandler)
                .veryFlexiFutura(ThemeColours.main, 15, bold: true)
                .multilineTextAlignment(.leading)
                .padding(.trailing, 10)


    
            
            
            Spacer()
            
            
    
            Text(artWork.medium)
                .veryFlexiFutura(Color(UIColor.systemGray2), 15, bold: true)
                .multilineTextAlignment(.trailing)

            
          
            
            
        }
        
        
    }
}





struct artistInfoBlock : View{
    @Binding var artInfo : ArtObject
    var natText : String{
        
        return artInfo.artistNationality == "" ? "" : (artInfo.artistNationality + ", ")
    }
  var body: some View{
 
    HStack(alignment: .top) {
            

                
            Text(artInfo.artistDisplayName)
                .veryFlexiFutura(Color.primary, 18, bold: false)
                .multilineTextAlignment(.leading)

    

            Spacer()

      
            Text(natText + artInfo.artistBeginDate + " - " + artInfo.artistEndDate)
                .veryFlexiFutura(Color.primary, 16, bold: false)
                .multilineTextAlignment(.trailing)
                
            

    }
        
    }
}

struct ThinRedLine : View{
    var body: some View{
        HStack{
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray2))
                .frame(height: 1)
        }.padding(5)
    }
}

struct ArtDetailView: View {
    @Binding var artInfo :  ArtObject
    @Binding var sheetControl : ActSheets?
    
    var body: some View {
        
        VStack{
            topDismissButton(sheetControl: $sheetControl)
         
            if MainCache.imageCache[artInfo.primaryImage] != nil{
            MainCache.imageCache[artInfo.primaryImage]!
            .resizable()
            .aspectRatio(contentMode: .fit)

            } else if MainCache.imageCache[artInfo.primaryImageSmall] != nil{
                MainCache.imageCache[artInfo.primaryImageSmall]!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
                    
            HStack {
                Text(artInfo.title)
                    .veryFlexiFutura(Color.primary, 25, bold: false)
                Spacer()
            }.padding(.bottom, 6)
            ThinRedLine()


            artWorkInfoBlock(artWork: $artInfo)
                .opacity(0.8)
  
            ThinRedLine()

            artistInfoBlock(artInfo: $artInfo)

                Spacer()
            
        }.padding()
            .onAppear(){
             //   print(artInfo.title)
                //if MainCache.imageCache[artInfo.primaryImage] != nil{
                   // print("it's in the cache")
                    
               // }
            }
    }
}

