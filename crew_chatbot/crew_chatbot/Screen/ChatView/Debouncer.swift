//
//  Debouncer.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//

import Foundation


final class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(action: @escaping (() -> Void)) {
        workItem?.cancel()
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil
        }
        if let workItem = workItem {
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
