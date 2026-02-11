import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var position: MapCameraPosition

    init(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        _position = State(initialValue: .region(region))
    }

    var body: some View {
        Map(position: $position)
    }
}

#Preview {
    MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868))
}
