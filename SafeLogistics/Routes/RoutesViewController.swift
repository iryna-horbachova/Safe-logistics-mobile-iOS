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
        currentDesignatedRouteView.status = currentDesignatedRoute!.status
        currentDesignatedRouteView.routeTitle = currentDesignatedRoute!.route.title
      }
    }
  }
  
  private var currentDesignatedRouteView = CurrentDesignatedRouteView(status: "F", routeTitle: nil)
  private let tableView = UITableView()
  private let cellIdentifier = "routeTableViewCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Routes"
    view.backgroundColor = .systemBackground
    
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
        }
      case .failure(let error):
        print("error")
        print(error)
      }
    }
    
    currentDesignatedRouteView.checkRouteButton.addTarget(self, action: #selector(showCurrentRouteVC), for: .touchUpInside)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    currentDesignatedRouteView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(currentDesignatedRouteView)
    view.addSubview(tableView)
    
    tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    NSLayoutConstraint.activate(
      [
        currentDesignatedRouteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        currentDesignatedRouteView.heightAnchor.constraint(equalToConstant: 160),
        //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30),
        currentDesignatedRouteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        currentDesignatedRouteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.topAnchor.constraint(equalTo: currentDesignatedRouteView.bottomAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ]
    )
  }
  
  @objc private func showCurrentRouteVC(sender: UIButton!) {
    navigationController?.pushViewController(CurrentRouteViewController(), animated: true)
  }
}

extension RoutesViewController: UITableViewDelegate {
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

