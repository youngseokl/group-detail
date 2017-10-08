//
//  UpdateProfileViewController.swift
//  TestAcer
//
//  Created by Charles You on 2017-04-21.
//  Copyright © 2017 Charles You. All rights reserved.
//

import UIKit
import Firebase

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Current User.
    let user = FIRAuth.auth()?.currentUser
    
    // Profile picture.
    @IBOutlet weak var profilePic: UIImageView!
    
    // Name.
    @IBOutlet weak var nameText: UITextField!
    
    // Email.
    @IBOutlet weak var actualEmail: UILabel!
    
    // School.
    @IBOutlet weak var schoolText: UITextField!
    
    // Courses.
    @IBOutlet weak var coursesText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo() { (userInfo) in
            if let userInfo = userInfo {
                self.actualEmail.text = userInfo["Email"] as! String?
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageButtonPressed(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated:true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profilePic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Updates the profile.
    @IBAction func updateProfile(_ sender: UIButton) {
        guard let name = nameText.text else { return }
        guard let schoolText = schoolText.text else { return }
        guard let coursesText = coursesText.text else { return }
        /* Converted UIImage into JPEG Data.
         Need to store this data in the storage and update firebase.
         */
        // changedNow
        let changeRequest = user!.profileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges(completion: {(err) in
            if err == nil {
                addImageToPost(postImage: self.profilePic.image!)
                updatingProf(n: name, s: schoolText, c: coursesText)
                self.performSegue(withIdentifier: "toProfile", sender: self)
            } else {
                print(err!)
            }
        })
        // May need to update the profilepic path and image and not simply create new one
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toProfile" {
                if let dest = segue.destination as? ProfileViewController {
                    dest.profilePic.image = profilePic.image
                }
            }
        }
    }
    
}
