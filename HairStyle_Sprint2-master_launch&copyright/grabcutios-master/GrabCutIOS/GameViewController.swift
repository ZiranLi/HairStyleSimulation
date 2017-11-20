//
//  GameViewController.swift
//  GrabCutIOS
//
//  Created by 苏银竹 on 2017/11/18.
//  Copyright © 2017年 EunchulJeon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var location = CGPoint(x:0, y:0)
    @IBOutlet weak var Hair: UIImageView!
    //@IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var pickedImage: UIImageView!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var touch : UITouch! = touches.anyObject() as UITouch
        let touch = touches.first as! UITouch
        location = touch.location(in: self.view)
        Hair.center = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var touch : UITouch! = touches.anyObject() as UITouch
        let touch = touches.first as! UITouch
        location = touch.location(in: self.view)
        
        Hair.center = location
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Hair.center = CGPoint(x:160,y:330)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func photoLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated:true, completion: nil)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(pickedImage.image!, 0.6)
        let compressedJPEGImage = UIImage(data:imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
    }
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image:UIImage!,editingInfo:[NSObject:AnyObject]!) {
        pickedImage.image = image
        self.dismiss(animated:true,completion:nil)
    }*/
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingImage image:UIImage!,editingInfo:[NSObject: AnyObject]!){
        pickedImage.image = image
        self.dismiss(animated:true, completion:nil);
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }

    
    
    
}
