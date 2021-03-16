//
//  main.m
//  Interview
//
//  Created by 巴糖 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

// NSObject 源码定义
/*
 @interface NSObject <NSObject> {
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Wobjc-interface-ivars"
     Class isa  OBJC_ISA_AVAILABILITY;
 #pragma clang diagnostic pop
 }
 @end
 
 // 简化
 @interface NSObject {
    Class isa;
 }
 @end
 */


// Path:main_arm64.cpp源文件
// NSObject Implementation
struct NSObject_IMPL {
    Class isa; // 8个字节（64位）
};

// 指针
//typedef struct objc_class *Class;


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //Q：一个NSObject对象占用多少内存？
        //A:16

        
        NSObject *obj = [[NSObject alloc] init];
        // 16个字节
        
        // 获得NSObject实例对象的成员变量所占用的大小 >> 8
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        
        // 获得obj指针所指向内存的大小 >> 16
        NSLog(@"%zd", malloc_size((__bridge const void *)obj));
        
        // 什么平台的代码
        // 不同平台支持的代码肯定是不一样
        // Windows、mac、iOS
        // 模拟器(i386)、32bit(armv7)、64bit（arm64）
    }
    return 0;
}


/*
 // Path: objc-class.mm
 size_t class_getInstanceSize(Class cls)
 {
     if (!cls) return 0;
     return cls->alignedInstanceSize();
 }
 
 // Path: objc-runtime-new.h
 // Class's ivar size rounded up to a pointer-size boundary.
 uint32_t alignedInstanceSize() const {
     return word_align(unalignedInstanceSize());
 }
 
 */

/*
 Path:NSObject.mm
 
 + (id)alloc {
     return _objc_rootAlloc(self);
 }

 // Replaced by ObjectAlloc
 + (id)allocWithZone:(struct _NSZone *)zone {
     return _objc_rootAllocWithZone(self, (malloc_zone_t *)zone);
 }


 Path:objc-runtime-new.mm
 
 NEVER_INLINE
 id
 _objc_rootAllocWithZone(Class cls, malloc_zone_t *zone __unused)
 {
     // allocWithZone under __OBJC2__ ignores the zone parameter
     return _class_createInstanceFromZone(cls, 0, nil,
                                          OBJECT_CONSTRUCT_CALL_BADALLOC);
 }
 
 static ALWAYS_INLINE id
 _class_createInstanceFromZone(Class cls, size_t extraBytes, void *zone,
                               int construct_flags = OBJECT_CONSTRUCT_NONE,
                               bool cxxConstruct = true,
                               size_t *outAllocatedSize = nil)
 {
     ASSERT(cls->isRealized());

     // Read class's info bits all at once for performance
     bool hasCxxCtor = cxxConstruct && cls->hasCxxCtor();
     bool hasCxxDtor = cls->hasCxxDtor();
     bool fast = cls->canAllocNonpointer();
     size_t size;

     size = cls->instanceSize(extraBytes);
     if (outAllocatedSize) *outAllocatedSize = size;

     id obj;
     if (zone) {
         obj = (id)malloc_zone_calloc((malloc_zone_t *)zone, 1, size);
     } else {
         obj = (id)calloc(1, size);
     }
     if (slowpath(!obj)) {
         if (construct_flags & OBJECT_CONSTRUCT_CALL_BADALLOC) {
             return _objc_callBadAllocHandler(cls);
         }
         return nil;
     }

     if (!zone && fast) {
         obj->initInstanceIsa(cls, hasCxxDtor);
     } else {
         // Use raw pointer isa on the assumption that they might be
         // doing something weird with the zone or RR.
         obj->initIsa(cls);
     }

     if (fastpath(!hasCxxCtor)) {
         return obj;
     }

     construct_flags |= OBJECT_CONSTRUCT_FREE_ONFAILURE;
     return object_cxxConstructFromClass(obj, cls, construct_flags);
 
 }
 
 struct objc_class : objc_object {
 // 此处省略...
     inline size_t instanceSize(size_t extraBytes) const {
         if (fastpath(cache.hasFastInstanceSize(extraBytes))) {
             return cache.fastInstanceSize(extraBytes);
         }

         size_t size = alignedInstanceSize() + extraBytes;
         // CF requires all objects be at least 16 bytes.
         if (size < 16) size = 16;
         return size;
     }
 // 此处省略...
 }
 */
