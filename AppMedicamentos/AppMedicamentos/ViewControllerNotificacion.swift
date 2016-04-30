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
    
    var tabla : TableViewControllerMedicamentos!
    
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
            var entityDescription = NSEntityDescription.entityForName("HistorialMedicamentos", inManagedObjectContext: contexto)
            
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
            
            entityDescription = NSEntityDescription.entityForName("Medicamento", inManagedObjectContext: contexto)
            
            let request = NSFetchRequest()
            request.entity = entityDescription
            
            //el predicado es la consulta
            let  predicado = NSPredicate(format: "nombre = %@", nomMed!)
            
            //agregar predicado a request
            request.predicate = predicado
            
            var resultados : [Medicamento]?
            
            contexto.performBlockAndWait() {
                do {
                    resultados = try! self.contexto.executeFetchRequest(request) as? [Medicamento]
                }
            }
            
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            print("fecha antes")
            print(medi.hora)
            let nuevo = medi.hora!.dateByAddingTimeInterval(3600*Double(medi.periodo!))
            print("fecha después")
            print(nuevo)
            resultados![0].hora = nuevo
            resultados![0].cantDisp = Int(resultados![0].cantDisp!) - Int(resultados![0].dosis!)
            
            appDelegate.saveContext()
            
            tabla.crearAlarma(medi, alarma: nuevo)
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
