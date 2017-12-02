//
//  LoginInViewController.swift
//  GrabCutIOS
//
//  Created by Xiang Zheng on 12/1/17.
//  Copyright © 2017 EunchulJeon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginInViewController: UIViewController {

    
    @IBOutlet weak var signinSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        //Flip the boolean
        isSignIn = !isSignIn
        
        //Check the bool and set the button and labels
        if isSignIn{
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else{
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        //TO DO: Do some form validation on the email and password
        if let email = emailTextField.text, let pass = passwordTextField.text
        {
            //Check if it is sign in or register
            if isSignIn{
                //Sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    
                    //check that user isnt nill
                    if let u = user{
                        //User is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else{
                        //Error: check error and show message
                        
                    }
                })
            }
            else{
                //Register the user with Firebase
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    //Check that user isn't nil
                    if let u = user{
                        //User is found, go to home screen
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                    else{
                        //Error: check error and show message
                    }
                    
                    guard let uid = user?.uid else{
                        return
                    }
                    //Successfully authenticated user
                    
                    let ref = Database.database().reference(fromURL: "https://ec601-f8695.firebaseio.com/")
                    let usersReference = ref.child("users").child(uid)
                    let values = ["email":email,"password":pass]
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        //if err !=nil  {
                        //    print(err)
                        //    return
                        //}
                        print("saved user successfully into Firebase database")
                    })
                    
                })
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
