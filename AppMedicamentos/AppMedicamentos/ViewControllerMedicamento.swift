//
//  ViewControllerMedicamento.swift
//  AppMedicamentos
//
//  Created by alumno on 05/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//

import UIKit
import CoreData

protocol ProtocoloAgregarMedicamento {
    func agregarMedicamento(nombre : String, cantidadDisp : Int, dosis : Int, periodo : Int, unidad : String , indicaciones : String, horaIni : NSDate, foto: NSData, diaaPartir : String!, porxDias : Int!) -> Void
    func quitaVista() -> Void
}

protocol ProtocoloEditarMedicamento {
    func editarMedicamento(nombre : String, cantidadDisp : Int, dosis : Int, periodo : Int, unidad : String , indicaciones : String, horaIni : NSDate, foto: NSData) -> Void
    func quitaVistaE() -> Void
}

class ViewControllerMedicamento: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imgMedicamento: UIImageView!
    @IBOutlet weak var txtNombreMed: UITextField!
    @IBOutlet weak var txtCant: UITextField!
    @IBOutlet weak var txtDosis: UITextField!
    @IBOutlet weak var lbUnidadCant: UILabel!
    @IBOutlet weak var txtvIndicaciones: UITextView!
    @IBOutlet weak var swDiaPartir: UISwitch!
    @IBOutlet weak var lbDiaPartir: UILabel!
    
    // Switch que cambia el dia apartir (hoy o mañana)
    @IBAction func cambiarDia(sender: UISwitch) {
        
        if sender.on{
            lbDiaPartir.text = "Mañana"
        }
        else{
            lbDiaPartir.text = "Hoy"
        }
    }
    
    var imgFoto: UIImage!
    var bEditar: Bool!
    var indice: Int!
    
    // Protocolos
    var delegadoAgregar : ProtocoloAgregarMedicamento?
    var delegadoEditar : ProtocoloEditarMedicamento?
    
    let contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
///////////////Arreglo de Pickers
    @IBOutlet weak var pickerUnidad: UIPickerView!
    var arrUnidades = ["pastillas","ml","mg"]
    var iOpcionUnidades = 0
    
    @IBOutlet weak var pickerHoras: UIPickerView!
    var arrHoras = ["Cada 4 horas","Cada 6 horas", "Cada 8 horas","Cada 12 horas" ,"Cada 24 horas","Cada 48 horas"]
    var iOpcionHoras = 0
    
    @IBOutlet weak var pickerDias: UIPickerView!
    var arrDias = ["7 días","14 días","21 días","28 días","siempre"]
    var iOpcionDias = 0
    
//////////////////////////////////////////////
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vieView: UIView!
    var activeField : UITextField?
    
    @IBOutlet weak var pickHora: UIDatePicker!
    
    
/////////////Guardar
    
    @IBAction func btnGuardar(sender: UIButton) {
        
        if bEditar!
        {
            let nom = txtNombreMed.text
            let cDisp = Int(txtCant.text!)
            let dosis = Int(txtDosis.text!)
            let per : Int
            switch iOpcionHoras
            {
            case 0 : per = 4
            case 1 : per = 6
            case 2 : per = 8
            case 3 : per = 12
            case 4 : per = 24
            case 5 : per = 48
            default : per = 4
            }
            let tipo : String
            switch iOpcionUnidades
            {
            case 0 : tipo = "pastillas"
            case 1 : tipo = "ml"
            case 2 : tipo = "mg"
            default : tipo = "pastillas"
            }
            let porxdias : Int
            switch iOpcionDias
            {
            case 0 : porxdias = 7
            case 1 : porxdias = 14
            case 2 : porxdias = 21
            case 3 : porxdias = 28
            case 4 : porxdias = 2147483647  //Por siempre
            default : porxdias = 7
            }
            let diaapartir = lbDiaPartir.text
            let indi = txtvIndicaciones.text
            let hora = pickHora.date
            let dataFoto: NSData = UIImagePNGRepresentation(imgFoto)!
            
            delegadoEditar!.editarMedicamento(nom!, cantidadDisp: cDisp!, dosis: dosis!, periodo: per, unidad: tipo, indicaciones: indi!, horaIni: hora, foto: dataFoto)
            delegadoEditar?.quitaVistaE()
        }
        else if bEditar == false
        {
            let nom = txtNombreMed.text
            let cDisp = Int(txtCant.text!)
            let dosis = Int(txtDosis.text!)
            let per : Int
            switch iOpcionHoras
            {
            case 0 : per = 4
            case 1 : per = 6
            case 2 : per = 8
            case 3 : per = 12
            case 4 : per = 24
            case 5 : per = 48
            default : per = 4
            }
            let tipo : String
            switch iOpcionUnidades
            {
            case 0 : tipo = "pastillas"
            case 1 : tipo = "ml"
            case 2 : tipo = "mg"
            default : tipo = "pastillas"
            }
            let porxdias : Int
            switch iOpcionDias
            {
            case 0 : porxdias = 7
            case 1 : porxdias = 14
            case 2 : porxdias = 21
            case 3 : porxdias = 28
            case 4 : porxdias = 2147483647  //Por siempre
            default : porxdias = 7
            }
            let diaapartir = lbDiaPartir.text
            let indi = txtvIndicaciones.text
            let hora = pickHora.date
            let dataFoto: NSData = UIImagePNGRepresentation(imgFoto)!
            
            delegadoAgregar!.agregarMedicamento(nom!, cantidadDisp: cDisp!, dosis: dosis!, periodo: per, unidad: tipo, indicaciones: indi!, horaIni: hora, foto: dataFoto, diaaPartir: diaapartir!, porxDias: porxdias)
            delegadoAgregar?.quitaVista()
        }
    }
    
