//
//  main.m
//  Interview
//
//  Created by 巴糖 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 获得NSObject实例对象的成员变量所占用的大小 >> 8
        NSLog(@"%zd", class_getInstanceSize([NSObject class]));
        
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
