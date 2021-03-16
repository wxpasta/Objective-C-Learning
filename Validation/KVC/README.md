# KVC

KVC的全称是Key-Value Coding，俗称“键值编码”，可以通过一个key来访问某个属性



## 知识点



### 不支持路径

```objective-c
- (void)setValue:(nullable id)value forKey:(NSString *)key;
- (nullable id)valueForKey:(NSString *)key;
```

### 支持路径

```objective-c
- (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;
- (nullable id)valueForKeyPath:(NSString *)keyPath;
```



### setValue:forKey:原理

- 按照setKey:、_setKey:顺序查找方法
  - 传递参数，调用方法（找到了方法）
  - 查看accessInstanceVariablesDirectly方法返回值（未找到方法）
    - YES（默认为YES，可以直接访问成员变量）
      - 按照_key、 _isKey、key、isKey顺序查找成员变量
        - 直接赋值（找到了成员变量）
        - 调用setValue:forUndefinedKey:并抛出异常NSUnknownKeyException（没找到成员变量）
    - NO（不可以直接访问成员变量）
      - 调用setValue:forUndefinedKey:
      - 并抛出异常NSUnknownKeyException



### valueForKey:原理

- 按照getKey、key、 isKey、_key顺序查找方法
  - 调用方法（找到了方法）
  - 查看accessInstanceVariablesDirectly方法返回值（未找到方法）
    - YES（默认为YES，可以直接访问成员变量）
      - 按照_key、 _isKey、key、isKey顺序查找成员变量
        - 直接取值（找到了成员变量）
        - 调用valueForUndefinedKey:并抛出异常NSUnknownKeyException（没找到成员变量）
    - NO（不可以直接访问成员变量）
      - 调用valueForUndefinedKey:
      - 并抛出异常NSUnknownKeyException



```objective-c
/* Return YES if -valueForKey:, -setValue:forKey:, -mutableArrayValueForKey:, -storedValueForKey:, -takeStoredValue:forKey:, and -takeValue:forKey: may directly manipulate instance variables when sent to instances of the receiving class, NO otherwise. The default implementation of this property returns YES.
*/
@property (class, readonly) BOOL accessInstanceVariablesDirectly;
```



## 面试题

Q：通过KVC修改属性会触发KVO么？

A：会触发KVO