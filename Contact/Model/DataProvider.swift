//
//  DataProvider.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/11/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import Foundation
import Contacts

class DataProvider {
    static let sharedInstance = DataProvider()
    var contactStore = CNContactStore()
    
    private init() {}
    
    public func fetchDataContact() -> [CNContact] {
       var listContacts = [CNContact]()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactIdentifierKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stoppingPoint) in
                listContacts.append(contact)
            }
        } catch {
            print("Something have error: \(error)")
        }
        return listContacts
    }
    
    public func addNewContact(contact: CNMutableContact) {
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
             try contactStore.execute(saveRequest)
        } catch {
            print("Something error \(error)")
        }
    }
    
    public func updateContact(identifierContact: String, newValue: CNContact) {
        do {
            let saveRequest = CNSaveRequest()
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let contact = try contactStore.unifiedContact(withIdentifier: identifierContact, keysToFetch: keysToFetch)
            let contactUpdate = contact.mutableCopy() as! CNMutableContact
            
            contactUpdate.givenName = newValue.givenName
            contactUpdate.familyName = newValue.familyName
            for index in 0...newValue.phoneNumbers.count - 1 {
                contactUpdate.phoneNumbers.insert(newValue.phoneNumbers[index], at: index)
            }
    
            saveRequest.update(contactUpdate)
            try contactStore.execute(saveRequest)
            
        } catch let error {
            print("Have something error: \(error)")
        }
    }
}
