import MapKit

extension MKAnnotationView: Identifiable {}

public extension MKMapView {
    var zoomLevel: Double {
        log2(360 * (Double(frame.size.width / 256) / region.span.longitudeDelta)) + 1
    }

    func register(_ annotationClass: MKAnnotationView.Type) {
        register(annotationClass.self, forAnnotationViewWithReuseIdentifier: annotationClass.reuseIdentifier)
    }

    func dequeue<T>(_ annotationClass: T.Type) -> T where T: MKAnnotationView {
        // swiftlint:disable:next force_cast
        dequeueReusableAnnotationView(withIdentifier: annotationClass.reuseIdentifier) as! T
    }

    func dequeue<T>(_ annotationClass: T.Type, for annotation: MKAnnotation) -> T where T: MKAnnotationView {
        // swiftlint:disable:next force_cast
        dequeueReusableAnnotationView(withIdentifier: annotationClass.reuseIdentifier, for: annotation) as! T
    }
}
