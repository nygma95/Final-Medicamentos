//
//  ViewControllerNotificacion.swift
//  AppMedicamentos
//
//  Created by alumno on 29/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerNotificacion: UIViewController {
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDosis: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblSwitch: UILabel!
    
    var medi: Medicamento!
    var imgFoto: UIImage!
    var tomado: Bool = false
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

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
    
    @IBAction func actGuardar(sender: UIButton) {
        if tomado
        {
            let entityDescription = NSEntityDescription.entityForName("HistorialMedicamentos", inManagedObjectContext: contexto)
            
            let nomMed = medi.nombre
            let dosis = lblDosis.text
            let fecha = NSDate()
            let unidad = medi.tipo
            
            if nomMed == nil || dosis == nil
            {
                return
            }
            
            contexto.performBlockAndWait() {
                let medicamento = HistorialMedicamentos(entity: entityDescription!, insertIntoManagedObjectContext: self.contexto)
                medicamento.nombre = nomMed!
                medicamento.dosis = dosis! + " " + unidad!
                medicamento.fechaHora = fecha
                
            }
            
            //guarda el contexto
            contexto.performBlockAndWait() {
                if self.contexto.hasChanges
                {
                    do {
                        try self.contexto.save()
                        
                    }
                    catch {
                        print("ERROR")
                    }
                }
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNombre.text = medi.nombre
        lblDosis.text = String(Int(medi.dosis!))
        lblTipo.text = medi.tipo
        txtView.text = medi.indicaciones
        imgFoto = UIImage(data: medi.foto!)
        imgView.image = imgFoto
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
