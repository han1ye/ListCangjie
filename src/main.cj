package ListCangjie

// 基本列表操作的工具类
class ListOps {
    // 将两个数组合并
    static func append<T>(arr1: Array<T>, arr2: Array<T>): Array<T> {
        let result = Array<T>(arr1.size + arr2.size, {i => 
            if (i < arr1.size) {
                arr1[i]
            } else {
                arr2[i - arr1.size]
            }
        })
        return result
    }
    
    // 将多个数组扁平化合并
    static func concatenate<T>(arrays: Array<Array<T>>): Array<T> {
        // 计算总长度
        var totalSize = 0
        for (arr in arrays) {
            totalSize += arr.size
        }
        
        // 创建结果数组
        let result = Array<T>(totalSize, {i =>
            // 找到第i个元素属于哪个数组
            var pos = 0
            for (arr in arrays) {
                if (pos + arr.size > i) {
                    return arr[i - pos]
                }
                pos += arr.size
            }
            return arrays[0][0] // 这行不会执行到，只是为了类型检查
        })
        return result
    }
    
    // 计算数组长度
    static func length<T>(arr: Array<T>): Int64 {
        return arr.size
    }
    
    // 对每个元素应用函数
    static func map<T, R>(arr: Array<T>, fn: (T) -> R): Array<R> {
        let result = Array<R>(arr.size, {i => fn(arr[i])})
        return result
    }
    
    // 根据谓词过滤元素
    static func filter<T>(arr: Array<T>, predicate: (T) -> Bool): Array<T> {
        // 先计算符合条件的元素数量
        var count = 0
        for (item in arr) {
            if (predicate(item)) {
                count++
            }
        }
        
        // 创建结果数组
        let result = Array<T>(count, {i =>
            // 找到第i个符合条件的元素
            var currentIndex = 0
            for (j in 0..arr.size) {
                if (predicate(arr[j])) {
                    if (currentIndex == i) {
                        return arr[j]
                    }
                    currentIndex++
                }
            }
            return arr[0] // 这行不会执行到，只是为了类型检查
        })
        return result
    }
    
    // 反转数组
    static func reverse<T>(arr: Array<T>): Array<T> {
        let result = Array<T>(arr.size, {i => arr[arr.size - 1 - i]})
        return result
    }
    
    // 从左到右折叠
    static func foldl<T, R>(arr: Array<T>, initial: R, fn: (R, T) -> R): R {
        var accumulator = initial
        for (item in arr) {
            accumulator = fn(accumulator, item)
        }
        return accumulator
    }
    
    // 从右到左折叠
    static func foldr<T, R>(arr: Array<T>, initial: R, fn: (T, R) -> R): R {
        var accumulator = initial
        for (i in 0..arr.size) {
            let index = arr.size - 1 - i
            accumulator = fn(arr[index], accumulator)
        }
        return accumulator
    }
}

main(): Int64 {
    println("=== 测试基本列表操作 ===")
    
    // 测试基本数组
    let arr1 = [1, 2, 3]
    let arr2 = [4, 5, 6]
    
    println("原始数组1: [1, 2, 3]")
    println("原始数组2: [4, 5, 6]")
    
    // 测试 append
    let appended = ListOps.append(arr1, arr2)
    print("append结果: [")
    for (i in 0..appended.size) {
        if (i > 0) {
            print(", ")
        }
        print("${appended[i]}")
    }
    println("]")
    
    // 测试 concatenate
    let multiArrays = [[1, 2], [3, 4], [5, 6]]
    let concatenated = ListOps.concatenate(multiArrays)
    print("concatenate结果: [")
    for (i in 0..concatenated.size) {
        if (i > 0) {
            print(", ")
        }
        print("${concatenated[i]}")
    }
    println("]")
    
    // 测试 length
    println("数组1长度: ${ListOps.length(arr1)}")
    
    // 测试 map (每个元素乘以2)
    let mapped = ListOps.map(arr1, {x => x * 2})
    print("map(*2)结果: [")
    for (i in 0..mapped.size) {
        if (i > 0) {
            print(", ")
        }
        print("${mapped[i]}")
    }
    println("]")
    
    // 测试 filter (只保留偶数)
    let testArr = [1, 2, 3, 4, 5, 6]
    let filtered = ListOps.filter(testArr, {x => x % 2 == 0})
    print("filter(偶数)结果: [")
    for (i in 0..filtered.size) {
        if (i > 0) {
            print(", ")
        }
        print("${filtered[i]}")
    }
    println("]")
    
    // 测试 reverse
    let reversed = ListOps.reverse(arr1)
    print("reverse结果: [")
    for (i in 0..reversed.size) {
        if (i > 0) {
            print(", ")
        }
        print("${reversed[i]}")
    }
    println("]")
    
    // 测试 foldl (求和)
    let sumLeft = ListOps.foldl(arr1, 0, {acc, x => acc + x})
    println("foldl(求和)结果: ${sumLeft}")
    
    // 测试 foldr (求和)
    let sumRight = ListOps.foldr(arr1, 0, {x, acc => x + acc})
    println("foldr(求和)结果: ${sumRight}")
    
    return 0
}