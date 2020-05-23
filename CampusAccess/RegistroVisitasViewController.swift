//
//  RegistroVisitasViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 21/05/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit

protocol administraRegistros {
    func agregaRegistro (registro: VisitModel) -> Void
}

class RegistroVisitasViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var tfNombreVisita: UITextField!
    @IBOutlet weak var tfMotivoVisita: UITextField!
    @IBOutlet weak var tfFecha: UITextField!
    @IBOutlet weak var tfHora: UITextField!
    @IBOutlet weak var tfResponsable: UITextField!
    
    var delegate : administraRegistros!
    var visita : VisitModel!
    let datePickerDate = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegistrar.layer.cornerRadius = 25.0
        createDatePicker()
        self.tfFecha.delegate = self
    }
    
    //prevent from writing on the date field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    //create toolbal and bar button
    func createToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    //assign toolbar and datePickers
    func createDatePicker() {
        tfFecha.inputAccessoryView = createToolBar()
        tfFecha.inputView = datePickerDate
    }

    @objc func donePressed() {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        tfFecha.text = formatter.string(from: datePickerDate.date)
        
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        tfHora.text = formatter.string(from: datePickerDate.date)
        
        self.view.endEditing(true)
    }
    
    func showError(){
        let alert = UIAlertController(title: "Campus Access", message: "Es obligatorio ingresar el nombre, motivo y fecha de la visita", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createRegister(_ sender: UIButton) {
        if let nombre = tfNombreVisita.text, let motivo = tfMotivoVisita.text, tfHora.text != "" {
            let nuevoRegistro = VisitModel(name: nombre, motive: motivo, responsable: tfResponsable.text!, date: datePickerDate.date)
            delegate.agregaRegistro(registro: nuevoRegistro)
            navigationController?.popViewController(animated: true)
        }
        showError()
    }
}
