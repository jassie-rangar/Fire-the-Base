//
//  ViewController.swift
//  Fire the base
//
//  Created by Jaskirat Singh on 15/04/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: self, action: #selector(handleCompose))
        
        // MARK: If user is not logged in.
        checkIfUserIsLoggedIn()
        
    }
    
    @objc func handleCompose() {
        let newComposeViewController = UsersTableViewController()
        let navController = UINavigationController(rootViewController: newComposeViewController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            // for some reason uid = nil (in this case)
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = Users()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: Users) {
        //self.navigationItem.title = user.name
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let firebaseImageView = UIImageView()
        firebaseImageView.contentMode = .scaleAspectFill
        firebaseImageView.layer.cornerRadius = 20
        firebaseImageView.clipsToBounds = true
        firebaseImageView.translatesAutoresizingMaskIntoConstraints = false
        if let firebaseImageUrl = user.firebseImageUrl {
            firebaseImageView.loadImageUsingCacheWithUrlString(urlString: firebaseImageUrl)
        }
        containerView.addSubview(firebaseImageView)
        // MARK: Setting up constraints of firebaseImageView
        firebaseImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        firebaseImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        firebaseImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        firebaseImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        // MARK: Setting up constraints of nameLabel.
        nameLabel.leftAnchor.constraint(equalTo: firebaseImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: firebaseImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: firebaseImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginViewController()
        loginController.usersController = self
        present(loginController, animated: true, completion: nil)
        
    }

}

