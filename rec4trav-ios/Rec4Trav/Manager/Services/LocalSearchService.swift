import Foundation
import MapKit
import Combine

class LocalSearchService: ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()
    let locationManager = LocationManager()
    var cancellables = Set<AnyCancellable>()
    @Published var landmarks: [Landmark] = []
    @Published var selectedLandmark : Landmark? // Rename 'landmark' to 'selectedLandmark'

    init() {
        locationManager.$region.assign(to: \.region, on: self)
            .store(in: &cancellables)
    }

    func search(query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = self.locationManager.region

            let search = MKLocalSearch(request: request)
            search.start { response , error in
                if let response = response {
                    let mapItems = response.mapItems

                    let newLandmarks = mapItems.map {
                        Landmark(placemark: $0.placemark)
                    }

                    DispatchQueue.main.async { // Update landmarks on main queue
                        self.landmarks = newLandmarks
                    }
                }
            }
        }
    }
}

class LocalSearchViewModel: ObservableObject {
    @Published var localSearchService: LocalSearchService

    init(localSearchService: LocalSearchService) {
        self.localSearchService = localSearchService
    }

    func search(query: String) {
        localSearchService.search(query: query)
    }
}
