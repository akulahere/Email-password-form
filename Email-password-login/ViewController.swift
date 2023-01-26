//
//  ViewController.swift
//  Email-password-login
//
//  Created by Dmytro Akulinin on 26.01.2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
  private let label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.text = "Log In"
    label.font = .systemFont(ofSize: 24, weight: .semibold)
    return label
  }()
  
  private let emailField: UITextField = {
    let emailField = UITextField()
    emailField.placeholder = "Email address"
    emailField.layer.borderWidth = 1
    emailField.layer.borderColor = UIColor.black.cgColor
    emailField.backgroundColor = .white
    emailField.leftViewMode = .always
    emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
   
    return emailField
  }()
  
  private let passwordField: UITextField = {
    let passwordField = UITextField()
    passwordField.placeholder = "Password"
    passwordField.layer.borderWidth = 1
    passwordField.layer.borderColor = UIColor.black.cgColor
    passwordField.isSecureTextEntry = true
    passwordField.backgroundColor = .white
    passwordField.leftViewMode = .always
    passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))

    return passwordField
  }()
  
  private let loginButton: UIButton = {
    let loginButton = UIButton()
    loginButton.backgroundColor = .systemGreen
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.setTitle("Continue", for: .normal)
    return loginButton
  }()
  
  private let logOutButton: UIButton = {
    let loginButton = UIButton()
    loginButton.backgroundColor = .systemGreen
    loginButton.setTitleColor(.white, for: .normal)
    loginButton.setTitle("Log Out", for: .normal)
    return loginButton
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(label)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(loginButton)
    view.backgroundColor = .systemPurple
    loginButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    
    if FirebaseAuth.Auth.auth().currentUser != nil {
      label.isHidden = true
      passwordField.isHidden = true
      emailField.isHidden = true
      loginButton.isHidden = true
      view.addSubview(logOutButton)
      logOutButton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 52)
      
      logOutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
      
      
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
    
    emailField.frame = CGRect(x: 20,
                              y: label.frame.origin.y + label.frame.size.height + 10,
                              width: view.frame.size.width - 40,
                              height: 50)
    
    passwordField.frame = CGRect(x: 20,
                                 y: emailField.frame.origin.y + emailField.frame.size.height + 10,
                                 width: view.frame.size.width - 40,
                                 height: 50)
    loginButton.frame = CGRect(x: 20,
                               y: passwordField.frame.origin.y + passwordField.frame.size.height + 30,
                               width: view.frame.size.width - 40,
                               height: 50)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if FirebaseAuth.Auth.auth().currentUser == nil {
      emailField.becomeFirstResponder()
    }
    emailField.becomeFirstResponder()
  }
  
  @objc private func didTapButton() {
    print("test")
    guard let email = emailField.text,
          !email.isEmpty,
          let password = passwordField.text,
          !password.isEmpty else {
      print("missing data")
      return
    }

    
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] result, error in
      
      if error != nil {
        self?.showCreateAccount(email: email, password: password)
        return
      }
      print("You have signed in")
      self?.label.isHidden = true
      self?.emailField.isHidden = true
      self?.passwordField.isHidden = true
      self?.loginButton.isHidden = true
      
      self?.emailField.resignFirstResponder()
      self?.passwordField.resignFirstResponder()
    }
    
  }
  
  @objc private func logOutButtonTapped() {
    do {
      try FirebaseAuth.Auth.auth().signOut()
      label.isHidden = false
      passwordField.isHidden = false
      emailField.isHidden = false
      loginButton.isHidden = false
      
      logOutButton.removeFromSuperview()
    }
    catch {
      print("An error occured")
    }
  }
  
  func showCreateAccount(email: String , password: String) {
    let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
      FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
        if error != nil {
          print("Account creation failed")
          return
        }
        print("You have signed in")
        self?.label.isHidden = true
        self?.emailField.isHidden = true
        self?.passwordField.isHidden = true
        self?.loginButton.isHidden = true
        self?.emailField.resignFirstResponder()
        self?.passwordField.resignFirstResponder()

      }
    }))
    
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }


}

