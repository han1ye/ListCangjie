package ListCangjie

// ListOps类：实现Java List接口的仓颉语言版本
// 技术特点：
// 1. 使用泛型<T>支持任意类型的数据操作
// 2. 所有方法都是静态方法，便于直接调用
// 3. 采用函数式编程范式，支持高阶函数
// 4. 所有操作都是不可变的，保证数据安全性
class ListOps {
    // append函数：合并两个数组
    // 实现原理：
    // 1. 内存分配：
    //    - 创建一个新数组，长度为arr1.size + arr2.size
    //    - 使用Array<T>构造函数，指定容量和初始化函数
    // 2. 元素复制策略：
    //    - 使用闭包函数{i => ...}作为初始化器
    //    - 根据索引i判断元素来源：
    //      * i < arr1.size：从arr1获取元素
    //      * i >= arr1.size：从arr2获取元素，偏移量为arr1.size
    // 3. 时间复杂度：O(n)，空间复杂度：O(n)
    static func append<T>(arr1: Array<T>, arr2: Array<T>): Array<T> {
        let result = Array<T>(arr1.size + arr2.size, {i => 
            if (i < arr1.size) {
                arr1[i]  // 从第一个数组获取元素
            } else {
                arr2[i - arr1.size]  // 从第二个数组获取元素，需要减去偏移量
            }
        })
        return result
    }
    
    // concatenate函数：将多个数组合并成一个扁平化的数组
    // 实现原理：
    // 1. 预处理阶段：
    //    - 遍历所有输入数组，计算总长度totalSize
    //    - 使用累加器模式计算总长度
    // 2. 内存分配：
    //    - 创建长度为totalSize的新数组
    // 3. 元素定位策略：
    //    - 使用pos变量记录已处理的元素数量
    //    - 对于每个索引i，遍历输入数组找到对应的源数组
    //    - 当pos + arr.size > i时，说明元素在当前数组中
    //    - 使用i - pos计算在源数组中的实际索引
    // 4. 时间复杂度：O(n)，空间复杂度：O(n)
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
    
    // length函数：获取数组长度
    // 实现原理：
    // 1. 直接访问数组的size属性
    // 2. 时间复杂度：O(1)，空间复杂度：O(1)
    // 3. 这是最基础的操作，作为其他操作的基础
    static func length<T>(arr: Array<T>): Int64 {
        return arr.size
    }
    
    // map函数：对数组中的每个元素应用转换函数
    // 实现原理：
    // 1. 函数式转换：
    //    - 接收一个转换函数fn: (T) -> R
    //    - 支持任意类型的转换（T -> R）
    // 2. 实现策略：
    //    - 创建新数组，保持原数组长度
    //    - 使用闭包函数对每个元素应用转换
    //    - 通过fn(arr[i])实现元素转换
    // 3. 时间复杂度：O(n)，空间复杂度：O(n)
    // 4. 应用场景：数据转换、类型转换、值计算等
    static func map<T, R>(arr: Array<T>, fn: (T) -> R): Array<R> {
        let result = Array<R>(arr.size, {i => fn(arr[i])})
        return result
    }
    
    // filter函数：根据条件过滤数组元素
    // 实现原理：
    // 1. 两阶段处理：
    //    - 第一阶段：计算符合条件的元素数量
    //    - 第二阶段：创建新数组并填充符合条件的元素
    // 2. 计数策略：
    //    - 使用count变量记录符合条件的元素数量
    //    - 遍历原数组，对每个元素应用谓词函数
    // 3. 元素选择策略：
    //    - 使用currentIndex记录已处理的符合条件的元素数量
    //    - 再次遍历原数组，选择符合条件的元素
    //    - 当currentIndex == i时，找到第i个符合条件的元素
    // 4. 时间复杂度：O(n)，空间复杂度：O(n)
    // 5. 应用场景：数据筛选、条件过滤等
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
    
    // reverse函数：反转数组
    // 实现原理：
    // 1. 对称交换策略：
    //    - 创建新数组，长度与原数组相同
    //    - 使用数学关系：新索引i对应原索引(arr.size - 1 - i)
    // 2. 实现细节：
    //    - 使用闭包函数计算每个位置的新元素
    //    - 通过arr[arr.size - 1 - i]获取对应元素
    // 3. 时间复杂度：O(n)，空间复杂度：O(n)
    // 4. 应用场景：数据反转、对称操作等
    static func reverse<T>(arr: Array<T>): Array<T> {
        let result = Array<T>(arr.size, {i => arr[arr.size - 1 - i]})
        return result
    }
    
