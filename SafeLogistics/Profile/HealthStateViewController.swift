import UIKit

class HealthStateViewController: UIViewController {
  
  private var healthState = HealthState(heart_rate: 89, bodyTemperature: 36.7,
                                respirationRatePerMinute: 15, bloodPressureSystolic: 120,
                                bloodPressureDiastolic: 80, bloodOxygenLevel: 97,
                                bloodAlcoholContent: 0, bloodDrugsContent: 0, datetime: nil) {
    didSet {
      setHealthStateLabel()
    }
  }
  
  private let heartRateLabel = UILabel.makeSecondaryLabel()
  private let bodyTemperatureLabel = UILabel.makeSecondaryLabel()
  private let respirationRatePerMinuteLabel = UILabel.makeSecondaryLabel()
  private let bloodPressureSystolicLabel = UILabel.makeSecondaryLabel()
  private let bloodPressureDiastolicLabel = UILabel.makeSecondaryLabel()
  private let bloodOxygenLevelLabel = UILabel.makeSecondaryLabel()
  private let bloodAlcoholContentLabel = UILabel.makeSecondaryLabel()
  private let bloodDrugsContentLabel = UILabel.makeSecondaryLabel()
  private let measureHealthButton = UIButton.makeSecondaryButton(title: NSLocalizedString("Measure health state",
                                                                                          comment: "Measure health"))
  
  lazy var labels = [heartRateLabel, bodyTemperatureLabel, respirationRatePerMinuteLabel,
                     bloodPressureSystolicLabel, bloodPressureDiastolicLabel, bloodOxygenLevelLabel,
                     bloodAlcoholContentLabel, bloodDrugsContentLabel]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    title = NSLocalizedString("Health state", comment: "Health state")
    setHealthStateLabel()
    measureHealthButton.addTarget(self, action: #selector(measureHealthButtonClicked), for: .touchUpInside)
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 3
    stackView.distribution = .equalSpacing
    labels.forEach {
      stackView.addArrangedSubview($0)
    }
    stackView.addArrangedSubview(measureHealthButton)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
      ]
    )

  }
  
  private func setHealthStateLabel() {
    heartRateLabel.text = NSLocalizedString("Heart rate", comment: "Heart rate")
      + " \(healthState.heart_rate)"
    bodyTemperatureLabel.text = NSLocalizedString("Body temperature", comment: "Body temperature")
      + ": \(healthState.bodyTemperature)"
    respirationRatePerMinuteLabel.text = NSLocalizedString("Respiration rate per minute", comment: "Respiration rate per minute")
      + ": \(healthState.respirationRatePerMinute)"
    bloodPressureSystolicLabel.text = NSLocalizedString("Blood pressure systolic", comment: "Blood pressure systolic")
      + ": \(healthState.bloodPressureSystolic)"
    bloodPressureDiastolicLabel.text = NSLocalizedString("Blood pressure diastolic", comment: "Blood pressure diastolic")
      + ": \(healthState.bloodPressureDiastolic)"
    bloodOxygenLevelLabel.text = NSLocalizedString("Blood oxygen", comment: "Blood oxygen")
      + ": \(healthState.bloodOxygenLevel)"
    bloodAlcoholContentLabel.text = NSLocalizedString("Blood alcohol content", comment: "Blood alcohol content")
      + ": \(healthState.bloodAlcoholContent)"
    bloodDrugsContentLabel.text = NSLocalizedString("Blood drugs content", comment: "Blood drugs content")
      + ": \(healthState.bloodDrugsContent)"
  }
  
  @objc private func measureHealthButtonClicked(_ sender: UIButton!) {
    present(
      UIAlertController.alertWithOKAction(
        title: NSLocalizedString("You measured your health state!",
                                 comment: "You measured your health state!"),
        message: NSLocalizedString("Your information was updated",
                                   comment: "Your information was updated")),
      animated: true,
      completion: nil
    )
  }
}
