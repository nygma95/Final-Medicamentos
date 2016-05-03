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
    var hayNotificacion : Bool = false
    var notiAux: Bool = false
    var notifica : NSNotification!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.moveSegue(_:)), name: "actionOnePressed", object: nil)
        
        if hayNotificacion
        {
            moveSegue(notifica!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "medicamentos"
        {
            if notiAux
            {
                let tabla : TableViewControllerMedicamentos = segue.destinationViewController as! TableViewControllerMedicamentos
                tabla.notifica = notifica
                tabla.bHayNotificacion = true
                
                notiAux = false
            }
        }
        else if (segue.identifier == "configuracion")
        {
            let view : ViewControllerConfiguracion = segue.destinationViewController as! ViewControllerConfiguracion
                bFirst = isAppAlreadyLaunchedOnce()
                view.bEdit = bFirst
        }

     }
    
    func moveSegue(notificacion : NSNotification) {
        notifica = notificacion
        hayNotificacion = false
        notiAux = true
        performSegueWithIdentifier("medicamentos", sender: nil)
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

