import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var localSearchService: LocalSearchService
    @State private var search: String = ""
    
    var body: some View {
        VStack{
            TextField("Search...", text: $search)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    //Search neraby places
                    localSearchService.search(query: search)
                }.padding()
            
            if localSearchService.landmarks.isEmpty {
                Text("Amazing places to be in awaits you!")
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 2)
                    )
            } else {
                LandmarkListView()
            }
            
            Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                
                MapAnnotation(coordinate: landmark.coordinate) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(localSearchService.selectedLandmark == landmark ? .purple : .red)
                        .scaleEffect(localSearchService.selectedLandmark == landmark ? 2 : 1)
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
