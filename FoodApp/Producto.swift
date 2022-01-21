//
//  Producto.swift
//  FoodApp
//
//  Created by Anonymus on 4/12/21.
//

import Foundation

struct Producto: Decodable {
    
    var id: String
    var nombre: String
    var precio: Int32
    var cantidad: Int
 
    
    init() {
        
        id = ""
        nombre = ""
        precio = 0
       cantidad = 0
    
    }
}
