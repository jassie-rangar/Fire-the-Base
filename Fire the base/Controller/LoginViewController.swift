//
//  LoginViewController.swift
//  Fire the base
//
//  Created by Jaskirat Singh on 15/04/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var usersController: UsersViewController?
    
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:0.84, green:0.49, blue:0.23, alpha:1.0)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegisteration()
        }
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user: User?, error) in
            if error != nil {
                print(error)
                return
            }
            
            //MARK: Successfully logged in our User.
            self.usersController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeprator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeprator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var firebaseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "if_google_firebase_1175532-2")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectFirebaseImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return segmentedControl
    }()
    
    @objc func handleLoginRegisterChange()
    {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // MARK: Change height of inputContainerView.
        inputContainerHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // MARK: Change height of nameTextField.
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        // MARK: Changing the height of container on toggling between Login and Register.
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.92, green:0.63, blue:0.06, alpha:1.0)
        
        view.addSubview(inputContainer)
        view.addSubview(loginRegisterButton)
        view.addSubview(firebaseImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        // MARK: Setting up constraints of inputContainer.
        setupInputContainer()
        
        // MARK: Setting up constraints of loginRegisterButton.
        setupLoginRegisterButton()
        
        // MARK: Setting up constraints of firebaseImageView.
        setupFirebaseImageView()
        
        // MARK: Setting up constraints of loginRegisterSegmentedControl.
        setupLoginRegisterSegmentedControl()
        
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, multiplier: 0.5).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func setupFirebaseImageView() {
        firebaseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firebaseImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        firebaseImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        firebaseImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var inputContainerHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputContainer() {
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerHeightAnchor = inputContainer.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightAnchor?.isActive = true
        
        inputContainer.addSubview(nameTextField)
        // MARK: Setting up constraints of nameTextField.
        nameTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        inputContainer.addSubview(nameSeprator)
        //MARK: Setting up constraints of nameSeprator.
        nameSeprator.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        nameSeprator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeprator.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        nameSeprator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainer.addSubview(emailTextField)
        // MARK: Setting up constraints of emailTexrField.
        emailTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        inputContainer.addSubview(emailSeprator)
        //MARK: Setting up constraints of emailSeprator.
        emailSeprator.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        emailSeprator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeprator.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        emailSeprator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainer.addSubview(passwordTextField)
        // MARK: Setting up constraints of passwordTextField.
        passwordTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return.lightContent
    }

}
