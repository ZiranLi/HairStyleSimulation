//
//  ViewController.swift
//  Detector
//
//  Created by Gregg Mojica on 8/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import CoreImage
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var personPic: UIImageView!
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //personPic.image = UIImage(named: "face-1")

        //detect()
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
                })
            }
        }
        
    }
    
    func detect() {
        
        guard let personciImage = CIImage(image: personPic.image!) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = personPic.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            //print("viewSize is \(viewSize)")
            let offsetX = (viewSize.width - ciImageSize.width * scale / 1.05)
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 1.68
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 2
            faceBox.layer.borderColor = UIColor.blue.cgColor
            faceBox.backgroundColor = UIColor.clear
            personPic.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
