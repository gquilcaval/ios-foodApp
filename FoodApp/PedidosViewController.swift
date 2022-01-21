//
//  PedidosViewController.swift
//  FoodApp
//
//  Created by Giancarlos on 9/12/21.
//

import UIKit

class PedidosViewController: UIViewController {

    let managerBD = CoreDataManager()
    var lista = [Tb_pedido]()
    var idMesa = ""

    @IBAction func btnActionAceptar(_ sender: Any) {
        // create the alert
               let alert = UIAlertController(title: "Confirmación", message: "Enviar pedidos a cocina", preferredStyle: .alert)

               // add an action (button)
        alert.addAction(UIAlertAction(title: "Confirmar", style: UIAlertAction.Style.default, handler: {
            action in
            print("pedido enviado")
        }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

               // show the alert
               self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet var tabla: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("se busca la mesa \(idMesa)")
        lista = managerBD.getPedido(id: idMesa)
        print(lista.count)
        tabla.dataSource = self
    }
    

    
    

}
extension PedidosViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cellPedido", for: indexPath) as! PedidoTableViewCell

        cell.lblNombre.text = lista[indexPath.row].nombre
        cell.lblCantidad.text = String(lista[indexPath.row].cantidad)
        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if  editingStyle == .delete {
            print("eliminar \(lista[indexPath.row].id)")
            managerBD.deletePedido(id: lista[indexPath.row].id)
            lista.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.idMesa
    }
    
    
}
