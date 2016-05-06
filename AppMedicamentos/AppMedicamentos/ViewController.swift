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
        
        self.title = "Menú"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.moveSegue(_:)), name: "actionOnePressed", object: nil)
        
        bFirst = isAppAlreadyLaunchedOnce()
        if !bFirst
        {
            // si App corre por primera vez
            performSegueWithIdentifier("configuracion", sender: nil)
        }
        if hayNotificacion
        {
            // si hay notificacion
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
            {//si hay notificacion
                let tabla : TableViewControllerMedicamentos = segue.destinationViewController as! TableViewControllerMedicamentos
                tabla.notifica = notifica
                tabla.bHayNotificacion = true
                
                notiAux = false
            }
        }
        else if (segue.identifier == "configuracion")
        {
            let view : ViewControllerConfiguracion = segue.destinationViewController as! ViewControllerConfiguracion
            view.bEdit = bFirst
            bFirst = true
        }

     }
    
    //maneja notificacion
    func moveSegue(notificacion : NSNotification) {
        notifica = notificacion
        hayNotificacion = false
        notiAux = true
        performSegueWithIdentifier("medicamentos", sender: nil)
    }
    
    @IBAction func unwindConfig(sender : UIStoryboardSegue)
    {
        
    }
    
    // Checa si el App corre por primera vez
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

