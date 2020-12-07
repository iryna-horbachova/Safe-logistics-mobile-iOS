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
    
    title = NSLocalizedString("Settings", comment: "Settings")
    view.backgroundColor = .systemBackground
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"),
                                                        style: .plain, target: self,
                                                        action: #selector(savePreferences))
    
    languageLabel.text = NSLocalizedString("Language", comment: "Language") 
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
        title: NSLocalizedString("Success", comment: "Success"),
        message: NSLocalizedString("Your information was updated", comment: "Your information was updated")),
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
