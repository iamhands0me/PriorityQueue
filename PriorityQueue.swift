/*
 
 var pq: PriorityQueue = [10, 60, 50, 20]

 var pq = PriorityQueue<Int>()
 var pq = PriorityQueue<Int>(by: >)
 pq.push(10)
 pq.push(60)
 pq.push(50)
 pq.push(20)

 while let highest = pq.pop() {
     print(highest)
 }
 
 */

struct PriorityQueue<Element> {
    private var heap: [Element]
    private let areInIncreasingOrder: (Element, Element) -> Bool
    
    var isEmpty: Bool { heap.isEmpty }
    var count: Int { heap.count }
    var top: Element? { heap.first }
    
    init(_ elements: [Element] = [],
         by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        heap = elements.sorted { !areInIncreasingOrder($0, $1) }
        self.areInIncreasingOrder = areInIncreasingOrder
    }
    
    mutating func push(_ element: Element) {
        heap.append(element)
        
        var i = heap.count - 1
        while true {
            let parent = (i - 1) / 2
            guard parent >= 0,
                  areInIncreasingOrder(heap[parent], heap[i]) else { return }
            
            heap.swapAt(i, parent)
            i = parent
        }
    }
    
    mutating func pop() -> Element? {
        guard let top = top,
              let last = heap.last else { return nil }
        
        heap[0] = last
        let size = count
        var i = 0
        while true {
            let left = i * 2 + 1
            let right = i * 2 + 2
            guard left < size else { break }
            
            let target: Int
            if right < size && areInIncreasingOrder(heap[left], heap[right]) {
                target = right
            } else {
                target = left
            }
            
            guard areInIncreasingOrder(heap[i], heap[target]) else { break }
            
            heap.swapAt(i, target)
            i = target
        }
        
        heap.removeLast()
        return top
    }
}

extension PriorityQueue: ExpressibleByArrayLiteral where Element: Comparable {
    init(_ elements: [Element] = []) {
        self.init(elements, by: <)
    }
    
    init(arrayLiteral: Element...) {
        self.init(Array(arrayLiteral))
    }
}
