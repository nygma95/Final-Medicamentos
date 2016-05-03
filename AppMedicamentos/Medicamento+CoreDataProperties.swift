//
//  Medicamento+CoreDataProperties.swift
//  AppMedicamentos
//
//  Created by Publicidad on 02/05/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medicamento {

    @NSManaged var cantDisp: NSNumber?
    @NSManaged var diaaPartir: String?
    @NSManaged var dosis: NSNumber?
    @NSManaged var foto: NSData?
    @NSManaged var hora: NSDate?
    @NSManaged var indicaciones: String?
    @NSManaged var nombre: String?
    @NSManaged var periodo: NSNumber?
    @NSManaged var porxDias: NSNumber?
    @NSManaged var tipo: String?
    @NSManaged var limite: NSDate?

}
