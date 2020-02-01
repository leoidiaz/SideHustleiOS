//
//  Alert.swift
//  
//
//  Created by Leonardo Diaz on 1/21/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

struct Alert {
    
    
    static func present(title: String?, message: String?, actions: Alert.Action..., from controller: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action.alertAction)
        }
        controller.present(alertController, animated: true, completion: nil)
    }

    
}


extension Alert {
    enum Action {
        case delete(handler: (() -> Void)?)
        case add(handler: (() -> Void)?)
        case dismiss(handler: (() -> Void)?)
        case update(handler: (() -> Void)?)
    
    private var title: String {
        switch self {
        case .delete:
            return "Delete"
        case .dismiss:
            return "Cancel"
        case .add:
            return "Add"
        case .update:
            return "Update"
        }
    }
        private var handler: (() -> Void)? {
            switch self {
            case .delete(let handler):
                return handler
            case .dismiss(let handler):
                return handler
            case .add(let handler):
                return handler
            case .update(let handler):
                return handler
            }
        }
        var alertAction: UIAlertAction {
            return UIAlertAction(title: title, style: .default, handler: { _ in
                if let handler = self.handler {
                    handler()
                }
            })
        }
        
    }
}

