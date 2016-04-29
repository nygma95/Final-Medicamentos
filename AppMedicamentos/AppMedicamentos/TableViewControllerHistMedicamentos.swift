//
//  TableViewControllerHistMedicamentos.swift
//  AppMedicamentos
//
//  Created by ArturoNajera on 4/28/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

class TableViewControllerHistMedicamentos: UITableViewController {
    
    
    var listaMedicamentos = [HistorialMedicamentos]()
    var indice: Int = 0
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let fetchRequest = NSFetchRequest(entityName: "HistorialMedicamentos")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations

        let entityDescription = NSEntityDescription.entityForName("HistorialMedicamentos", inManagedObjectContext: contexto)
        
        let request = NSFetchRequest()
        request.entity = entityDescription
        
        //el predicado es la consulta
        let  predicado = NSPredicate(value: true)
        
        //agregar predicado a request
        request.predicate = predicado
        
        var resultados : [HistorialMedicamentos]?
        
        contexto.performBlockAndWait() {
            do {
                resultados = try! self.contexto.executeFetchRequest(request) as? [HistorialMedicamentos]
            }
        }
        
        if resultados?.count > 0
        {
            let iN = resultados?.count
            let iNum = 0
            for med : HistorialMedicamentos in resultados!.reverse(){
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
        cell.detailTextLabel?.text = listaMedicamentos[indexPath.row].dosis
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

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
