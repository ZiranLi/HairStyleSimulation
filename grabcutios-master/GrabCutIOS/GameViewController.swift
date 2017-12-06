//
//  GameViewController.swift
//  GrabCutIOS
//
//  Created by 苏银竹 on 2017/11/18.
//  Copyright © 2017年 EunchulJeon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class GameViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
    var location = CGPoint(x:0, y:0)
    var ref:DatabaseReference?
    @IBOutlet weak var Hair: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
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
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        Hair.center = CGPoint(x:0,y:0)
        self.scrollView.minimumZoomScale = 0.5//scale
        self.scrollView.maximumZoomScale = 1.5

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
        
        //let result=imageByCombiningImage(firstImage: compressedJPEGImage!,withImage: Hair.image!)
        //UIImageWriteToSavedPhotosAlbum(result, nil, nil, nil)
        let result = screenSnapshot(save: true)
        UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
    }
    
    @IBAction func addPost(_ sender: Any) {
        //TODO: Post the data to firebase
        let result = screenSnapshot(save: true)
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(result!){
            storageRef.putData(uploadData, metadata: nil,completion: {(metadata, error) in
            if error != nil{
                print(error)
                return
            }
            print(metadata)
                if let shareImageUrl = metadata?.downloadURL()?.absoluteString{
                let ref = Database.database().reference(fromURL: "https://ec601-f8695.firebaseio.com/")
                ref.child("ShareToAll").setValue(shareImageUrl);
                }
        })
        }

        
        

        
        //Dismiss the popover
        presentingViewController?.dismiss(animated: true, completion: nil)
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
    func imageByCombiningImage(firstImage: UIImage, withImage secondImage: UIImage) -> UIImage {
        
        let newImageWidth  = max(firstImage.size.width,  secondImage.size.width )
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width : newImageWidth, height: newImageHeight)
        
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        
        let firstImageDrawX  = round((newImageSize.width  - firstImage.size.width  ) / 2)
        let firstImageDrawY  = round((newImageSize.height - firstImage.size.height ) / 2)
        
        //let secondImageDrawX = round((newImageSize.width  - secondImage.size.width ) / 2)
        //let secondImageDrawY = round((newImageSize.height - secondImage.size.height) / 2)
        
        //firstImage .draw(at: CGPoint(x: firstImageDrawX,  y: firstImageDrawY))
        firstImage .draw(at: CGPoint(x: firstImageDrawX,  y: firstImageDrawY))
        secondImage.draw(at: CGPoint(x:Hair.center.x+50,y:Hair.center.y-50))
        //print(newImageWidth,firstImage.size.width,secondImage.size.width)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return image!
    }
    
    
    func screenSnapshot(save: Bool) -> UIImage? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        // which part of screen we want to crop
        let size = CGSize(width:pickedImage.bounds.size.width, height:pickedImage.bounds.size.height+50)
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        print(window.bounds.size)
        print(pickedImage.bounds.size)
        print((pickedImage.image?.size)!)
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        //if save { UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil) }
        
        return image
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//    
        return self.Hair
    }
    
    
}
