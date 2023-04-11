//
//  LandmarkListView.swift
//  Rec4Trav
//
//  Created by Ömür Şenocak on 9.04.2023.
//

import SwiftUI
import MapKit


struct LandmarkListView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    var body: some View {
        VStack {
            
            List(localSearchService.landmarks){ landmark in
                VStack(alignment: .leading){
                
                    Text(landmark.name)
                    Text(landmark.title)
                        .opacity(0.5)
                }
                .listRowBackground(localSearchService.landmark == landmark ? Color(UIColor.lightGray) : Color.white)
                .onTapGesture {
                    localSearchService.landmark = landmark
                    withAnimation{
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                    }
                }
            }
        }
    }
}

struct LandmarkListView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkListView()
    }
}
