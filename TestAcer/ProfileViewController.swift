//
//  ProfileViewController.swift
//  TestAcer
//
//  Created by Charles You on 2017-04-20.
//  Copyright © 2017 Charles You. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // Current User.
    let user = FIRAuth.auth()?.currentUser
    
    // Database reference.
    let dbRef = FIRDatabase.database().reference()
    
    // Key value of the node that represents the user.
    
    // Profile picture.
    @IBOutlet weak var profilePic: UIImageView!
    
    // Name.
    @IBOutlet weak var nameText: UILabel!
    
    // Email.
    @IBOutlet weak var emailText: UILabel!
    
    // School.
    @IBOutlet weak var schoolText: UILabel!
    
    // Courses.
    @IBOutlet weak var coursesText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo() { (userInfo) in
            if let userInfo = userInfo {
                self.nameText.text = userInfo["Username"] as! String?
                self.emailText.text = userInfo["Email"] as! String?
                self.schoolText.text = userInfo["School"] as! String?
                self.coursesText.text = userInfo["Courses"] as! String?
                let profPic = userInfo["ProfileImage"] as! String
                if profPic != "" {
                    getDataFromPath(path: profPic, completion: { (data) in
                        if let data = data {
                            if let image = UIImage(data: data) {
                                self.profilePic.image = image
                            }
                        }
                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Switches to updateProfile view controller.
    @IBAction func updateProfile(_ sender: UIButton) {
        performSegue(withIdentifier: "updateProfile", sender: self)
    }
    
    // Signing out
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "logOut", sender: self)
        } catch {
            print("Error while signing out!")
        }
    }
    
    @IBAction func unwindToProfile(storyBoard: UIStoryboardSegue) {
    }

}
