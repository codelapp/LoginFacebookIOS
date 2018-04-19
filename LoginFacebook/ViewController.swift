//
//  ViewController.swift
//  LoginFacebook
//
//  Created by Jorge M. B. on 11/04/18.
//  Copyright © 2018 Jorge M. B. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class ViewController: UIViewController {

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var apellido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
            print("ESTOY LOGEADO")
            camposUsuario()
        }else{
            print("NO ESTOY LOGEADO")
        }
    }

    
    @IBAction func iniciar(_ sender: UIButton) {
        login()
    }
    
    @IBAction func salir(_ sender: UIButton) {
        let cerrar = FBSDKLoginManager()
        cerrar.logOut()
    }
    
    func login(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: nil) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let result = result else { return }
            if result.isCancelled {
                return
            }else{
               self.camposUsuario()
            }
        }
    }
    
    func camposUsuario(){
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture.type(large)"]).start { (conexion, result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let fields = result as? [String:Any] {
                let nombreUser = fields["first_name"] as? String ?? ""
                let apellidoUser = fields["last_name"] as? String ?? ""
                self.nombre.text = nombreUser
                self.apellido.text = apellidoUser
                
                if let imagenProfile = fields["picture"] as? NSDictionary {
                    let data = imagenProfile.value(forKey: "data") as! NSDictionary
                    let pictureUrlString = data.value(forKey: "url") as! String
                    let pictureUrl = URL(string: pictureUrlString)
                    let datos = try? Data(contentsOf: pictureUrl!)
                    self.imagen.image = UIImage(data: datos!)
                }
                
                
            }
            
        }
    }
    
}







