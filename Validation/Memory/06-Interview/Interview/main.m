//
//  main.m
//  Interview
//
//  Created by 巴糖 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>
#import <objc/runtime.h>

//struct NSObject_IMPL
//{
//    Class isa;
//};
//
//struct Person_IMPL
//{
//    struct NSObject_IMPL NSObject_IVARS; // 8
//    int _age; // 4
//    int _height; // 4
//    int _no; // 4
//}; // 24

struct NSObject_IMPL {
    Class isa;
};

struct Person_IMPL {
    struct NSObject_IMPL NSObject_IVARS;
    int _age;
    int _height;
    int _no;
}; // 计算结构体大小，内存对齐，24

//struct MJStudent_IMPL
//{
//    struct Person_IMPL Person_IVARS;
//    int _weight;
//};

@interface Person : NSObject
{
    int _age;
    int _height;
    int _no;
}
@end

//@interface MJStudent : Person
//{
//    int _weight;
//}
//@end

@implementation Person

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Person *p = [[Person alloc] init];
        
        NSLog(@"%zd", sizeof(struct Person_IMPL)); // 24
        
        NSLog(@"%zd %zd",
              class_getInstanceSize([Person class]), // 24
              malloc_size((__bridge const void *)(p))); // 32
    }
    return 0;
}

