//
//  BlockThreader.swift
//  testPrj
//
//  Created by Амир Нуриев on 07.09.2018.
//  Copyright © 2018 Amir Nuriev. All rights reserved.
//

import Foundation

final class BlockThreader: NSObject {
    typealias Task = () -> Void
    
    private struct Queue<T> {
        private var array: [T] = []
        
        var isEmpty: Bool {
            return array.isEmpty
        }
        
        mutating func enqueue(_ element: T) {
            array.append(element)
        }
        
        mutating func dequeue() -> T? {
            guard !array.isEmpty else {
                return nil
            }
            return array.remove(at: 0)
        }
    }
    
    // MARK: - Private
    
    private let queuePool: [OperationQueue]
    private var observations: [NSKeyValueObservation] = []
    private var taskQueue = Queue<Task>()
    
    private var areQueuesAvaliable: Bool {
        return queuePool.contains { $0.operationCount == 0 }
    }
    
    // MARK: - Helpers
    
    private func observeQueueIsEmpty(_ queue: OperationQueue) {
        observations += [
            queue.observe(\.operations, options: [.new]) { [weak self] _, change in
                guard let `self` = self else { return }
                
                if change.newValue?.count == 0 {
                    DispatchQueue.main.sync {
                        self.startTasksIfNeeded()
                    }
                }
            }
        ]
    }
    
    private func setupQueuesObserving() {
        queuePool.forEach { observeQueueIsEmpty($0) }
    }
    
    private func startTasksIfNeeded() {
        guard areQueuesAvaliable else { return }
        
        if let nextTask = taskQueue.dequeue() {
            for queue in queuePool {
                guard queue.operationCount == 0 else {
                    continue
                }
                queue.addOperation(nextTask)
                return
            }
        }
    }
    
    // MARK: - Init
    
    init(numberOfThreads: Int) {
        queuePool = (0..<numberOfThreads).map { _ in OperationQueue() }
    }
    
    deinit {
        observations.forEach { $0.invalidate() }
    }
    
    // MARK: - Public
    
    func start() {
        setupQueuesObserving()
    }
    
    func enqueueTask(_ task: @escaping Task) {
        taskQueue.enqueue(task)
        startTasksIfNeeded()
    }
    
    func enqueueTasks(_ tasks: [Task]) {
        tasks.forEach { enqueueTask($0) }
    }
}
