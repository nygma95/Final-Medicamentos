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
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField : UITextField?
    
    
    
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
        // Si estan vacios los campos, mostrara una alerta
        if nomMed == "" || dosis == ""
        {
            let alert = UIAlertController(title: "Falta información", message: "Por favor, llene todos los campos para continuar", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
            // Si no estan vacios, guarda los datos en el core data
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
        // Despliega los contenidos del picker que estan en un arreglo
        pickerUnidad.delegate = self
        pickerUnidad.dataSource = self
        pickerUnidad.selectRow(0, inComponent: 0, animated: true)
        
        //Codigo para que se recorra el view por cuestiones del tamaño del teclado
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerMedicamentosAdicionales.quitaTeclado))
        
        self.view.addGestureRecognizer(tap)
        self.registrarseParaNotificacionesDeTeclado()
        
    }
    
    func quitaTeclado()
    {
        view.endEditing(true)
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
    
    ////Pickers, configuracion de los pickers
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
    
    /////// Funciones del teclado
    private func registrarseParaNotificacionesDeTeclado() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewControllerMedicamentosAdicionales.keyboardWasShown(_:)),
                                                         name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewControllerMedicamentosAdicionales.keyboardWillBeHidden(_:)),
                                                         name:UIKeyboardWillHideNotification, object:nil)
    }

    
    func keyboardWasShown (aNotification : NSNotification )
    {
        let kbSize = aNotification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        let contentInset = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        var bkgndRect : CGRect = scrollView.frame
        bkgndRect.size.height += kbSize.height;
        activeField!.superview!.frame = bkgndRect;
        scrollView.setContentOffset(CGPointMake(0.0, self.activeField!.frame.origin.y-kbSize.height), animated: true)
    }
    
    func keyboardWillBeHidden (aNotification : NSNotification)
    {
        let contentInsets : UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    func textFieldDidBeginEditing (textField : UITextField )
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing (textField : UITextField )
    {
        activeField = nil
    }


    
}
