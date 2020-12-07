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
  private let measureHealthButton = UIButton.makeSecondaryButton(title: "Measure health")
  
  lazy var labels = [heartRateLabel, bodyTemperatureLabel, respirationRatePerMinuteLabel,
                     bloodPressureSystolicLabel, bloodPressureDiastolicLabel, bloodOxygenLevelLabel,
                     bloodAlcoholContentLabel, bloodDrugsContentLabel]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    title = "Health state"
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
    heartRateLabel.text = NSLocalizedString(
      "HEART_RATE_LABEL",
      value: "Heart rate: \(healthState.heart_rate)",
      comment: "Heart rate label")
    bodyTemperatureLabel.text = NSLocalizedString(
      "BODY_TEMPERATURE_LABEL",
      value: "Body temperature: \(healthState.bodyTemperature)",
      comment: "Body temperature label")
    respirationRatePerMinuteLabel.text = NSLocalizedString(
      "RESPIRATION_RATE_PER_MINUTE_LABEL",
      value: "Respiration rate per minute: \(healthState.respirationRatePerMinute)",
      comment: "Respiration rate per minute label")
    bloodPressureSystolicLabel.text = NSLocalizedString(
      "BLOOD_PRESSURE_SYSTOLIC_LABEL",
      value: "Blood pressure systolic: \(healthState.bloodPressureSystolic)",
      comment: "Blood pressure systolic label")
    bloodPressureDiastolicLabel.text = NSLocalizedString(
      "BLOOD_PRESSURE_DIASTOLIC_LABEL",
      value: "Blood pressure diastolic: \(healthState.bloodPressureDiastolic)",
      comment: "Blood pressure diastolic label")
    bloodOxygenLevelLabel.text = NSLocalizedString(
      "BLOOD_OXYGEN_LABEL",
      value: "Blood oxygen: \(healthState.bloodOxygenLevel)",
      comment: "Blood oxygen label")
    bloodAlcoholContentLabel.text = NSLocalizedString(
      "BLOOD_ALCOHOL_CONTENT_LABEL",
      value: "Blood alcohol content: \(healthState.bloodAlcoholContent)",
      comment: "Blood alcohol content label")
    bloodDrugsContentLabel.text = NSLocalizedString(
      "BLOOD_DRUGS_CONTENT_LABEL",
      value: "Blood drugs content: \(healthState.bloodDrugsContent)",
      comment: "Blood drugs content label")
  }
  
  @objc private func measureHealthButtonClicked(_ sender: UIButton!) {
    present(
      UIAlertController.alertWithOKAction(
        title: "You measured your health state!",
        message: "The data in your profile has been updated"),
      animated: true,
      completion: nil
    )
  }
}
