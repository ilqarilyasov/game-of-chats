//
//  LoginController+Handler.swift
//  GameOfChats
//
//  Created by Ilgar Ilyasov on 11/2/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                NSLog("Error authentication")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            // successfully authenticated user
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            guard let image = self.profileImageView.image else { return }
            if let imageData = image.pngData() {
                storageRef.putData(imageData, metadata: nil, completion: { (_, error) in
                    if let error = error {
                        NSLog("Error uploading profile image to Firebase Storage: \(error.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if let error = error {
                            NSLog("Error uploading profile image to Firebase Storage: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let url = url?.absoluteString else { return }
                        let values = ["name": name, "email": email, "profileImageURL": url]
                        self.registerUserIntoDatabase(uid: uid, values: values)
                    })
                })
            }
        }
    }
    
    private func registerUserIntoDatabase(uid: String, values: [String: Any]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                NSLog("Error saving user")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImge = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImge
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
