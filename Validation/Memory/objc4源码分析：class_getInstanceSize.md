

# objc4源码分析：class_getInstanceSize

参考源码：objc4-818.2.tar.gz



objc->runtime.h

```objective-c
/** 
 * Returns the size of instances of a class.
 * 
 * @param cls A class object.
 * 
 * @return The size in bytes of instances of the class \e cls, or \c 0 if \e cls is \c Nil.
 */
OBJC_EXPORT size_t
class_getInstanceSize(Class _Nullable cls) 
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
```



Path: objc-class.mm

```objective-c
size_t class_getInstanceSize(Class cls)
{
    if (!cls) return 0;
    return cls->alignedInstanceSize();
}
```



Path: objc-runtime-new.h

```objective-c
struct objc_class : objc_object {

// Class's ivar size rounded up to a pointer-size boundary.
    uint32_t alignedInstanceSize() const {
        return word_align(unalignedInstanceSize());
    }

}
```

结论：获得对象的成员变量所占用的大小。