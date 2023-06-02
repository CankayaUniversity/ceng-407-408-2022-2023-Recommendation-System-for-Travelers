//
//  MapView.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 9.04.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var localSearchService: LocalSearchService
    @State private var search: String = "müze"
    let searchItems = ["Müze", "Sanat Galerisi", "Akvaryum", "Kilise", "Cami", "Sinagog"]
    var body: some View {
        VStack{
            
        /*
        TextField("Search...", text: $search)
            .textFieldStyle(.roundedBorder)
            .onAppear {
                //Search neraby places
                localSearchService.search(query: search)
            }.padding()
            */
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    ForEach(0..<searchItems.count, id: \.self){ i in
          
                  
                        
                    Button(action: {
                        search = self.searchItems[i]
                        localSearchService.search(query: search)
                    }, label: {
                        Text("\(self.searchItems[i])")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.gray, lineWidth: 2)
                            )
                })
                        
                }
                }.padding()
                 
                
            }
            
            if localSearchService.landmarks.isEmpty {
                Text("Amazing places to be in awaits you!")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 2)
                    )
            }else{
                LandmarkListView()

            }
        
            
            Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                
                MapAnnotation(coordinate: landmark.coordinate){
                    
                   Image(systemName: "mappin")
                        .foregroundColor(localSearchService.landmark == landmark ? .purple : .red)
                        .scaleEffect(localSearchService.landmark == landmark ? 2 : 1)
                }
            }
        
        Spacer()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(LocalSearchService())
    }
}

