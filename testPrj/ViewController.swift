//
//  ViewController.swift
//  testPrj
//
//  Created by Амир Нуриев on 07.09.2018.
//  Copyright © 2018 Amir Nuriev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let blockThreader = BlockThreader(numberOfThreads: 67)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockThreader.start()
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(test)
        )
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func test() {
        blockThreader.enqueueTask {
            print("task 1")
        }
        
        blockThreader.enqueueTask {
            print("task 2")
            sleep(3)
        }
        
        blockThreader.enqueueTask {
            print("task 3")
            sleep(2)
        }
        
        blockThreader.enqueueTask {
            print("task 4")
            sleep(3)
        }
        
        blockThreader.enqueueTask {
            print("task 5")
            sleep(3)
        }
        
        blockThreader.enqueueTask {
            print("task 6")
            sleep(2)
        }
        
        blockThreader.enqueueTask {
            print("task 7")
        }
        
        blockThreader.enqueueTask {
            print("task 8")
        }
        
        let tasks = [
        { print("task 9")},
        { print("task 10")},
        { print("task 11")},
        { print("task 12")},
        { print("task 13")},
        { print("task 14")}
        ]
        
        blockThreader.enqueueTasks(tasks)
    }
}

