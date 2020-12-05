import UIKit

class ProfileViewController: UIViewController {

  let nameLabel = UILabel.makeBodyLabel()
  let averageSpeedPerHourLabel = UILabel.makeBodyLabel()
  let carMaxLoadLabel = UILabel.makeBodyLabel()
  let carTypeLabel = UILabel.makeBodyLabel()
  //let currentLocationLabel = UILabel.makeBodyLabel()
  let experienceLabel = UILabel.makeBodyLabel()
  //let healthState = UILabel.makeBodyLabel()
  let licenseTypeLabel = UILabel.makeBodyLabel()
  let payForKmLabel = UILabel.makeBodyLabel()
  
  lazy var labels = [nameLabel, averageSpeedPerHourLabel, carMaxLoadLabel,
                    carTypeLabel, experienceLabel, licenseTypeLabel, payForKmLabel]
  
  let tableView = UITableView()
  
  let cellIdentifier = "userProfileOption"
  let options = ["Check health", "Change language", "Log out"]
  
 // let checkHealthButton = UIButton.makeSecondaryButton(title: "Check health state")
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Profile"
    view.backgroundColor = .systemBackground
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 3
    stackView.distribution = .equalSpacing
    labels.forEach {
      stackView.addArrangedSubview($0)
    }
   // stackView.addArrangedSubview(checkHealthButton)
    
    nameLabel.text = NSLocalizedString(
      "NAME_LABEL",
      value: "Name: \(APIManager.currentDriver!.user.firstName) \(APIManager.currentDriver!.user.lastName)",
      comment: "Name label")
    averageSpeedPerHourLabel.text = NSLocalizedString(
      "AVERAGE_SPEED_LABEL",
      value: "Average speed per hour: \(APIManager.currentDriver!.averageSpeedPerHour)",
      comment: "Average speed label")
    carMaxLoadLabel.text = NSLocalizedString(
      "CAR_MAX_LOAD_LABEL",
      value: "Car max load: \(APIManager.currentDriver!.carMaxLoad)",
      comment: "Car max load label")
    carTypeLabel.text = NSLocalizedString(
      "CAR_TYPE_LABEL",
      value: "Car type: \(APIManager.currentDriver!.carType)",
      comment: "Car type label")
    experienceLabel.text = NSLocalizedString(
      "EXPERIENCE_LABEL",
      value: "Experience: \(APIManager.currentDriver!.experience)",
      comment: "Experience label")
    licenseTypeLabel.text = NSLocalizedString(
      "LICENSE_TYPE_LABEL",
      value: "License type: \(APIManager.currentDriver!.licenseType)",
      comment: "License type label")
    payForKmLabel.text = NSLocalizedString(
      "PAY_FOR_KM_LABEL",
      value: "Pay for km: \(APIManager.currentDriver!.payForKm)",
      comment: "Pay for km label")
    
    view.addSubview(stackView)
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    
    tableView.register(ProfileOptionTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    )
    
  }
}

extension ProfileViewController: UITableViewDelegate {
  /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    20
  }*/
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
      case 2:
        APIManager.shared.logout { [weak self] error in
          guard let self = self else { return }
          if error == nil {
            DispatchQueue.main.async {
              self.present(
                UIAlertController.alertWithOKAction(
                  title: "Success!",
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
        }
    default:
      print("not implemented :)))")
    }
  }
}
