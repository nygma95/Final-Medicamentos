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
    @IBOutlet weak var botonNoUse: UIButton!
    
    var bEdit: Bool!
    var notifica: NSNotification!
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuración"
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveSegue(notificacion : NSNotification) {
        notifica = notificacion
        performSegueWithIdentifier("noti", sender: nil)
        //hayNotificacion = true
        
    }
    
    @IBAction func btGuardarDatos(sender: UIButton) {
        if txtNombreRes.text == "" || txtApellidoRes.text == "" || txtTelefonoRes.text == "" || txtEmailRes.text == "" || txtNombreAM.text == "" || txtApellidoAM.text == ""
        {
            let alert = UIAlertController(title: "Falta información", message: "Por favor, llene todos los campos para continuar", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Entendido", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        else
        {
            
            let nomRes = txtNombreRes.text
            let apRes = txtApellidoRes.text
            let telef = txtTelefonoRes.text
            let em = txtEmailRes.text
            let nomAM = txtNombreAM.text
            let apAM = txtApellidoAM.text
            
            if bEdit!
            {
                print("NO First time NO")
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
                
                resultados![0].nombreResponsable = nomRes!
                resultados![0].apellidoResponsable = apRes!
                resultados![0].nombreUsuario = nomAM!
                resultados![0].apellidoUsuario = apAM!
                resultados![0].email = em!
                resultados![0].telefono = telef!
                
                appDelegate.saveContext()
                
            }
            
            
            if !bEdit
            {
                print("First time")
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
            }
            //
                  navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
}