////////////termina guardar
    
    
    
////////Seleccionar imagen
    @IBAction func selectImage(sender: AnyObject) {
        
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imgFoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgMedicamento.image = imgFoto
        self.dismissViewControllerAnimated(false, completion: nil)
    }
//////////Termina Seleccion de imagen
    
    
    // MARK: - ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerUnidad.delegate = self
        pickerUnidad.dataSource = self
        pickerUnidad.selectRow(0, inComponent: 0, animated: true)
        pickerHoras.delegate = self
        pickerHoras.dataSource = self
        pickerHoras.selectRow(0, inComponent: 0, animated: true)
        pickerDias.delegate = self
        pickerDias.dataSource = self
        pickerDias.selectRow(0, inComponent: 0, animated: true)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewControllerMedicamento.quitaTeclado))
        
        self.view.addGestureRecognizer(tap)
        
        //self.registrarseParaNotificacionesDeTeclado()
        
        scrollView.contentSize = vieView.frame.size
        
        if indice != nil
        {
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
                txtNombreMed.text = resultados![indice].nombre
                imgFoto = UIImage(data: resultados![indice].foto!)
                imgMedicamento.image = imgFoto
                txtCant.text = String(resultados![indice].cantDisp!)
                txtDosis.text = String(resultados![indice].dosis!)
                lbUnidadCant.text = resultados![indice].tipo
                txtvIndicaciones.text = resultados![indice].indicaciones
                
                let horas = Int(resultados![indice].periodo!)
                switch horas
                {
                case 4 : iOpcionHoras = 0
                case 6 : iOpcionHoras = 1
                case 8 : iOpcionHoras = 2
                case 12 : iOpcionHoras = 3
                case 24 : iOpcionHoras = 4
                case 48 : iOpcionHoras = 5
                default : iOpcionHoras = 0
                }
                pickerHoras.selectRow(iOpcionHoras, inComponent: 0, animated: true)
                
                if lbUnidadCant.text == "pastillas"
                {
                    iOpcionUnidades = 0
                }
                else if lbUnidadCant.text == "ml"
                {
                    iOpcionUnidades = 1
                }
                else if lbUnidadCant.text == "mg"
                {
                    iOpcionUnidades = 2
                }

                pickerUnidad.selectRow(iOpcionUnidades, inComponent: 0, animated: true)
                
                let tiempo = resultados![indice].hora
                pickHora.date = tiempo!
            }
        }
    }
////////////////// Termina ViewDidLoad
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
////////////////Pickers
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0)
        {
            return arrUnidades[row]
        }
        else if (pickerView.tag == 2){
           return arrDias[row]
        }
        else{
            return arrHoras[row]
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 0)
        {
            return arrUnidades.count
        }
        else if (pickerView.tag == 2){
            return arrDias.count
        }
        else
        {
            return arrHoras.count
            
        }
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0)
        {
           iOpcionUnidades = row
            lbUnidadCant.text = arrUnidades[row]
        }
        
        if(pickerView.tag == 1)
        {
            iOpcionHoras = row
        }
        
        if(pickerView.tag == 2)
        {
            iOpcionDias = row
        }

    }
////////////////////Termina Pickers
    
    
    func quitaTeclado()
    {
        view.endEditing(true)
    }
    
    private func registrarseParaNotificacionesDeTeclado() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewControllerMedicamento.keyboardWasShown(_:)),
                                                         name:UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewControllerMedicamento.keyboardWillBeHidden(_:)),
                                                         name:UIKeyboardWillHideNotification, object:nil)
    }
    
//////Teclado abajo, con el uso de scroll
  
    func keyboardWasShown (aNotification : NSNotification )
    {
        let kbSize = aNotification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        let contentInset = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        var bkgndRect : CGRect = scrollView.frame
        bkgndRect.size.height += kbSize.height
        activeField!.superview!.frame = bkgndRect
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
    
/////////teclado abajo
    


    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view = segue.destinationViewController as! ViewControllerInformacionMed
        view.delegado = tableDelegado
    }
    */

}