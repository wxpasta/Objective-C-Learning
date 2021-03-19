

# objc4源码分析：Class object_getClass()

参考源码：objc4-818.2.tar.gz



Path: objc-class.mm

```objective-c
/***********************************************************************
* Information about multi-thread support:
*
* Since we do not lock many operations which walk the superclass, method
* and ivar chains, these chains must remain intact once a class is published
* by inserting it into the class hashtable.  All modifications must be
* atomic so that someone walking these chains will always geta valid
* result.
***********************************************************************/



/***********************************************************************
* object_getClass.
* Locking: None. If you add locking, tell gdb (rdar://7516456).
**********************************************************************/
Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}
```



#### Class object_getClass(id obj)

1. 传入的obj可能是instance对象、class对象、meta-class对象

2. 返回值

- 如果是instance对象，返回class对象

- 如果是class对象，返回meta-class对象

- 如果是meta-class对象，返回NSObject（基类）的meta-class对象