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
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactIdentifierKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
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
    
    public func fetchContactByIdentifier(identifier: String) -> CNContact {
        var contact = CNContact()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactIdentifierKey, CNContactThumbnailImageDataKey] as [CNKeyDescriptor]
        do {
            contact = try contactStore.unifiedContact(withIdentifier: identifier, keysToFetch: keys)
        } catch {
            print("Something have error: \(error)")
        }
        return contact
    }
    
    public func getListContactWithSortedBySection() -> [[CNContact]] {
        var listHaveSorted = [[CNContact]]()
        var listAlpha = [String]()
        
        listAlpha = Array(Set(self.fetchDataContact().map {
            $0.familyName.firstCharacterOfString()
        })).sorted()
        
        listHaveSorted = listAlpha.map { list in
            return fetchDataContact()
                .filter {$0.familyName.firstCharacterOfString() == list}
                .sorted {$0.familyName > $1.familyName}
        }
        
        return listHaveSorted
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
    
    public func updateContact(identifierContact: String, oldValue: CNContact, newValue: CNContact) -> Bool {
        do {
            let saveRequest = CNSaveRequest()
//            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
//            let contact = try contactStore.unifiedContact(withIdentifier: identifierContact, keysToFetch: keysToFetch)
            if (oldValue.identifier == identifierContact) {
                let contactUpdate = oldValue.mutableCopy() as! CNMutableContact
                contactUpdate.givenName = newValue.givenName
                contactUpdate.familyName = newValue.familyName
                contactUpdate.phoneNumbers.removeAll()
                for index in 0...newValue.phoneNumbers.count - 1 {
                    contactUpdate.phoneNumbers.insert(newValue.phoneNumbers[index], at: index)
                    contactUpdate.phoneNumbers[index].label
                    CNLabelHome
                }
                
                saveRequest.update(contactUpdate)
                try contactStore.execute(saveRequest)
                return true
            }
        } catch let error {
            print("Have something error: \(error)")
        }
        return false
    }
}
