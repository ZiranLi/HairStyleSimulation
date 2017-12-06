//
//  TableViewController.swift
//  GrabCutIOS
//
//  Created by Xiang Zheng on 12/5/17.
//  Copyright © 2017 EunchulJeon. All rights reserved.
//

import UIKit

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var name:NSArray=[]
    var imageArr:NSArray=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        name=["HairStyle1","HairStyle2","HairStyle3","HairStyle4","HairStyle5","HairStyle6","HairStyle7","HairStyle8","HairStyle9","HairStyle10"]
        imageArr=[UIImage(named:"1")!, UIImage(named:"2")!, UIImage(named:"3")!, UIImage(named:"4")!, UIImage(named:"5")!, UIImage(named:"6")!, UIImage(named:"7")!, UIImage(named:"8")!, UIImage(named:"9")!, UIImage(named:"10")!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.Hair.image = imageArr[indexPath.row] as? UIImage
        cell.lblName.text! = name[indexPath.row] as! String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Storyboard = UIStoryboard(name:"Main",bundle:nil)
        let DvC = Storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
    
        DvC.getImage = imageArr[indexPath.row] as! UIImage
        self.navigationController?.pushViewController(DvC, animated: true)
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
