//
//  ViewControllerConfiguracion.swift
//  AppMedicamentos
//
//  Created by alumno on 04/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerConfiguracion: UIViewController {
    
    @IBOutlet weak var txtNombreRes: UITextField!
    @IBOutlet weak var txtApellidoRes: UITextField!
    @IBOutlet weak var txtTelefonoRes: UITextField!
    @IBOutlet weak var txtEmailRes: UITextField!
    @IBOutlet weak var txtNombreAM: UITextField!
    @IBOutlet weak var txtApellidoAM: UITextField!
    @IBOutlet weak var btGuardar: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    var activeField : UITextField?
    
    var bEdit: Bool!// checa si el usuario va a editar
    var notifica: NSNotification!
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerConfiguracion.quitaTeclado))
        
        self.view.addGestureRecognizer(tap)
        
        self.registrarseParaNotificacionesDeTeclado()
        
        if !bEdit
        {// Si es la primera vez que el usuario entra
            navigationController?.setNavigationBarHidden(true, animated: false)
            let alert = UIAlertController(title: "Responsable:", message: "Para comenzar registra tus datos y los del Adulto Mayor. Debes registrar ambos aunque seas la misma persona. Al terminar, presiona \"Guardar\"", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        self.title = "Configuración"

        // Observador de notificaciones
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerMedicamentos.moveSegue(_:)), name: "actionOnePressed", object: nil)
        
        let entityDescription = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: contexto)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        //el predicado es la consulta
        let  predicado = NSPredicate(value: true)
        
        //agregar predicado a request
        request.predicate = predicado
        
        var resultados : [Usuario]?
        
        contexto.performBlockAndWait() {
            do {
                resultados = try! self.contexto.executeFetchRequest(request) as? [Usuario]
            }
        }
        
        //Si existen datos, extrae la información que se encuentra en el subindice 0, no se usarán más aparte de ese subindice
        
        if resultados?.count > 0
        {
            print(resultados!.count)//imprime cuantos usuarios hay guardados, para verificar que sea 1
            let iN = resultados?.count
            txtNombreRes.text = resultados![0].nombreResponsable
            txtNombreAM.text = resultados![0].nombreUsuario
            txtApellidoRes.text = resultados![0].apellidoResponsable
            txtApellidoAM.text = resultados![0].apellidoUsuario
            txtEmailRes.text = resultados![0].email
            txtTelefonoRes.text = resultados![0].telefono
        }
    }

    func quitaTeclado()
    {
        view.endEditing(true)
    }
    
    // Funcion para cuando se utiliza el teclado mande una notificacion de uso
    private func registrarseParaNotificacionesDeTeclado() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewControllerConfiguracion.keyboardWasShown(_:)),
                                                         name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewControllerConfiguracion.keyboardWillBeHidden(_:)),
                                                         name:UIKeyboardWillHideNotification, object:nil)
    }
    // Al hacer uso del teclado, se correra la pantalla hacia arriba para ver lo que se esta escribiendo
    func keyboardWasShown (aNotification : NSNotification )
    {
        if activeField != txtNombreRes && activeField != txtApellidoRes && activeField != txtTelefonoRes && activeField != txtEmailRes{
        let kbSize = aNotification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        let contentInset = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        var bkgndRect : CGRect = scrollView.frame
        bkgndRect.size.height += kbSize.height;
        activeField!.superview!.frame = bkgndRect;
        scrollView.setContentOffset(CGPointMake(0.0, self.activeField!.frame.origin.y-kbSize.height), animated: true)
        }
    }
    // Funcion para tapar el teclado
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


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveSegue(notificacion : NSNotification) {
        notifica = notificacion
        performSegueWithIdentifier("noti", sender: nil)
        //hayNotificacion = true
        
    }
    
    // Accion para guardar los datos
    @IBAction func btGuardarDatos(sender: UIButton) {
        // Si los campos no estan llenos, mostrara una alerta de que debe llenarlos
        if txtNombreRes.text == "" || txtApellidoRes.text == "" || txtTelefonoRes.text == "" || txtEmailRes.text == "" || txtNombreAM.text == "" || txtApellidoAM.text == ""
        {
            //Alerta
            let alert = UIAlertController(title: "Falta información", message: "Por favor, llene todos los campos para continuar", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            // Si no faltan datos, se guardan los datos en el core data
        else
        {
            
            let nomRes = txtNombreRes.text
            let apRes = txtApellidoRes.text
            let telef = txtTelefonoRes.text
            let em = txtEmailRes.text
            let nomAM = txtNombreAM.text
            let apAM = txtApellidoAM.text
            
            if bEdit!
            {// si noe es primera vez
                // hago el fetch del objeto usuario
                let entityDescription = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: contexto)
                
                let request = NSFetchRequest()
                request.entity = entityDescription
                
                //el predicado es la consulta
                let  predicado = NSPredicate(value: true)
                
                //agregar predicado a request
                request.predicate = predicado
                
                var resultados : [Usuario]?
                
                contexto.performBlockAndWait() {
                    do {
                        resultados = try! self.contexto.executeFetchRequest(request) as? [Usuario]
                    }
                }
                
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                // asigno datos
                resultados![0].nombreResponsable = nomRes!
                resultados![0].apellidoResponsable = apRes!
                resultados![0].nombreUsuario = nomAM!
                resultados![0].apellidoUsuario = apAM!
                resultados![0].email = em!
                resultados![0].telefono = telef!
                // Guardar datos
                appDelegate.saveContext()
                
            }
            
            
            if !bEdit
            {// Sies primera vez
                let entityDescription = NSEntityDescription.entityForName("Usuario", inManagedObjectContext: contexto)
                
                if nomRes == nil || nomAM == nil || apRes == nil
                {
                    return
                }
                
                contexto.performBlockAndWait() {
                    let usuario = Usuario(entity: entityDescription!, insertIntoManagedObjectContext: self.contexto)
                    usuario.nombreResponsable = nomRes!
                    usuario.nombreUsuario = nomAM!
                    usuario.apellidoResponsable = apRes!
                    usuario.apellidoUsuario = apAM!
                    usuario.email = em!
                    usuario.telefono = telef!
                }
                
                //guarda el contexto
                contexto.performBlockAndWait() {
                    if self.contexto.hasChanges
                    {
                        do {
                            try self.contexto.save()
                            self.bEdit = true
                        }
                        catch {
                            self.txtNombreRes.text = "ERROR"
                        }
                    }
                }
                bEdit = true
                navigationController?.setNavigationBarHidden(false, animated: false)
            }
            // Fin del if
                  navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
}
