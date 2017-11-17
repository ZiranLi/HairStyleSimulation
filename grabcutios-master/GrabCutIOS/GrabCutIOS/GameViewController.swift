//
//  GameViewController.swift
//  GrabCutIOS
//
//  Created by Xiang Zheng on 11/16/17.
//  Copyright © 2017 EunchulJeon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var location = CGPoint(x:0, y:0)
    @IBOutlet weak var Hair: UIImageView!
    
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

}
