//
//  ViewControllerInformacionMed.swift
//  AppMedicamentos
//
//  Created by alumno on 22/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData


class ViewControllerInformacionMed: UIViewController {
    
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblDosis: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblPeriodo: UILabel!
    @IBOutlet weak var tvIndicaciones: UITextView!
    
    var indice: Int = 0
    var imagen: UIImage!
    
    var tableDelegado : TableViewControllerMedicamentos!
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        {// muestra datos
            self.title = resultados![indice].nombre
            imagen = UIImage(data: resultados![indice].foto!)
            imgFoto.image = imagen
            lblCantidad.text = String(resultados![indice].cantDisp!)
            lblDosis.text = String(resultados![indice].dosis!)
            lblTipo.text = resultados![indice].tipo
            lblPeriodo.text = String(resultados![indice].periodo!) + " horas"
            tvIndicaciones.text = resultados![indice].indicaciones
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view = segue.destinationViewController as! ViewControllerMedicamento
        view.delegadoEditar = tableDelegado
        view.bEditar = true
        view.indice = indice
     }
    
    
}
