//
//  ViewController.swift
//  SearchMap
//
//  Created by Apple on 17.08.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let istek = MKLocalSearch.Request()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate  = self
        mapView.delegate = self
        
        
        let konum  = CLLocationCoordinate2D(latitude: 41.03, longitude: 28.96)
        let span  =  MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region  = MKCoordinateRegion(center: konum, span: span)
        mapView.setRegion(region, animated: true)
        
        istek.region = mapView.region
        
        
        
    }


}

extension ViewController: UISearchBarDelegate, MKMapViewDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // arama yapınca bu çalışıyor
        self.view.endEditing(true)// klavye kaybolsun
        
        istek.naturalLanguageQuery = searchBar.text!
        
        // pinlemeden  önce
        // haritada pin var ise ona göre işlem yap
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        let search =  MKLocalSearch(request: istek)
        
        search.start { (res, err) in
            if err != nil {
                
            }else if res!.mapItems.count == 0 {
                print("mekan yok")
            }else {
                // mekan vardır ve artık abılırız
                
                for mekan in res!.mapItems {
                    if let ad = mekan.name,let tel = mekan.phoneNumber {
                        print("ad:\(ad)")
                        print("tel:\(tel)")
                        print("ad:\(mekan.placemark.coordinate.latitude)")
                        print("ad:\(mekan.placemark.coordinate.longitude)")
                        
                        // pinler için
                        
                        let pin = MKPointAnnotation()
                        pin.coordinate = mekan.placemark.coordinate
                        pin.title = ad
                        pin.subtitle = tel
                        self.mapView.addAnnotation(pin)
                        
                        
                    }
                }
            }
        }
        
        
        
    }
    
}

