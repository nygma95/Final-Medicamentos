//
//  TableViewControllerHistGlucosaPresion.swift
//  AppMedicamentos
//
//  Created by alumno on 29/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

class TableViewControllerHistGlucosaPresion: UITableViewController {
    // Arreglo Historial Glucosa/presion
    var listaRegistros = [HistorialGlucosaPresion]()
    var indice: Int = 0
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "HistorialGlucosaPresion")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        
        let entityDescription = NSEntityDescription.entityForName("HistorialGlucosaPresion", inManagedObjectContext: contexto)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        //el predicado es la consulta
        let  predicado = NSPredicate(value: true)
        
        //agregar predicado a request
        request.predicate = predicado
        
        var resultados : [HistorialGlucosaPresion]?
        
        contexto.performBlockAndWait() {
            do {
                resultados = try! self.contexto.executeFetchRequest(request) as? [HistorialGlucosaPresion]
            }
        }
        // Querie que extrae los datos para desplegarlos en el tableview
        if resultados?.count > 0
        {
            let iN = resultados?.count
            let iNum = 0
            for med : HistorialGlucosaPresion in resultados!.reverse(){
                listaRegistros.append(med)
                
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
        return listaRegistros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = listaRegistros[indexPath.row].tipoRegistro! + listaRegistros[indexPath.row].cantidad!

        
        let date = listaRegistros[indexPath.row].fechaHora!
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        // Separa fecha y hora para poder concatenar los strings y ponerlos en el tableview
        let year =  String(components.year)
        let month = String(components.month)
        let day = String(components.day)
        let hour = String(components.hour)
        var minute = String(components.minute)
        if Int(minute) < 10{
            minute = "0" + minute
        }
        
        cell.detailTextLabel!.text = day + "/" + month + "/" + year + "   " + hour + ":" + minute
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
