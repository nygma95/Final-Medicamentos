//
//  HistorialGlucosaPresion+CoreDataProperties.swift
//  AppMedicamentos
//
//  Created by ArturoNajera on 4/30/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HistorialGlucosaPresion {

    @NSManaged var cantidad: String?
    @NSManaged var fechaHora: NSDate?
    @NSManaged var tipoRegistro: String?

}
