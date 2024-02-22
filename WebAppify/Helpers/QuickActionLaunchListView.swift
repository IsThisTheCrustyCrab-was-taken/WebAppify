//
//  QuickActionLaunchListView.swift
//  WebAppify
//
//  Created by Bennet Kampe on 21.02.24.
//

import Foundation
import SwiftUI

enum ActionType: String {
  case listSites = "listSites"
}


enum Action: Equatable {
  case listSites
  init?(shortcutItem: UIApplicationShortcutItem) {
    guard let type = ActionType(rawValue: shortcutItem.type) else {return nil}
    switch type {
    case .listSites:
      self = .listSites
    }
  }
}


class ActionService: ObservableObject {
  static let shared = ActionService()
  @Published var action: Action?
}
