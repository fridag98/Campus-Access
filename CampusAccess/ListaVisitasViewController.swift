//
//  ListaVisitasViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 21/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import Firebase

class CustomTableViewCell : UITableViewCell {
    @IBOutlet weak var lbRegistro: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
}

class ListaVisitasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, administraRegistros  {

    @IBOutlet weak var btnAgregar: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var user : UserModel!
    var arrVisitas = [VisitModel]()
    var alturaCelda = 87.00
    var imgURL : String!
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }
    
    //bring from Firebase user's visits
    func downloadVisits() {
        self.showSpinner()
        let docRef = db.collection("visitas").whereField("uid", isEqualTo: user.uid ?? "")
        docRef.getDocuments() { (querySnapshot, error) in
            if error != nil {
                self.removeSpinner()
                return
            } else {
                for document in querySnapshot!.documents {
                    let visita = VisitModel(name: document.data()["nombre"] as! String, motive: document.data()["motivo"] as! String, responsable: document.data()["responsable"] as! String, date: self.dateFormatter().date(from: document.data()["fecha"] as! String)!)
                    self.arrVisitas.append(visita)
                   // print("\(document.documentID) => \(document.data()")
                }
                self.tableView.reloadData()
                self.removeSpinner()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        btnAgregar.layer.cornerRadius = 25.0
        tableView.tableFooterView = UIView()
        downloadVisits()
    }
    
    // MARK: - Table view settings

    //show visits on descending date order
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrVisitas = arrVisitas.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        return arrVisitas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(alturaCelda)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "idCell") as! CustomTableViewCell
        celda.lbRegistro.text = arrVisitas[indexPath.row].name
        
        let formatter = dateFormatter()
        formatter.timeStyle = .none
        celda.lbFecha.text = formatter.string(from: arrVisitas[indexPath.row].date)
        
        let today = Calendar.current.startOfDay(for: Date())
        let dayOfVisit = Calendar.current.startOfDay(for: arrVisitas[indexPath.row].date)
        
        if dayOfVisit < today {
            celda.lbRegistro.textColor = .red
        }
        else {
            celda.lbRegistro.textColor = .black
        }

        return celda
    }
    
    //return bar button
    @IBAction func btnRegresar(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDetallesVisita"){
            let vistaDetalle = segue.destination as! DetallesVisitaViewController
            let index = tableView.indexPathForSelectedRow!
            vistaDetalle.visita = arrVisitas[index.row]
            vistaDetalle.user = self.user
            vistaDetalle.imgURL = self.imgURL
        } else {
            let vistaRegistro = segue.destination as! RegistroVisitasViewController
            vistaRegistro.delegate = self
        }
    }
    
    //add new user's visit to Firebase
    func agregaRegistro (registro: VisitModel) {        
        let dataVisit: Dictionary<String, String> = [
            "fecha": dateFormatter().string(from: registro.date),
            "motivo": registro.motive!,
            "nombre": registro.name!,
            "responsable": registro.responsable!,
            "uid": user.uid!
        ]
        self.showSpinner()
        db.collection("visitas").addDocument(data: dataVisit) { (error) in
            if error != nil {
                print("No se guardó la visita del usuario")
            } else {
                self.arrVisitas.append(registro)
                self.tableView.reloadData()
            }
            self.removeSpinner()
        }
    }
    
}
