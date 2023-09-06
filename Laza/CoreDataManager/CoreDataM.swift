//
//  CoreDataM.swift
//  Laza
//
//  Created by Perdi Yansyah on 04/09/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataM {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // CREATE DATA IN CORE DATA
    func create(_ creditCard: CreditCard) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

        let creditCardEntity = NSEntityDescription.entity(forEntityName: "LazaCore", in: managedContext)

        let insert = NSManagedObject(entity: creditCardEntity!, insertInto: managedContext)
        insert.setValue(creditCard.cardOwner, forKey: "cardOwner")
        insert.setValue(creditCard.cardNumber, forKey: "cardNumber")
        insert.setValue(creditCard.cardExpMonth, forKey: "cardExpMonth")
        insert.setValue(creditCard.cardExpYear, forKey: "cardExpYear")
        insert.setValue(creditCard.cardCvv, forKey: "cardCvv")

        do {
            try managedContext.save()
            print("Saved data into Core Data")
        } catch let err {
            print("Failed to save data", err)
        }
    }

    // RETRIEVE DATA FROM CORE DATA
    func retrieve(completion: @escaping ([CreditCard]) -> Void) {
            var creditCard = [CreditCard]() // Mulai dengan array kosong
            
            let managedContext = appDelegate?.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LazaCore")
            
            do {
                let result = try managedContext?.fetch(fetchRequest)
                result?.forEach { creditCardData in
                    let card = CreditCard(
                        cardOwner: creditCardData.value(forKey: "cardOwner") as! String,
                        cardNumber: creditCardData.value(forKey: "cardNumber") as! String,
                        cardExpMonth: creditCardData.value(forKey: "cardExpMonth") as! Int16,
                        cardExpYear: creditCardData.value(forKey: "cardExpYear") as! Int16,
                        cardCvv: creditCardData.value(forKey: "cardCvv") as! Int16
                    )
                    creditCard.append(card)
                }
                
                completion(creditCard) // Mengirimkan data yang ditemukan
                print("Success")
            } catch let error {
                print("Failed to fetch data", error)
            }
        }
    
    func update(_ creditCard: CreditCard, cardNumber: String ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "LazaCore")
        fetchRequest.predicate = NSPredicate(format: "cardNumber = %@", cardNumber)

        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)

            if let updateCardData = fetchedResults.first {
                updateCardData.setValue(creditCard.cardOwner, forKey: "cardOwner")
                updateCardData.setValue(creditCard.cardNumber, forKey: "cardNumber")
                updateCardData.setValue(creditCard.cardExpYear, forKey: "cardExpYear")
                updateCardData.setValue(creditCard.cardExpMonth, forKey: "cardExpMonth")
                updateCardData.setValue(creditCard.cardCvv, forKey: "cardCvv")
                do {
                    try managedContext.save()
                    print("Data updated successfully")
                } catch {
                    print("Failed to update data in core data")
                }
            }
        } catch {
            print("Failed to update data", error)
        }
    }
    
    func delete(_ creditCard: CreditCard, completion: @escaping () -> Void) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "LazaCore")
        fetchRequest.predicate = NSPredicate(format: "cardOwner = %@", creditCard.cardOwner)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for dataToDelete in result {
                managedContext.delete(dataToDelete as! NSManagedObject)
            }
            try managedContext.save()
            completion()
        } catch let error {
            print("delete data er", error)
        }
    }
}

