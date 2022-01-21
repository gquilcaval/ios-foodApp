//
//  CoreDataManager.swift
//  FoodApp
//
//  Created by Giancarlos on 16/12/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let container: NSPersistentContainer!
    
    init(){
        container = NSPersistentContainer(name: "RestaurantBD")
        container.loadPersistentStores{ (stDes, err) in
            if let err = err {
                print("error cargado la BD")
                
            }else{
                print("todo ok")
            }
        }
    }
    
    func savePedido(id: Int32, nombre: String, precio: Double, cantidad: Int32, mesa: String)  {
        let context = container.viewContext
        let pedido = Tb_pedido(context: context)
        pedido.id = id
        pedido.nombre = nombre
        pedido.precio = precio
        pedido.cantidad = cantidad
        pedido.mesa = mesa
        
        do {
            print("se guardo correctamente")
            try context.save()
        } catch  {
            print("no se puede guardar \(error)")
        }
    }
    
    func getPedido(id: String) -> [Tb_pedido] {
        let context = container.viewContext
        let query: NSFetchRequest<Tb_pedido> = Tb_pedido.fetchRequest()
        query.predicate = NSPredicate(format: "mesa = %@", id)
        
        do {
            print("listado correcto")
            let lista = try context.fetch(query)
            return lista
        } catch  {
            print("error al listar \(error)")
        }
        return []
    }
    
    func getAllPedido() -> [Tb_pedido] {
        let context = container.viewContext
        let query: NSFetchRequest<Tb_pedido> = Tb_pedido.fetchRequest()
        
        
        do {
            print("listado correcto")
            let lista = try context.fetch(query)
            return lista
        } catch  {
            print("error al listar \(error)")
        }
        return []
    }
    
    func deletePedido(id: Int32) {
        let context = container.viewContext
        let query: NSFetchRequest<Tb_pedido> = Tb_pedido.fetchRequest()
        query.predicate = NSPredicate(format: "id = %d", id)
        
        do {
            let lista = try context.fetch(query)
            print("no se encontro registro para eliminar")
            if lista.count == 1 {
                context.delete(lista[0])
                try context.save()
                print("se encontro y se elimino pedido")
            }
        } catch  {
            print("error al listar \(error)")
        }
    }
}
