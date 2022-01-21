//
//  Pedido.swift
//  FoodApp
//
//  Created by Anonymus on 4/12/21.
//

import Foundation

struct Pedido {
    
    var id: Int
    var mesa: String
    var pedido: [Producto]
    
    init() {
        
        id = 0
        mesa = ""
        pedido = []
               
    }
    
}
