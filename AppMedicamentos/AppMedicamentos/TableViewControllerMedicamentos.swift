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
    var aux: Medicamento!
    var bHayNotificacion: Bool = false
    var notifica : NSNotification!
    var indice: Int = 0
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let app: UIApplication = UIApplication.sharedApplication().self
    
    let fetchRequest = NSFetchRequest(entityName: "Medicamento")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TableViewControllerMedicamentos.moveSegue(_:)), name: "actionOnePressed", object: nil)
        
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
        // Si llega notificacion desde otro ViewController
        if bHayNotificacion
        {
            moveSegue(notifica!)
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
 
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "muestra"
        {// pantalla para ver un Medicamento
            let viewM = segue.destinationViewController as! ViewControllerInformacionMed
            let indexPath = tableView.indexPathForSelectedRow
            viewM.indice = indexPath!.row
            viewM.tableDelegado = self
            indice = indexPath!.row
        }
        else if segue.identifier == "alarma"
        {// pantalla para registrar Toma de Medicamento
            let viewA = segue.destinationViewController as! ViewControllerNotificacion
            viewA.medi = aux
            viewA.tabla = self
            bHayNotificacion = false
        }
        else
        {// pantalla para agregar medicamento
            let view = segue.destinationViewController as! ViewControllerMedicamento
            view.delegadoAgregar = self
            view.bEditar = false
        }
    }
 
    
    // MARK: - Protocolos
    
    // Guarda datos de Medicamento editado
    func editarMedicamento(nombre: String, cantidadDisp: Int, dosis: Int, periodo: Int, unidad: String, indicaciones: String, horaIni: NSDate, foto: NSData, diaaPartir : String!, porxDias : Int!, limite : NSDate) {
        
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
        resultados![indice].limite = limite
        
        appDelegate.saveContext()
        tableView.reloadData()
    }
    
    func quitaVistaE() {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.popViewControllerAnimated(true)
    }
    
    // Guarda nuevo Medicamento
    func agregarMedicamento(nombre: String, cantidadDisp: Int, dosis: Int, periodo: Int, unidad: String, indicaciones: String, horaIni: NSDate, foto: NSData, diaaPartir : String!, porxDias : Int!, limite : NSDate) {
        
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
            med.limite = limite
            aux = med
        }
        
        //guarda el contexto
        contexto.performBlockAndWait() {
            if self.contexto.hasChanges
            {
                do {
                    try self.contexto.save()
                    self.listaMedicamentos.append(aux)
                    self.crearAlarma(aux, alarma: aux.hora!)
                    
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
   
    
    // Notificaciones
    
    // Crea y programa Notificacion
    func crearAlarma(medicina: Medicamento, alarma: NSDate)
    {
        let notification : UILocalNotification = UILocalNotification()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = "First_Cat"
        notification.alertBody = "Hora de tomar " + medicina.nombre!
        notification.fireDate = alarma
        notification.repeatInterval = NSCalendarUnit.Minute
        notification.userInfo = ["nombre": medicina.nombre!]
        app.scheduleLocalNotification(notification)
        let acutal = NSDate()
        let elapsedTime = notification.fireDate?.timeIntervalSinceDate(acutal)
        let duration = Double(elapsedTime!)
        let timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(TableViewControllerMedicamentos.iniciaTimer(_:)), userInfo: notification.userInfo, repeats: false)
        //print("Se creo una alarma")
        //print(notification.description)
    }
    
    // Maneja una notificacion
    func moveSegue(notification : NSNotification) {
        bHayNotificacion = false
        //let player: Medicamento!
        for player in listaMedicamentos
        {
            print("entro al FOR del handler")
            let z:  [NSObject: AnyObject] = notification.userInfo!
            let x = z as NSDictionary
            let y = x["nombre"] as! String
            //print (x)
            //if notification.userInfo!["nombre"]! as! String == player.nombre
            if y == player.nombre
            {
                print("entro al if")
                aux = player
            }
        }
        self.performSegueWithIdentifier("alarma", sender: nil)
    }
    
    // Timer repeticiones de una Notificacion
    func iniciaTimer(timer: NSTimer) {
        print("inicio cuenta limite")
        let timer = NSTimer.scheduledTimerWithTimeInterval(400, target: self, selector: #selector(TableViewControllerMedicamentos.pararNotificacion(_:)), userInfo: timer.userInfo, repeats: false)
    }
    
    // Borra una Notificacion
    func pararNotificacion(timer: NSTimer) {
        print("Stop")
        let a = timer.userInfo! as! [NSObject : AnyObject]
        let b = a as NSDictionary
        let c = b["nombre"] as! String
        let notificaciones = UIApplication.sharedApplication().scheduledLocalNotifications
        for noti in notificaciones!
        {
            let z:  [NSObject: AnyObject] = noti.userInfo!
            let x = z as NSDictionary
            let y = x["nombre"] as! String
            if y == c
            {
                UIApplication.sharedApplication().cancelLocalNotification(noti)
                print("Stoped Stoped")
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let entityDescription2 = NSEntityDescription.entityForName("Medicamento", inManagedObjectContext: contexto)
                
                let request = NSFetchRequest()
                request.entity = entityDescription2
                
                //el predicado es la consulta
                let  predicado = NSPredicate(format: "nombre = %@", y)
                
                //agregar predicado a request
                request.predicate = predicado
                
                var resultados : [Medicamento]?
                
                contexto.performBlockAndWait() {
                    do {
                        resultados = try! self.contexto.executeFetchRequest(request) as? [Medicamento]
                    }
                }
                
                print("fecha antes")
                print(resultados![0].hora)
                let nuevo = resultados![0].hora!.dateByAddingTimeInterval(3600*Double(resultados![0].periodo!))
                resultados![0].hora = nuevo
                appDelegate.saveContext()
                crearAlarma(resultados![0], alarma: nuevo)
                break
            }
        }
    }
    
    // Actualiza datos luego de registrar toma de medicamento
    @IBAction func unwindAlarma(sender : UIStoryboardSegue)
    {
        tableView.reloadData()
    }

    
}