    // foldl函数：从左到右折叠（reduce）操作
    // 实现原理：
    // 1. 累加器模式：
    //    - 使用accumulator变量存储中间结果
    //    - 初始值为参数initial
    // 2. 迭代策略：
    //    - 从左到右遍历数组
    //    - 对每个元素应用折叠函数
    //    - 更新accumulator为新的计算结果
    // 3. 函数签名：
    //    - fn: (R, T) -> R 表示接收累加器和当前元素，返回新的累加值
    // 4. 时间复杂度：O(n)，空间复杂度：O(1)
    // 5. 应用场景：求和、求积、字符串连接等
    static func foldl<T, R>(arr: Array<T>, initial: R, fn: (R, T) -> R): R {
        var accumulator = initial
        for (item in arr) {
            accumulator = fn(accumulator, item)
        }
        return accumulator
    }
    
    // foldr函数：从右到左折叠操作
    // 实现原理：
    // 1. 反向累加器模式：
    //    - 使用accumulator变量存储中间结果
    //    - 初始值为参数initial
    // 2. 迭代策略：
    //    - 从右到左遍历数组
    //    - 使用arr.size - 1 - i计算反向索引
    //    - 对每个元素应用折叠函数
    // 3. 函数签名：
    //    - fn: (T, R) -> R 表示接收当前元素和累加器，返回新的累加值
    // 4. 时间复杂度：O(n)，空间复杂度：O(1)
    // 5. 应用场景：需要从右到左处理数据的场景
    static func foldr<T, R>(arr: Array<T>, initial: R, fn: (T, R) -> R): R {
        var accumulator = initial
        for (i in 0..arr.size) {
            let index = arr.size - 1 - i
            accumulator = fn(arr[index], accumulator)
        }
        return accumulator
    }
}

// main函数：测试所有列表操作函数
// 测试策略：
// 1. 基础数据准备：
//    - 创建测试数组
//    - 准备预期结果
// 2. 功能测试：
//    - 依次测试每个函数
//    - 验证输出结果
// 3. 输出展示：
//    - 使用格式化输出
//    - 清晰展示输入和输出
main(): Int64 {
    println("=== 测试基本列表操作 ===")
    
    // 创建两个测试数组
    let arr1 = [1, 2, 3]  // 第一个测试数组
    let arr2 = [4, 5, 6]  // 第二个测试数组
    
    println("原始数组1: [1, 2, 3]")
    println("原始数组2: [4, 5, 6]")
    
    // 测试append函数：合并两个数组
    // 预期结果：[1, 2, 3, 4, 5, 6]
    let appended = ListOps.append(arr1, arr2)
    print("append结果: [")
    for (i in 0..appended.size) {
        if (i > 0) {
            print(", ")
        }
        print("${appended[i]}")
    }
    println("]")
    
    // 测试concatenate函数：合并多个数组
    // 创建测试用的二维数组：[[1, 2], [3, 4], [5, 6]]
    // 预期结果：[1, 2, 3, 4, 5, 6]
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
    
    // 测试length函数：获取数组长度
    // 预期结果：3
    println("数组1长度: ${ListOps.length(arr1)}")
    
    // 测试map函数：对每个元素乘以2
    // 输入：[1, 2, 3]
    // 预期结果：[2, 4, 6]
    let mapped = ListOps.map(arr1, {x => x * 2})
    print("map(*2)结果: [")
    for (i in 0..mapped.size) {
        if (i > 0) {
            print(", ")
        }
        print("${mapped[i]}")
    }
    println("]")
    
    // 测试filter函数：过滤出偶数
    // 输入：[1, 2, 3, 4, 5, 6]
    // 预期结果：[2, 4, 6]
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
    
    // 测试reverse函数：反转数组
    // 输入：[1, 2, 3]
    // 预期结果：[3, 2, 1]
    let reversed = ListOps.reverse(arr1)
    print("reverse结果: [")
    for (i in 0..reversed.size) {
        if (i > 0) {
            print(", ")
        }
        print("${reversed[i]}")
    }
    println("]")
    
    // 测试foldl函数：从左到右求和
    // 输入：[1, 2, 3]
    // 计算过程：((0 + 1) + 2) + 3 = 6
    // 预期结果：6
    let sumLeft = ListOps.foldl(arr1, 0, {acc, x => acc + x})
    println("foldl(求和)结果: ${sumLeft}")
    
    // 测试foldr函数：从右到左求和
    // 输入：[1, 2, 3]
    // 计算过程：1 + (2 + (3 + 0)) = 6
    // 预期结果：6
    let sumRight = ListOps.foldr(arr1, 0, {x, acc => x + acc})
    println("foldr(求和)结果: ${sumRight}")
    
    return 0
}