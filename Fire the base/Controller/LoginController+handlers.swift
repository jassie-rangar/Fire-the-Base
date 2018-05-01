//
//  LoginController+handlers.swift
//  Fire the base
//
//  Created by Jaskirat Singh on 29/04/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegisteration() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            // MARK: Successfully authenticated User.
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("firebase_images").child("\(imageName).jpg")
            
            if let firebaseImage = self.firebaseImageView.image, let uploadData = UIImageJPEGRepresentation(firebaseImage, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let firebaseImageUrl = metadata?.downloadURL()?.absoluteString {
                        let values = ["name" : name, "email" : email, "firebseImageUrl" : firebaseImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String : AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://fire-the-base-b59a1.firebaseio.com/")
        let usersRef = ref.child("users").child(uid)
        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            //self.usersController?.fetchUserAndSetupNavBarTitle()
            //self.usersController?.navigationItem.title = values["name"] as? String
            let user = Users()
            user.setValuesForKeys(values)
            self.usersController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectFirebaseImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editiedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editiedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            firebaseImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
