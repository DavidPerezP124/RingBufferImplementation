//
//  main.swift
//  RingBuffer
//
//  Created by David Perez on 07/11/20.
//

import Foundation
// MARK: - Example Print
func example(of example: String, block: () -> Void){
    print("-- Example of \(example) --")
    block()
}
// MARK: - Queue
public protocol Queue {
    associatedtype Element
    mutating func enqueue(_ element:Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty: Bool { get }
    var peek: Element? { get }
}
// MARK: - RingBuffer
public struct RingBuffer<T>{
    fileprivate var array: [T?]
    fileprivate var readIndex = 0
    fileprivate var writeIndex = 0
    
    public init(count: Int){
        array = [T?](repeating: nil, count: count)
    }
    
    @discardableResult
    public mutating func write(_ element: T?) -> Bool{
        if !isFull{
            array[writeIndex % array.count] = element
            writeIndex += 1
            return true
        } else {
            return false
        }
    }
    
    public mutating func read() -> T? {
        if !isEmpty{
            let element = array[readIndex % array.count]
            readIndex += 1
            return element
        } else {
            return nil
        }
    }

    fileprivate var availableSpaceForReading: Int{
        return writeIndex - readIndex
    }
    
    fileprivate var availableSpaceForWriting: Int{
        return array.count - availableSpaceForReading
    }
    
    public var first: T? {
        guard let first = array.first else {return nil}
        return first
    }
    
    public var isEmpty: Bool {
        return availableSpaceForReading == 0
    }
    
    public var isFull: Bool{
        return availableSpaceForWriting ==  0
    }
}

extension RingBuffer : CustomStringConvertible {
    public var description: String {
        return (array.reduce(into: "[ ") { $0 += "\(String(describing: $1)), "} + "]").replacingOccurrences(of: "Optional", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: ", ]", with: " ]")
    }
}

// MARK: QueueRingBuffer
public struct QueueRingBuffer<T>: Queue {
    private var ringBuffer: RingBuffer<T>
    
    @discardableResult
    public mutating func enqueue(_ element: T) -> Bool {
        return ringBuffer.write(element)
    }
    
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : ringBuffer.read()
    }
    
    public var isEmpty: Bool {
        return ringBuffer.isEmpty
    }
    
    public var peek: T? {
        return ringBuffer.first
    }
    
    public typealias Element = T
 
    
    public init(count:Int){
        ringBuffer = RingBuffer<T>(count:count)
    }
}

extension QueueRingBuffer: CustomStringConvertible {
    public var description: String {
        return ringBuffer.description
    }
}

example(of: "Implementing a Ring Buffer") {
    var queue = QueueRingBuffer<Int>(count: 13)
    queue.enqueue(1)
    print("Peek",queue.peek!)
    queue.enqueue(2)
    queue.enqueue(3)
    print("Dequeue",queue.dequeue())
    print("Dequeue",queue.dequeue())
    queue.enqueue(4)
    queue.enqueue(5)
    queue.enqueue(6)
    queue.enqueue(7)
    queue.enqueue(8)
    queue.enqueue(13)
    print("Peek",queue.peek!)
    queue.enqueue(14)
    print("Dequeue",queue.dequeue())
    print("Peek",queue.peek!)
    print(queue.description)
}
