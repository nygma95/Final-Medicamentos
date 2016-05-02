//
//  ViewControllerMedicamentosAdicionales.swift
//  AppMedicamentos
//
//  Created by alumno on 21/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData


class ViewControllerMedicamentosAdicionales: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlets
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDosis: UITextField!
    @IBOutlet weak var btGuardar: UIButton!
    @IBOutlet weak var pickerUnidad: UIPickerView!
    
    
    ///////////////Arreglo de Pickers
    var arrUnidades = ["pastillas","ml","mg"]
    var iOpcionUnidades = 0
    //////////////Arreglo de Pickers
    
    @IBAction func guardar(sender: UIButton) {
        
        let entityDescription = NSEntityDescription.entityForName("HistorialMedicamentos", inManagedObjectContext: contexto)
        
        let nomMed = txtNombre.text
        let dosis = txtDosis.text
        let fecha = NSDate()
        let unidad = arrUnidades[iOpcionUnidades]
        
        if nomMed == "" || dosis == ""
        {
            let alert = UIAlertController(title: "Falta información", message: "Por favor, llene todos los campos para continuar", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        else{
        
        contexto.performBlockAndWait() {
            let medicamento = HistorialMedicamentos(entity: entityDescription!, insertIntoManagedObjectContext: self.contexto)
            medicamento.nombre = nomMed!
            medicamento.dosis = dosis! + " " + unidad
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
                    self.txtNombre.text = "ERROR"
                }
            }
        }
      navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerUnidad.delegate = self
        pickerUnidad.dataSource = self
        pickerUnidad.selectRow(0, inComponent: 0, animated: true)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    ////Pickers
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 
            return arrUnidades[row]

    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return arrUnidades.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0)
        {
            iOpcionUnidades = row
        }
    }
    ////////////////////Pickers

    
}
