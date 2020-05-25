//
//  DataLoader.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 10/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import Foundation

public class DataLoader {
    var lugaresData = [Lugar]()
    var eventosData = [EventModel]()
    
    init(arch:String) {
        load(nombreArchivo: arch)
    }
    
    init(arch: String, tipo: String){
        if(tipo == "evento"){
            loadEvents(nombreArchivo: arch)
        }else{
            load(nombreArchivo: arch)
        }
    }

    func load(nombreArchivo: String) {
        if let fileLocation = Bundle.main.url(forResource: nombreArchivo, withExtension: "json"){
            do{
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Lugar].self, from: data)
                self.lugaresData = dataFromJson
            }catch{
                print("error al descargar la información del archivo")
            }
        }
    }
    
    func loadEvents(nombreArchivo: String) {
        if let fileLocation = Bundle.main.url(forResource: nombreArchivo, withExtension: "json"){
            do{
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([EventModel].self, from: data)
                self.eventosData = dataFromJson
            }catch{
                print("error al descargar la información del archivo")
            }
        }
    }
}
