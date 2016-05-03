//
//  ViewControllerRegiGlucosa.swift
//  AppMedicamentos
//
//  Created by alumno on 29/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerRegiGlucosa: UIViewController {

    @IBOutlet weak var swOpcion: UISwitch!
    @IBOutlet weak var lbInstruccion: UILabel!
    @IBOutlet weak var lbUnidad: UILabel!
    @IBOutlet weak var lbEjemplo: UILabel!
    @IBOutlet weak var txtCantidad: UITextField!
    
    @IBAction func swSeleccion(sender: UISwitch) {
        
        if sender.on == true
        {
            lbInstruccion.text = "Registrar Glucosa"
            lbUnidad.text = "mg/dl"
            lbEjemplo.text = "Ejemplo: 80 mg/dl"
        }
        else
        {
            lbInstruccion.text = "Registrar Presión"
            lbUnidad.text = "mmHg"
            lbEjemplo.text = "Ejemplo: 120/80 mmHg"
        }
    }
        let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
   
    @IBAction func btRegistrar(sender: UIButton) {
        
        
        let entityDescription = NSEntityDescription.entityForName("HistorialGlucosaPresion", inManagedObjectContext: contexto)
        
        var canti = txtCantidad.text
        let fecha = NSDate()
        var tipoRegistro : String
        if swOpcion.on == false{
            tipoRegistro = "Presión Arterial: "
            canti = canti! + " mmHg"
        }
        else{
            tipoRegistro = "Glucosa: "
            canti = canti! + " mg/dl"
        }
        
        if txtCantidad.text == ""
        {
            let alert = UIAlertController(title: "Falta información", message: "Por favor, llene el campo para continuar", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
        contexto.performBlockAndWait() {
            let cantidad = HistorialGlucosaPresion(entity: entityDescription!, insertIntoManagedObjectContext: self.contexto)
            cantidad.cantidad = canti
            cantidad.fechaHora = fecha
            cantidad.tipoRegistro = tipoRegistro
            
        }
        
        //guarda el contexto
        contexto.performBlockAndWait() {
            if self.contexto.hasChanges
            {
                do {
                    try self.contexto.save()
                    
                }
                catch {
                    self.lbEjemplo.text = "ERROR"
                }
            }
        }
        navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro Glucosa/Presión Arterial"
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerMedicamento.quitaTeclado))
        
        self.view.addGestureRecognizer(tap)
    }
    func quitaTeclado()
    {
        view.endEditing(true)
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
