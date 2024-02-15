//
//  OpenWebAppsWidgetBundle.swift
//  OpenWebAppsWidget
//
//  Created by Bennet Kampe on 14.02.24.
//

import WidgetKit
import SwiftUI

@main
struct OpenWebAppsWidgetBundle: WidgetBundle {
    var body: some Widget {
        OpenWebAppsWidget()
        OpenWebAppsWidgetLiveActivity()
    }
}
