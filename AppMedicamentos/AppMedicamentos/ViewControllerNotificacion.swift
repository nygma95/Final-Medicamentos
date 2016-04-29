//
//  ViewControllerNotificacion.swift
//  AppMedicamentos
//
//  Created by alumno on 29/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit

class ViewControllerNotificacion: UIViewController {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDosis: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblSwitch: UILabel!
    
    var imgFoto: UIImage!
    var tomado: Bool = false

    @IBAction func actionSwitch(sender: UISwitch) {
        if sender.on
        {
            lblSwitch.text = "Ya lo tomé"
            tomado = true
        }
        else
        {
            lblSwitch.text = "No lo tomé"
            tomado = false
        }
    }
    
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
