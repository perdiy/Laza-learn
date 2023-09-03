//
//  Alert.swift
//  Laza
//
//  Created by Perdi Yansyah on 30/08/23.
//

import Foundation
import UIKit

class ShowAlert {
    private static func showAlert(on viewControl: UIViewController, title:String, message: String){
        DispatchQueue.main.async{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewControl.present(alert, animated: true)
        }
    }
    public static func loginApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
           self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
       }
    public static func signUpApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
            self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
        }
    public static func forgotPassApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
        self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
    }
    
    public static func verifyPassApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
        self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
    }
    public static func performAlertApi(on viewController:UIViewController, title titleAlert:String, message messageAlert:String){
        self.showAlert(on: viewController, title: titleAlert, message: messageAlert)
    }
}
