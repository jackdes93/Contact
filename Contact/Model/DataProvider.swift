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
            if (oldValue.identifier == identifierContact) {
                let contactUpdate = oldValue.mutableCopy() as! CNMutableContact
                contactUpdate.givenName = newValue.givenName
                contactUpdate.familyName = newValue.familyName
                contactUpdate.phoneNumbers.removeAll()
                contactUpdate.phoneNumbers = newValue.phoneNumbers
                saveRequest.update(contactUpdate)
                try contactStore.execute(saveRequest)
                return true
            }
        } catch let error {
            print("Have something error: \(error)")
        }
        return false
    }
    
    func listContactNeedUpdate() -> [CNContact] {
        let origanalContacts = fetchDataContact()
        let listHeaderNumberNeedChange = ["0120","0121","0122","0123","0124","0125","0126","0127","0128","0129","0162","0163","0164","0165","0166","0167","0168","0169","0186","0188","0199"]
        var contacts = [CNContact]()
        
        for index in 0...origanalContacts.count - 1 {
            let contact = origanalContacts[index]
            for item in contact.phoneNumbers {
                let numberPhone = item.value.stringValue
                let headerCheck = String(numberPhone[..<numberPhone.index(numberPhone.startIndex, offsetBy: 4)])
                if listHeaderNumberNeedChange.contains(headerCheck) && !contacts.contains(contact) {
                    contacts.append(contact)
                }
            }
        }
        return contacts
    }
    
    func returnIndexNeedChange(contact: CNContact) -> [Int] {
        var result = [Int]()
        let listHeaderNumberNeedChange = ["0120","0121","0122","0123","0124","0125","0126","0127","0128","0129","0162","0163","0164","0165","0166","0167","0168","0169","0186","0188","0199"]
        for index in 0...contact.phoneNumbers.count - 1 {
            let numberPhone = contact.phoneNumbers[index].value.stringValue
            let headerCheck = String(numberPhone[..<numberPhone.index(numberPhone.startIndex, offsetBy: 4)])
            if listHeaderNumberNeedChange.contains(headerCheck) {
                result.append(index)
            }
        }
        return result
    }
    
    func updateAllContactToNewHeaderNumber() {
        let listContactsNeedUpdate = listContactNeedUpdate()
        for contact in listContactsNeedUpdate {
            do {
                let saveRequest = CNSaveRequest()
                let contactUpdate = contact.mutableCopy() as! CNMutableContact
                let listIndexChange = returnIndexNeedChange(contact: contact)
                for index in listIndexChange {
                   let newValue = convertToNewHeaderNumber(numberPhone: contactUpdate.phoneNumbers[index].value.stringValue)
                   let newPhoneNumber = CNLabeledValue(label: contactUpdate.phoneNumbers[index].label, value: CNPhoneNumber(stringValue: newValue))
                   contactUpdate.phoneNumbers.remove(at: index)
                   contactUpdate.phoneNumbers.insert(newPhoneNumber, at: index)
                }
                saveRequest.update(contactUpdate)
                try contactStore.execute(saveRequest)
            } catch let error {
                print("Have something error: \(error)")
            }
        }
    }
    
    func numberNetWork() -> [String] {
        let listContact = fetchDataContact()
        var result = [String]()
        for contact in listContact {
            for phoneNumber in contact.phoneNumbers {
                var value = phoneNumber.value.stringValue
                if !result.contains(value.groupingNetworkByHeaderNumber()) {
                     result.append(value.groupingNetworkByHeaderNumber())
                }
            }
        }
        return result
    }
    
    public func groupByHeaderNumber() -> [[String]] {
        var result = [[String]]()
        let nameNetwork = numberNetWork()
        let listPhone = fetchDataContact()
        
        for index in 0...nameNetwork.count-1 {
            var group = [String]()
            for contact in listPhone {
                for numberPhone in contact.phoneNumbers {
                    var check = numberPhone.value.stringValue
                    if check.groupingNetworkByHeaderNumber() == nameNetwork[index] {
                        group.append(numberPhone.value.stringValue)
                    }
                }
            }
            result.append(group)
        }
        return result
    }
    
    enum oldNumber {
        case Mobi0120, Mobi0121, Mobi0122, Mobi0126, Mobi0128
        case Vina0123, Vina0124, Vina0125, Vina0127, Vina0129
        case Viettel0162, Viettel0163, Viettel0164, Viettel0165, Viettel0166, Viettel0167, Viettel0168, Viettel0169
        case VNMB0186, VNMB0188
        case Gmobile0199
    
        func newNumber() -> String {
            switch self {
            case .Mobi0120:
                return "070"
            case .Mobi0121:
                return "079"
            case .Mobi0122:
                return "077"
            case .Vina0123:
                return "083"
            case .Vina0124:
                return "084"
            case .Vina0125:
                return "085"
            case .Mobi0126:
                return "076"
            case .Vina0127:
                return "081"
            case .Mobi0128:
                return "078"
            case .Vina0129:
                return "082"
            case .Viettel0162:
                return "032"
            case .Viettel0163:
                return "033"
            case .Viettel0164:
                return "034"
            case .Viettel0165:
                return "035"
            case .Viettel0166:
                return "036"
            case .Viettel0167:
                return "037"
            case .Viettel0168:
                return "038"
            case .Viettel0169:
                return "039"
            case .VNMB0186:
                return "056"
            case .VNMB0188:
                return "058"
            case .Gmobile0199:
                return "059"
            }
        }
    }
    
    func numberOfPhoneNumberConvertHeader(listPhone: [String]) -> Int {
        var flat = 0
        for item in listPhone {
            if !item.isEmpty {
                flat += 1
            }
        }
        return flat
    }
    
    func convertToNewHeaderNumber(numberPhone: String) -> String {
        let keyCheck = String(numberPhone[..<numberPhone.index(numberPhone.startIndex, offsetBy: 4)])
        var result = numberPhone
        
        switch keyCheck {
            case "0120":
                result = result.replaceString(string: oldNumber.Mobi0120.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0121":
                result = result.replaceString(string: oldNumber.Mobi0121.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0122":
                result = result.replaceString(string: oldNumber.Mobi0122.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0123":
                result = result.replaceString(string: oldNumber.Vina0123.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0124":
                result = result.replaceString(string: oldNumber.Vina0124.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0125":
                result = result.replaceString(string: oldNumber.Vina0125.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0126":
                result = result.replaceString(string: oldNumber.Mobi0126.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0127":
                result = result.replaceString(string: oldNumber.Vina0127.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0128":
                result = result.replaceString(string: oldNumber.Mobi0128.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0129":
                result = result.replaceString(string: oldNumber.Mobi0128.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0162":
                result = result.replaceString(string: oldNumber.Viettel0162.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0163":
                result = result.replaceString(string: oldNumber.Viettel0163.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0164":
                result = result.replaceString(string: oldNumber.Viettel0164.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0165":
                result = result.replaceString(string: oldNumber.Viettel0165.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0166":
                result = result.replaceString(string: oldNumber.Viettel0166.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0167":
                result = result.replaceString(string: oldNumber.Viettel0167.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0168":
                result = result.replaceString(string: oldNumber.Viettel0168.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0169":
                result = result.replaceString(string: oldNumber.Viettel0169.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0186":
                result = result.replaceString(string: oldNumber.VNMB0186.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0188":
                result = result.replaceString(string: oldNumber.VNMB0188.newNumber(), at: result.startIndex, ofSetBy: 4)
            case "0199":
                result = result.replaceString(string: oldNumber.Gmobile0199.newNumber(), at: numberPhone.startIndex, ofSetBy: 4)
            default:
                break
        }
        return result
    }
    
    func listPhoneConvertHeaderPhoneNumber(listPhone: [String]) -> [String] {
        var listResult = [String]()
        if listPhone.count > 0 {
            let range = listPhone.count - 1
            for i in 0...range {
                var item = listPhone[i]
                let checkString = String(item[..<item.index(item.startIndex, offsetBy: 4)])
                var result = ""
                switch checkString {
                case "0120":
                    result = item.replaceString(string: oldNumber.Mobi0120.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0121":
                    result = item.replaceString(string: oldNumber.Mobi0121.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0122":
                    result = item.replaceString(string: oldNumber.Mobi0122.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0123":
                    result = item.replaceString(string: oldNumber.Vina0123.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0124":
                    result = item.replaceString(string: oldNumber.Vina0124.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0125":
                    result = item.replaceString(string: oldNumber.Vina0125.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0126":
                    result = item.replaceString(string: oldNumber.Mobi0126.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0127":
                    result = item.replaceString(string: oldNumber.Vina0127.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0128":
                    result = item.replaceString(string: oldNumber.Mobi0128.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0129":
                    result = item.replaceString(string: oldNumber.Mobi0128.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0162":
                    result = item.replaceString(string: oldNumber.Viettel0162.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0163":
                    result = item.replaceString(string: oldNumber.Viettel0163.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0164":
                    result = item.replaceString(string: oldNumber.Viettel0164.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0165":
                    result = item.replaceString(string: oldNumber.Viettel0165.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0166":
                    result = item.replaceString(string: oldNumber.Viettel0166.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0167":
                    result =  item.replaceString(string: oldNumber.Viettel0167.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0168":
                    result = item.replaceString(string: oldNumber.Viettel0168.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0169":
                    result = item.replaceString(string: oldNumber.Viettel0169.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0186":
                    result = item.replaceString(string: oldNumber.VNMB0186.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0188":
                    result = item.replaceString(string: oldNumber.VNMB0188.newNumber(), at: item.startIndex, ofSetBy: 4)
                case "0199":
                    result = item.replaceString(string: oldNumber.Gmobile0199.newNumber(), at: item.startIndex, ofSetBy: 4)
                default:
                    break
                }
                listResult.append(result)
            }
        }
        return listResult
    }
}
