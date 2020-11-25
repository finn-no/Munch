//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

public protocol SearchResultMapViewDelegate: AnyObject {
    func searchResultMapView(_ view: SearchResultMapView, didSelect action: MapSettingsView.Action, in mapSettingsView: MapSettingsView)
    func searchResultMapView(_ view: SearchResultMapView, didSelect annotationView: MKAnnotationView)
    func searchResultMapView(_ view: SearchResultMapView, didDeselect annotationView: MKAnnotationView)
    func searchResultMapView(_ view: SearchResultMapView, didUpdate userLocation: MKUserLocation)
    func searchResultMapViewRegionWillChangeDueToUserInteraction(_ view: SearchResultMapView)
    func searchResultMapViewRegionDidChange(_ view: SearchResultMapView)
}

public final class SearchResultMapView: UIView {

    // MARK: - Public properties

    public weak var delegate: SearchResultMapViewDelegate?

    public var zoomLevel: Double {
        mapView.zoomLevel
    }

    public var centerCoordinate: CLLocationCoordinate2D {
        mapView.centerCoordinate
    }

    public var visibleMapRect: MKMapRect {
        mapView.visibleMapRect
    }

    // MARK: - Private properties

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.register(PinAnnotationView.self)
        view.register(ClusterAnnotationView.self)
        return view
    }()

    private lazy var mapSettingsButton: MapSettingsView = {
        let mapSettingsButton = MapSettingsView(withAutoLayout: true)
        mapSettingsButton.delegate = self
        return mapSettingsButton
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func configure(withInitialRegion region: MKCoordinateRegion, andShowingUserLocation showingUserLocation: Bool) {
        setRegion(region, animated: false)
        showUserLocation(value: showingUserLocation)
    }

    public func showUserLocation(value: Bool) {
        mapView.showsUserLocation = value
    }

    public func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }

    public func setCenter(_ coordinate: CLLocationCoordinate2D, regionDistance: CLLocationDegrees, animated: Bool) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: animated)
    }

    public func setCenterOnUserLocation(regionDistance: CLLocationDegrees, animated: Bool) {
        if mapView.userLocation.location != nil {
            setCenter(mapView.userLocation.coordinate, regionDistance: regionDistance, animated: animated)
        }
    }

    public func setMapOverlay(_ newOverlay: MKTileOverlay) {
        if let lastOverlay = mapView.overlays.last {
            mapView.removeOverlay(lastOverlay)
        }

        mapView.addOverlay(newOverlay)
    }

    public func clearMapOverlay(_ overlay: MKTileOverlay) {
        mapView.removeOverlay(overlay)
    }

    public func addAnnotation(_ annotation: SearchResultMapViewAnnotation) {
        mapView.addAnnotation(annotation)
    }

    public func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }

    @available(iOS 13.0, *)
    public func configureMapZoomRange(_ range: MapZoomRange) {
        mapView.setCameraZoomRange(range.toCameraZoomRange(), animated: false)
    }

    /// Set the visible region so that the map focuses all annotations of the type SearchResultMapViewAnnotation
    ///
    /// - Parameter animated: optionaly present animated
    public func focusVisibleAnnotations(_ animated: Bool) {
        let annotationsToShow = mapView.annotations.filter { $0 is SearchResultMapViewAnnotation }
        mapView.showAnnotations(annotationsToShow, animated: animated)
    }

    /// Set the visible region to a MKMapRect that fits the passed region
    ///
    /// - Parameters:
    ///   - mapRect: MKMapRect to fit and focus
    ///   - animated: optinaly present animated
    public func focusMapRect(_ mapRect: MKMapRect, animated: Bool) {
        let fittedMapRect = mapView.mapRectThatFits(mapRect)
        mapView.setVisibleMapRect(fittedMapRect, animated: animated)
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(mapView)
        addSubview(mapSettingsButton)

        mapView.fillInSuperview()

        NSLayoutConstraint.activate([
            mapSettingsButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: .spacingS),
            mapSettingsButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -.spacingS)
        ])
    }

}

// MARK: - MapSettingsViewDelegate

extension SearchResultMapView: MapSettingsViewDelegate {
    public func mapSettingsView(_ view: MapSettingsView, didSelect action: MapSettingsView.Action) {
        delegate?.searchResultMapView(self, didSelect: action, in: view)
    }
}

// MARK: - MKMapViewDelegate

extension SearchResultMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: overlay)
        }

        return MKOverlayRenderer(overlay: overlay)
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard
            !(annotation is MKUserLocation),
            let annotation = annotation as? SearchResultMapViewAnnotation
        else { return nil }

        let annotationView: MKAnnotationView
        if annotation.hits == 1 {
            annotationView = mapView.dequeue(PinAnnotationView.self, for: annotation)
        } else {
            annotationView = mapView.dequeue(ClusterAnnotationView.self, for: annotation)
        }

        annotationView.centerOffset = CGPoint(x: 0.5, y: 1.0)
        return annotationView
    }

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        delegate?.searchResultMapView(self, didSelect: view)
    }

    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        delegate?.searchResultMapView(self, didDeselect: view)
    }

    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if let view = mapView.subviews.first {
            let isDueToUserInteraction = view.gestureRecognizers?.first(where: { $0.state == .began || $0.state == .ended })

            if isDueToUserInteraction != nil {
                delegate?.searchResultMapViewRegionWillChangeDueToUserInteraction(self)
            }
        }
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delegate?.searchResultMapViewRegionDidChange(self)
    }

    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        delegate?.searchResultMapView(self, didUpdate: userLocation)
    }
}
