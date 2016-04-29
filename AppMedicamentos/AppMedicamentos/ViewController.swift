//
//  ViewController.swift
//  AppMedicamentos
//
//  Created by alumno on 04/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bFirst: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

            if (segue.identifier == "configuracion")
            {
                let view : ViewControllerConfiguracion = segue.destinationViewController as! ViewControllerConfiguracion
                bFirst = isAppAlreadyLaunchedOnce()
                view.bEdit = bFirst
            }
     }
    
    @IBAction func unwindConfig(sender : UIStoryboardSegue)
    {
        
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

