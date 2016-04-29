//
//  Usuario+CoreDataProperties.swift
//  AppMedicamentos
//
//  Created by alumno on 04/04/16.
//  Copyright © 2016 ivanarturo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Usuario {

    @NSManaged var nombreResponsable: String
    @NSManaged var apellidoResponsable: String
    @NSManaged var telefono: String
    @NSManaged var email: String
    @NSManaged var nombreUsuario: String
    @NSManaged var apellidoUsuario: String

}
