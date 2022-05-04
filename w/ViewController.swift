//
//  ViewController.swift
//  weatherapp
//
//  Created by Гость on 29.04.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

@IBOutlet weak var cityName: UILabel!
@IBOutlet weak var weatherDescriptionLabel: UILabel!
@IBOutlet weak var temperatureLabel: UILabel!
@IBOutlet weak var weatherIconImageView: UIImageView!

let locationManager = CLLocationManager()
var weatherData = WeatherData()

override func viewDidLoad() {
    super.viewDidLoad()

    startLocationManager()
}

func startLocationManager() {
    locationManager.requestWhenInUseAuthorization()

    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
}

func updateView() {
    cityName.text = weatherData.name
    weatherDescriptionLabel.text = DataSource.weatherIDs[weatherData.weather[0].id]
    temperatureLabel.text = weatherData.main.temp.description + "°"
    weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
}

func updateWeatherInfo(latitude: Double, longtitude: Double) {
    let session = URLSession.shared
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=62,03&lon=129,7&appid=d4e106082927edc4ff6a00fe69ff6196&units=metric&lang=ru")!
    let task = session.dataTask(with: url) { (data, response, error) in
        guard error == nil else {
            print("DataTask error: \(error!.localizedDescription)")
            return
        }

        do {
            self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
            DispatchQueue.main.async {
                self.updateView()
            }
             }   catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
        }
    }
}

