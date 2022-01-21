//
//  ViewController.swift
//  FoodApp
//
//  Created by Anonymus on 2/12/21.
//

import UIKit
import SocketIO
import HMSegmentedControl
struct CustomData : SocketData {
   let name: String
   let age: Int

   func socketRepresentation() -> SocketData {
       return ["name": name, "age": age]
   }
}

var mesa = ""

class ViewController: UIViewController {
    var mesas = ["mesa 1", "mesa 2", "mesa 3", "mesa 4", "mesa 5", "mesa 6", "mesa 7", "mesa 8", "mesa 9"]
    private let managerBD = CoreDataManager()
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var p = Pedido()
    var mSocket = SocketHandler.sharedInstance.getSocket()
       
       
   
       
       override func viewDidLoad() {
           super.viewDidLoad()
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.collectionViewLayout	= UICollectionViewFlowLayout()
           let segmentedControl = HMSegmentedControl(sectionTitles: [
               "Salon 1",
               "Salon 2",
               "Salon 3",
               "Salon 4",
               "Salon 5",
               "Salon 6",
               "Salon 7",

           ])
           let titleFormatterBlock: HMTitleFormatterBlock = {(control: AnyObject!, title: String!, index: UInt, selected: Bool) -> NSAttributedString in
               let attString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font: UIFont (name: "Helvetica", size: 14)
                           ])
                       return attString;
                   }
           segmentedControl.titleFormatter = titleFormatterBlock
          
           segmentedControl.selectionIndicatorLocation = .bottom
           segmentedControl.selectionIndicatorHeight = CGFloat(2.0)
           segmentedControl.selectionStyle = .fullWidthStripe
           segmentedControl.isVerticalDividerEnabled = true
           segmentedControl.autoresizingMask = [.flexibleRightMargin, .flexibleWidth]
           segmentedControl.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: 40)
           segmentedControl.segmentEdgeInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
          
           segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
           view.addSubview(segmentedControl)
           
           
           SocketHandler.sharedInstance.establishConnection()

           mSocket.on("server:newpedido") { (x, ack) in
               guard let cur = x[0] as? [String:Any]else{return}
               for (key, value) in cur {
                 
                   if key == "id" {
                       self.p.id = (value as? Int)!
                   }
                   if key == "mesa" {
                       self.p.mesa = (value as? String)!
                       
                   }
                   if key == "pedido" {
                       guard let productos = value as? [[String:Any]] else{return}

                       
                       for f in productos {
                           
                           
                           var prod = Producto()
                           prod.id = f["id"] as! String
                           prod.nombre = f["nombre"] as! String
                           prod.cantidad = f["cantidad"] as! Int
                           prod.precio = f["precio"] as! Int32
                           print("aqui id dentro de socket for \(self.p.mesa)")
                           self.managerBD.savePedido(id: Int32(prod.id) ?? 0, nombre: prod.nombre, precio: Double(prod.precio), cantidad: Int32(prod.cantidad), mesa: self.p.mesa)
                           self.p.pedido.append(prod)
                       }
                       }
               }

             
                   self.collectionView.reloadData()
            
    
               print(self.p.pedido)
    
           }
                      
       }
    
    @objc func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
            print("Selected index \(segmentedControl.selectedSegmentIndex)")
        }
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)

}



extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mesas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MesasCollectionViewCell", for: indexPath) as! MesasCollectionViewCell
        
        cell.lblMesa.text = mesas[indexPath.row]
        if cell.lblMesa.text == p.mesa {
            cell.backgroundColor = UIColor.orange
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dsVC = mainStoryboard.instantiateViewController(withIdentifier: "PedidosViewController") as! PedidosViewController
        
        dsVC.idMesa = mesas[indexPath.row]
        self.navigationController?.pushViewController(dsVC, animated: true)
    }
    func collectionView(
       _ collectionView: UICollectionView,
       layout collectionViewLayout: UICollectionViewLayout,
       insetForSectionAt section: Int
     ) -> UIEdgeInsets {
       return sectionInsets
     }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
          return sectionInsets.left
      }
    
    /*func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  mesas.count    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let pokemon = self.p.pedido[indexPath.row]
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PedidosTableViewCell

        
        cell.lblNombre.text = mesas[indexPath.row]
        
        if cell.lblNombre.text == p.mesa {
            cell.backgroundColor = UIColor.orange
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mesa = mesas[indexPath.row]
        tabla.deselectRow(at: indexPath, animated: true)
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PedidosTableViewCell
        
        performSegue(withIdentifier: "goPedido", sender: self)
    }*/
   
}

