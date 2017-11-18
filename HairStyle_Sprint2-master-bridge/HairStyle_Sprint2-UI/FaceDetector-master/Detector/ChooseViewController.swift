//
//  ChooseViewController.swift
//  
//
//  Created by Xiang Zheng on 10/27/17.
//

import UIKit

class ChooseViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var pickImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            ;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true,completion: nil)
        }
    }
    
    @IBAction func photoLibraryAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated:true, completion: nil)
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
     let imageData = UIImageJPEGRepresentation(pickImage.image!, 0.6)
        let compressedJPEGImage = UIImage(data:imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        saveNotice()
    }
   
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingImage image:UIImage!,editingInfo:[NSObject: AnyObject]!){
        pickImage.image = image
        self.dismiss(animated:true, completion:nil);
    }
    func saveNotice(){
        let alertController = UIAlertController(title:"Image Saved!", message: "Your picture was successfully saved.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK",style: .default,handler:nil)
        alertController.addAction(defaultAction)
        present(alertController,animated: true, completion:nil)
    }
    
}
