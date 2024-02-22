//
//  HelperFunctions.swift
//  WebAppify
//
//  Created by Bennet Kampe on 20.02.24.
//

import Foundation

func getUniqueName(name: String, existingNames: [String]) -> String {
    // Check if the name already exists in the list
    if !existingNames.contains(name) {
        return name
    }

    // If the name exists, start incrementing from 1 to find a unique name
    var uniqueName = ""
    var counter = 1
    repeat {
        // Append the counter to the name inside parentheses
        uniqueName = "\(name)(\(counter))"
        counter += 1
    // Continue until a unique name is found
    } while existingNames.contains(uniqueName)

    return uniqueName
}

func extractDomainName(from url: URL, urlString: String) -> String {
    guard let host = url.host else {
        return urlString
    }
    var name = host.components(separatedBy: ".").first?.capitalized
    if name == "Www" {name = host.components(separatedBy: ".")[1].capitalized}
    return name ?? host
}
