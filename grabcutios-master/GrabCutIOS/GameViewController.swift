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
import CoreImage

class GameViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
    var location = CGPoint(x:0, y:0)
    var ref:DatabaseReference?
    var getname = String()
    var getImage = UIImage()
    @IBOutlet weak var Hair: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var Recommend: UILabel!
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
        
        
        //personPic.image = UIImage(named: "face-1")
        
        //pickedImage.image = UIImage(named: "face-1")  //如果写这句，那么点击了hair之后的下一个环节就一定会出现这幅图，用户没有机会从相册里面选了，但是又一定要给detect face模块一个输入，所以建议改个名字不叫pickedImage.image，比如，这里可以写 detectImage.image = UIImage(image: pickedImage.image!)
        
        //需要给pickedImage赋一个值，然后detect函数才能用得上
        
        Hair.image = getImage


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

        //detect()
    }
    @IBAction func Recommend(_ sender: UIButton){
        detect()
    
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func detect() {
        
        guard let personciImage = CIImage(image: pickedImage.image!) else {
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
            let viewSize = pickedImage.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 2
            faceBox.layer.borderColor = UIColor.yellow.cgColor
            faceBox.backgroundColor = UIColor.clear
            pickedImage.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
            
            print("Mouth position is\(face.mouthPosition)")
            
            
            
            //以下为计算双眼距离和嘴到双眼的距离的比例，从而判断脸型
            let eyesgap = sqrt(pow((face.rightEyePosition.x - face.leftEyePosition.x),2) + pow((face.rightEyePosition.y - face.leftEyePosition.y),2))
            let k = (face.rightEyePosition.y - face.leftEyePosition.y)/(face.rightEyePosition.x - face.leftEyePosition.x)
            let moutheyesgap = ((k * face.mouthPosition.x - face.mouthPosition.y) + (face.leftEyePosition.y - k * face.leftEyePosition.x))/(sqrt(k*k + 1))
            let ratio = eyesgap/moutheyesgap
            
            print("\n")
            print("The gap between two eyes is \(eyesgap)\n")
            print("The gap between mouth and eyes is \(moutheyesgap)\n")
            print("The ratio of eyesgap and moutheyesgap is \(ratio)\n")
            
            
            //区别脸长脸短的阈值需要多实验几次！！
            if ratio > 0.9 { //脸短
                print("According to your face shape, this hair style is suitable for you: HairStyle1 \n")
                self.Recommend.text="The ratio of eyesgap and moutheyesgap is \(ratio)\nAccording to your face shape, this hair style is suitable for you: HairStyle1  "
            }
            
            if ratio < 0.9 { //脸长
                print("According to your face shape, this hair style is suitable for you: HairStyle2 \n")
                self.Recommend.text="The ratio of eyesgap and moutheyesgap is \(ratio)\nAccording to your face shape, this hair style is suitable for you: HairStyle2 "
            }
            
            //print("The ratio ", pow(2,3), sqrt(49), face.rightEyePosition.x - face.leftEyePosition.x, Int(face.rightEyePosition.x - face.leftEyePosition.x) )
            //print("POW iNT", powf(2,3))
            //print("The face width is \(face.bounds.size.width)")
            //print("The face height is \(face.bounds.size.height)")
            
        }
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////

    
    
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
        //print(window.bounds.size)
        //print(pickedImage.bounds.size)
        //print((pickedImage.image?.size)!)
        print("aaaa",pickedImage.image)
        
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
