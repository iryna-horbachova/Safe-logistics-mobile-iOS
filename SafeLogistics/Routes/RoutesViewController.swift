import UIKit

class RoutesViewController: UIViewController {
  
  var designatedRoutes: [DesignatedRoute] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  var currentDesignatedRoute: DesignatedRoute? {
    didSet {
      if currentDesignatedRoute != nil {
        
      }
    }
  }
  
  var currentDesignatedRouteView = UIView()
  let tableView = UITableView()
  let cellIdentifier = "routeTableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Routes"
    
    // API management
    
    APIManager.shared.getDesignatedRoutesArray { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let dRoutes):
        DispatchQueue.main.async {
          self.designatedRoutes = dRoutes
          self.currentDesignatedRoute = self.designatedRoutes.first { $0.status != "F" }
          if self.currentDesignatedRoute != nil {
            self.designatedRoutes.removeAll { $0.status != "F" }
          }
          print("*********************current designated")
          print(self.currentDesignatedRoute)
          print(dRoutes)
        }
      case .failure(let error):
        print("error")
        print(error)
      }
    }

    
    //designatedRoutes.remove(currentDesignatedRoute)
    
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(currentDesignatedRouteView)
    view.addSubview(tableView)
    
    tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    NSLayoutConstraint.activate(
      [
        //currentDesignatedRouteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30),
        //currentDesignatedRouteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        //currentDesignatedRouteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ]
    )
  }
}

extension RoutesViewController: UITableViewDelegate {
  /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    20
  }*/
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    40
  }
}

extension RoutesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    designatedRoutes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RouteTableViewCell
   
    cell.titleLabel.text = designatedRoutes[indexPath.row].route.title
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Completed routes"
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.backgroundColor = .systemBackground
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    header.textLabel?.frame = header.frame
  }
}

