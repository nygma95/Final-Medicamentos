//
//  TableViewControllerMedicamentos.swift
//  AppMedicamentos
//
//  Created by alumno on 18/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

class TableViewControllerMedicamentos: UITableViewController, ProtocoloAgregarMedicamento, ProtocoloEditarMedicamento {

    var listaMedicamentos = [Medicamento]()
    var indice: Int = 0
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "Medicamento")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Medicamentos Programados"
        
        let entityDescription = NSEntityDescription.entityForName("Medicamento", inManagedObjectContext: contexto)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        //el predicado es la consulta
        let  predicado = NSPredicate(value: true)
        
        //agregar predicado a request
        request.predicate = predicado
        
        var resultados : [Medicamento]?

        contexto.performBlockAndWait() {
            do {
                resultados = try! self.contexto.executeFetchRequest(request) as? [Medicamento]
            }
        }
        
        if resultados?.count > 0
        {
            let iN = resultados?.count
            let iNum = 0
            for med : Medicamento in resultados!{
                listaMedicamentos.append(med)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaMedicamentos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = listaMedicamentos[indexPath.row].nombre
        cell.detailTextLabel?.text = "Cantidad Restante: "+String(listaMedicamentos[indexPath.row].cantDisp!)
        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "muestra"
        {
            let viewM = segue.destinationViewController as! ViewControllerInformacionMed
            let indexPath = tableView.indexPathForSelectedRow
            viewM.indice = indexPath!.row
            viewM.tableDelegado = self
            indice = indexPath!.row
        }
        else
        {
            let view = segue.destinationViewController as! ViewControllerMedicamento
            view.delegadoAgregar = self
            view.bEditar = false
        }
    }
 
    
    // MARK: - Protocolos
    
    func editarMedicamento(nombre: String, cantidadDisp: Int, dosis: Int, periodo: Int, unidad: String, indicaciones: String, horaIni: NSDate, foto: NSData, diaaPartir : String!, porxDias : Int! ) {
        
        // hago el fetch del objeto medicamento
        let entityDescription = NSEntityDescription.entityForName("Medicamento", inManagedObjectContext: contexto)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        //el predicado es la consulta
        let  predicado = NSPredicate(value: true)
        
        //agregar predicado a request
        request.predicate = predicado
        
        var resultados : [Medicamento]?
        
        contexto.performBlockAndWait() {
            do {
                resultados = try! self.contexto.executeFetchRequest(request) as? [Medicamento]
            }
        }
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        resultados![indice].nombre = nombre
        resultados![indice].cantDisp = cantidadDisp
        resultados![indice].dosis = dosis
        resultados![indice].periodo = periodo
        resultados![indice].tipo = unidad
        resultados![indice].indicaciones = indicaciones
        resultados![indice].hora = horaIni
        resultados![indice].foto = foto
        resultados![indice].diaaPartir = diaaPartir
        resultados![indice].porxDias = porxDias
        
        appDelegate.saveContext()
        tableView.reloadData()
    }
    
    func quitaVistaE() {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func agregarMedicamento(nombre: String, cantidadDisp: Int, dosis: Int, periodo: Int, unidad: String, indicaciones: String, horaIni: NSDate, foto: NSData, diaaPartir : String!, porxDias : Int! ) {
        
        let entityDescription = NSEntityDescription.entityForName("Medicamento", inManagedObjectContext: contexto)
        
        var aux: Medicamento!
        
        contexto.performBlockAndWait() {
            var med = Medicamento(entity: entityDescription!, insertIntoManagedObjectContext: self.contexto)
            med.nombre = nombre
            med.cantDisp = cantidadDisp
            med.dosis = dosis
            med.periodo = periodo
            med.tipo = unidad
            med.indicaciones = indicaciones
            med.hora = horaIni
            med.foto = foto
            med.diaaPartir = diaaPartir
            med.porxDias = porxDias
            aux = med
        }
        
        //guarda el contexto
        contexto.performBlockAndWait() {
            if self.contexto.hasChanges
            {
                do {
                    try self.contexto.save()
                    self.listaMedicamentos.append(aux)
                    
                }
                catch {
                    print("Error al guardar : \(error)")
                }
            }
        }
        tableView.reloadData()
        
    }
    
    func quitaVista() {
        navigationController?.popViewControllerAnimated(true)
    }

}
