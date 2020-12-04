import Foundation

struct Route: Codable {
  let id: Int
  let title: String
  let distance: Int
  let startLocation: String
  let endLocation: String
  let loadQuantity: Int
  let loadType: String
  let minExperience: Int
  let minHealth: Int
  let priority: String
}

struct DesignatedRoute: Codable {
  let id: Int
  let route: Route
  let status: String
}
