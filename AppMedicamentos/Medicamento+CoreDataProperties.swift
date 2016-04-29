//
//  Medicamento+CoreDataProperties.swift
//  AppMedicamentos
//
//  Created by ArturoNajera on 4/28/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Medicamento {

    @NSManaged var cantDisp: NSNumber?
    @NSManaged var dosis: NSNumber?
    @NSManaged var foto: NSData?
    @NSManaged var hora: NSDate?
    @NSManaged var indicaciones: String?
    @NSManaged var nombre: String?
    @NSManaged var periodo: NSNumber?
    @NSManaged var tipo: String?
    @NSManaged var porxDias: NSNumber?
    @NSManaged var diaaPartir: String?

}
