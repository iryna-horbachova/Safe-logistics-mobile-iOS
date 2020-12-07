import UIKit

class ProfileViewController: UIViewController {

  let nameLabel = UILabel.makeSecondaryLabel()
  let averageSpeedPerHourLabel = UILabel.makeSecondaryLabel()
  let carMaxLoadLabel = UILabel.makeSecondaryLabel()
  let carTypeLabel = UILabel.makeSecondaryLabel()
  let experienceLabel = UILabel.makeSecondaryLabel()
  //let healthState = UILabel.makeBodyLabel()
  let licenseTypeLabel = UILabel.makeSecondaryLabel()
  let payForKmLabel = UILabel.makeSecondaryLabel()
  
  lazy var labels = [nameLabel, averageSpeedPerHourLabel, carMaxLoadLabel,
                    carTypeLabel, experienceLabel, licenseTypeLabel, payForKmLabel]
  
  let tableView = UITableView()
  
  let cellIdentifier = "userProfileOption"
  let options = [ NSLocalizedString("Check health", comment: "Check health"),
                  NSLocalizedString("Settings", comment: "Settings"),
                  NSLocalizedString("Log out", comment: "Log out") ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = NSLocalizedString("Profile", comment: "Profile") 
    view.backgroundColor = .systemBackground
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 3
    stackView.distribution = .equalSpacing
    labels.forEach {
      stackView.addArrangedSubview($0)
    }
    
    nameLabel.text = NSLocalizedString("Name", comment: "Name")
      + ": \(APIManager.currentDriver!.user.firstName) \(APIManager.currentDriver!.user.lastName)"
    averageSpeedPerHourLabel.text = NSLocalizedString("Average speed per hour", comment: "Average speed per hour")
      + ": \(APIManager.currentDriver!.averageSpeedPerHour)"
    carMaxLoadLabel.text = NSLocalizedString("Car max load", comment: "Car max load")
      + ": \(APIManager.currentDriver!.carMaxLoad)"
    carTypeLabel.text = NSLocalizedString("Car type", comment: "Car type")
      + ": \(APIManager.currentDriver!.carType)"
    experienceLabel.text = NSLocalizedString("Experience", comment: "Experience")
      + ": \(APIManager.currentDriver!.experience)"
    licenseTypeLabel.text = NSLocalizedString("License type", comment: "License type")
      + ": \(APIManager.currentDriver!.licenseType)"
    payForKmLabel.text = NSLocalizedString("Pay for km", comment: "Pay for km")
      + ": \(APIManager.currentDriver!.payForKm)"
    
    view.addSubview(stackView)
    view.addSubview(tableView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ProfileOptionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    )
    
  }
}

extension ProfileViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    40
  }
}

extension ProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProfileOptionTableViewCell
   
    cell.titleLabel.text = options[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 0:
      navigationController?.pushViewController(HealthStateViewController(), animated: true)
      break
    case 1:
      navigationController?.pushViewController(SettingsViewController(), animated: true)
      break
    case 2:
      APIManager.shared.logout { [weak self] error in
        guard let self = self else { return }
        if error == nil {
          DispatchQueue.main.async {
            self.present(
              UIAlertController.alertWithOKAction(
                title: NSLocalizedString("Success", comment: "Success"),
                message: "You have logged out!"),
              animated: true,
              completion: nil
            )
          }
        } else {
          DispatchQueue.main.async {
            self.present(
              UIAlertController.alertWithOKAction(
                title: "Unable to log you out!",
                message: "Please try again later"),
              animated: true,
              completion: nil)
            
          }
        }
        DispatchQueue.main.async {
          self.view.window?.rootViewController = SignInViewController()
        }
      }
    default:
      print("not implemented :)))")
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return NSLocalizedString("Options", comment: "Options") 
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.backgroundColor = .systemBackground
    header.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    header.textLabel?.frame = header.frame
  }
}
