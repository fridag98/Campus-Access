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
    let (datePickerDate, hourPicker) = (UIDatePicker(), UIDatePicker())

    override func viewDidLoad() {
        super.viewDidLoad()
        btnRegistrar.layer.cornerRadius = 25.0
        createDatePicker()
        createHourPicker()
        self.tfFecha.delegate = self
        self.tfHora.delegate = self
    }
    
    //prevent from writing on the date field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    //create toolbal and bar button
    func createDateToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePressed))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }

    func createHourToolBar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneHourPressed))
        toolbar.setItems([doneButton], animated: true)
        return toolbar
    }
    
    //assign toolbar and datePickers
    func createDatePicker() {
        datePickerDate.datePickerMode = .date
        datePickerDate.locale = Locale(identifier: "es_MX")
        tfFecha.inputAccessoryView = createDateToolBar()
        tfFecha.inputView = datePickerDate
    }

    func createHourPicker() {
        hourPicker.datePickerMode = .time
        hourPicker.locale = Locale(identifier: "en_US")
        tfHora.inputAccessoryView = createHourToolBar()
        tfHora.inputView = hourPicker
    }

    //assign date and hour in a specific format
    @objc func doneDatePressed() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        tfFecha.text = formatter.string(from: datePickerDate.date)
        print(datePickerDate.date)
        self.view.endEditing(true)
    }

    @objc func doneHourPressed() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        tfHora.text = formatter.string(from: hourPicker.date)
        print(hourPicker.date)
        self.view.endEditing(true)
    }
    
    func showError(){
        let alert = UIAlertController(title: "Campus Access", message: "Es obligatorio ingresar el nombre, motivo y fecha de la visita", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func convertStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePickerDate.date)
        formatter.dateFormat = "HH:mm"
        let hour = formatter.string(from: hourPicker.date)
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let stringDate = date + " " + hour
        let dateTime = formatter.date(from: stringDate)!
        return dateTime
    }
    
    @IBAction func createRegister(_ sender: UIButton) {
        if tfNombreVisita.text != "", tfMotivoVisita.text != "", tfHora.text != "" {
            let nuevoRegistro = VisitModel(name: tfNombreVisita.text!, motive: tfMotivoVisita.text!, responsable: tfResponsable.text!, date: convertStringToDate())
            delegate.agregaRegistro(registro: nuevoRegistro)
            navigationController?.popViewController(animated: true)
        }
        showError()
    }
}
