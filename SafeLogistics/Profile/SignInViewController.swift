import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
  
  let logoLabel = makeLogoLabel()
  
  let emailTextField = UITextField.makeTextField()
  let passwordTextField = UITextField.makeTextField()

  let continueButton = UIButton.makeContinueButton()
  private let forgotPasswordButton = makeForgotPasswordButton()
  
  let textFieldStackView = UIStackView.makeVerticalStackView()
  private let buttonStackView = UIStackView.makeVerticalStackView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(logoLabel)
    
    emailTextField.delegate = self
    emailTextField.keyboardType = .emailAddress
    emailTextField.autocapitalizationType = .none
    let emailPlaceholderString = NSLocalizedString(
      "EMAIL_TEXTFIELD",
      value: "Email",
      comment: "Email textfield")
    emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    
    passwordTextField.delegate = self
    passwordTextField.isSecureTextEntry = true
    let passwordPlaceholderString = NSLocalizedString(
      "PASSWORD_TEXTFIELD",
      value: "Password",
      comment: "Password textfield")
    passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderString, attributes:[NSAttributedString.Key.foregroundColor: UIColor.mainTheme])
    passwordTextField.autocapitalizationType = .none
    
    textFieldStackView.spacing = 17
    
    textFieldStackView.addArrangedSubview(emailTextField)
    textFieldStackView.addArrangedSubview(passwordTextField)
    view.addSubview(textFieldStackView)
    
    buttonStackView.addArrangedSubview(continueButton)
    buttonStackView.addArrangedSubview(forgotPasswordButton)
    view.addSubview(buttonStackView)
    
    passwordTextField.returnKeyType = .done
    continueButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    
    NSLayoutConstraint.activate(
      [
        logoLabel.topAnchor.constraint(equalTo:
          view.safeAreaLayoutGuide.topAnchor, constant: 100),
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        textFieldStackView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 30),
        textFieldStackView.leadingAnchor.constraint(equalTo:
          view.leadingAnchor, constant: PADDING),
        textFieldStackView.trailingAnchor.constraint(equalTo:
          view.trailingAnchor, constant: -PADDING),

        buttonStackView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 20),
        buttonStackView.leadingAnchor.constraint(equalTo:
          view.leadingAnchor, constant: PADDING),
        buttonStackView.trailingAnchor.constraint(equalTo:
          view.trailingAnchor, constant: -PADDING),
      ])
  }
    
  static func makeLogoLabel() -> UILabel {
    let label = UILabel()
    label.text = NSLocalizedString(
      "LOGO_LABEL",
      value: "SafeLogistics",
      comment: "Main title showing App Logo")
    
    label.font = .boldSystemFont(ofSize: 50)
    label.textColor = .mainTheme
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }
  
  private static func makeForgotPasswordButton() -> UIButton {
    let button = UIButton()
    let text = NSLocalizedString(
      "FORGOT_PASSWORD",
      value: "Forgot password?",
      comment: "Forgot password button")
    button.setTitle(text, for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }
  
  @objc private func signIn(sender: UIButton!) {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    
    APIManager.shared.login(email: email, password: password) { error in
      if let error = error {
        DispatchQueue.main.async {
          self.present(UIAlertController.alertWithOKAction(
                        title: "Error occured!",
                        message: error.rawValue),
                       animated: true,
                       completion: nil)
          }
      } else {
        print("without error")
        DispatchQueue.main.async { [weak self] in
          self?.authenticateUser()
        }
      }

    }
  }
  
  func authenticateUser() {
    // - TODO: add authentication with server
    print("authenticating")
    view.window?.rootViewController = TabBarController()
    view.window?.makeKeyAndVisible()
  }
  
  // - MARK: UITextFieldDelegate
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.placeholder = nil
  }
}
