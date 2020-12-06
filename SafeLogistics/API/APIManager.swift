import Foundation

class APIManager {
  static let shared = APIManager()
  static var currentDriver: Driver?
  private let baseURL = "http://127.0.0.1:8000/"
  var token: String?
  
  typealias designatedRoutesCompletionHandler = (Result<[DesignatedRoute], APIError>) -> Void
  typealias driverCompletionHandler = (Result<Driver, APIError>) -> Void
  typealias driversCompletionHandler = (Result<[Driver], APIError>) -> Void
  
  func login(
    email: String,
    password: String,
    completion: @escaping (APIError?) -> ()
  ) {
    let endpoint = baseURL + "users/login/"
    //let group = DispatchGroup()
    //group.enter()
    
    guard let url = URL(string: endpoint) else {
      print("invalid url")
      completion(.invalidData)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    let json: [String: Any] = ["username": email,
                               "password": password]
    print(json)
    
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    request.httpBody = jsonData //httpBody
    print(String(decoding: request.httpBody!, as: UTF8.self))

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      print("login")
      print(String(decoding: data!, as: UTF8.self))
      if let _ = error {
        print("got an error from the server")
        completion(.unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse,
        200 == response.statusCode else {
        print("invalid response")
        completion(.invalidResponse)
        return
      }
      
      guard let data = data else {
        print("invalid data")
        completion(.invalidData)
        return
      }
      
      do {
        print("decoding")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let receivedToken = try decoder.decode(Token.self, from: data)
        APIManager.shared.token = receivedToken.token
        APIManager.shared.getDriverInfo(id: receivedToken.userId) { [weak self] result in
          guard self != nil else { return }
          switch result {
          case .success(let driver):
            DispatchQueue.main.async {
              APIManager.currentDriver = driver
              completion(nil)
            }
          case .failure( _):
            completion(.invalidData)
          }
        }
        //UserDefaults.standard.set(receivedToken.access, forKey: "accessToken")
        //UserDefaults.standard.set(receivedToken.refresh, forKey: "refreshToken")
        //UserDefaults.standard.set(receivedToken.userId, forKey: "userId")
        //group.leave()
        //group.notify(queue: .main) {
          //completion(nil)
        //}
      } catch {
        print("invalid decoder")
        completion(.invalidData)
      }
    }
    task.resume()
  }
  
  func logout(
    completion: @escaping (APIError?) -> ()
  ) {
    let endpoint = baseURL + "users/logout/"
    //let group = DispatchGroup()
    //group.enter()
    
    guard let url = URL(string: endpoint) else {
      print("invalid url")
      completion(.invalidData)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Token: \(token!)", forHTTPHeaderField:"Authorization")
    
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      
      print("logout")
      print(String(decoding: data!, as: UTF8.self))
      
      if let _ = error {
        print("got an error from the server")
        completion(.unableToComplete)
        return
      }

      guard let response = response as? HTTPURLResponse,
        200 == response.statusCode else {
        print("invalid response")
        completion(.invalidResponse)
        return
      }
      
      guard data != nil else {
        print("invalid data")
        completion(.invalidData)
        return
      }
      
      APIManager.currentDriver = nil
      APIManager.shared.token = nil
      completion(nil)
    }
    task.resume()
  }
  
  func getDriverInfo(
    id: Int,
    completion: @escaping driverCompletionHandler
  ) {
    let endpoint = baseURL + "users/drivers/\(id)"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Token: \(token!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      print("driver")
      print(String(decoding: data!, as: UTF8.self))
      
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
  
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(Driver.self, from: data)
        print("decoded")
        print(user)
        completion(.success(user))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  
  func getDesignatedRoutesArray(
    completion: @escaping designatedRoutesCompletionHandler
  ) {
    let endpoint = baseURL + "routes/designated/driver/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Token \(token!)", forHTTPHeaderField: "Authorization")
    request.setValue("\(APIManager.currentDriver!.user.id)", forHTTPHeaderField: "Driver")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in

      print("d_routes")
      print(String(decoding: data!, as: UTF8.self))
      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }
        
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dRoutes = try decoder.decode([DesignatedRoute].self, from: data)
        print(dRoutes)
        completion(.success(dRoutes))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  func getDriversArray(
    completion: @escaping driversCompletionHandler 
  ) {
    let endpoint = baseURL + "users/drivers/"
    
    guard let url = URL(string: endpoint) else {
      completion(.failure(.invalidData))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    //request.setValue("Token \(token!)", forHTTPHeaderField:"Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in

      if let _ = error {
        completion(.failure(.unableToComplete))
        return
      }
        
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        completion(.failure(.invalidResponse))
        return
      }
      
      guard let data = data else {
        completion(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let participants = try decoder.decode([Driver].self, from: data)
        print(participants)
        completion(.success(participants))
      } catch {
        completion(.failure(.invalidData))
      }
    }
    task.resume()
  }
}
