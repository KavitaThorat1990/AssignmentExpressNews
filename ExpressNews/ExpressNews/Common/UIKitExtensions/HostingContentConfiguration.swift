//
//  HostingContentConfiguration.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 09/01/24.
//

import UIKit
import SwiftUI

struct HostingContentConfiguration<Content>: UIContentConfiguration where Content: View {
    // fileprivate, since we'll put ContentView that will be expained in the next code block in the same file
    fileprivate let hostingController: UIHostingController<Content>
    
    init(@ViewBuilder content: () -> Content) {
        hostingController = UIHostingController(rootView: content())
    }
    
    func makeContentView() -> UIView & UIContentView {
        // Our custom UIView that conforms to UIContentView
        ContentView<Content>(self)
    }
    
    func updated(for state: UIConfigurationState) -> HostingContentConfiguration<Content> {
        self
    }
}

private class ContentView<Content>: UIView, UIContentView where Content: View {
    var configuration: UIContentConfiguration {
        didSet {
            // (Re)configure once we have have a configuration
            configure(configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        // This view shouldn't be initialized this way so we crash
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(_ configuration: UIContentConfiguration) {
        guard let configuration = configuration as? HostingContentConfiguration<Content>,
              let parent = findViewController() else {
            return
        }

        let hostingController = configuration.hostingController
        
        guard let swiftUICellView = hostingController.view,
              subviews.isEmpty else {
            hostingController.view.invalidateIntrinsicContentSize()
            return
        }
        
        // A clear background since that's all we need for now
        hostingController.view.backgroundColor = .clear
        
        parent.addChild(hostingController)
        addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            leadingAnchor.constraint(equalTo: swiftUICellView.leadingAnchor),
            trailingAnchor.constraint(equalTo: swiftUICellView.trailingAnchor),
            topAnchor.constraint(equalTo: swiftUICellView.topAnchor),
            bottomAnchor.constraint(equalTo: swiftUICellView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        hostingController.didMove(toParent: parent)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.findViewController()
        }
        
        return nil
    }
}
