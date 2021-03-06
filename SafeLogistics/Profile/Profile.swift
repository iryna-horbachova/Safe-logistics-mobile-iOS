import Foundation

struct User: Codable {
  let id: Int
  let firstName: String
  let lastName: String
  let email: String
}

struct Driver: Codable {
  let user: User
  let averageSpeedPerHour: Int
  let carMaxLoad: Int
  let carType: String
  let currentLocation: String
  let experience: Int
  let healthState: Int
  let licenseType: String
  let payForKm: Int
}

struct HealthState: Codable {
  let heart_rate: Int
  let bodyTemperature: Double
  let respirationRatePerMinute: Int
  let bloodPressureSystolic: Int
  let bloodPressureDiastolic: Int
  let bloodOxygenLevel: Int
  
  let bloodAlcoholContent: Double
  let bloodDrugsContent: Double
  
  let datetime: String?
}

struct Token: Codable {
  let email: String
  let userId: Int
  let token: String
}
