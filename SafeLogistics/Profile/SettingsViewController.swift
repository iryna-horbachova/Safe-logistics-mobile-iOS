import UIKit

class SettingsViewController: UIViewController {
  
  var languages = [NSLocalizedString("English", comment: "English"), NSLocalizedString("Українська", comment: "Українська")]
  
  let languageLabel = UILabel.makeTitleLabel()
  let languageTextField = UITextField.makeTextField()
  var languagePickerView: UIPickerView {
    let pickerView = UIPickerView()
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    pickerView.tag = 0
    pickerView.delegate = self
    pickerView.dataSource = self
    return pickerView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Settings"
    view.backgroundColor = .systemBackground
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePreferences))
    
    languageLabel.text = "Language"
    let languagePlaceholderString = NSLocalizedString(
      "LANGUAGE_TEXTFIELD",
      value: "Language",
      comment: "Language textfield")
    languageTextField.attributedPlaceholder = NSAttributedString(
      string: languagePlaceholderString,
      attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme]
    )
    languageTextField.inputView = languagePickerView
    
    let stackView = UIStackView.makeVerticalStackView()
    stackView.spacing = 3
    stackView.distribution = .equalSpacing
    
    stackView.addArrangedSubview(languageLabel)
    stackView.addArrangedSubview(languageTextField)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate(
      [
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PADDING),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PADDING),
      ]
    )
    
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }
  
  @objc private func savePreferences() {
    present(
      UIAlertController.alertWithOKAction(
        title: "Successfully applied preferences!",
        message: "SafeLogistics updated your settings."),
      animated: true,
      completion: nil
    )
  }
  
}

extension SettingsViewController: UIPickerViewDelegate {
  
}

extension SettingsViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    languages.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return languages[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    languageTextField.text = languages[row]
  }
  
}
