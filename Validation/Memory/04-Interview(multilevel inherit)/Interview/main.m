//
//  main.m
//  Interview
//
//  Created by 巴糖 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>


struct NSObject_IMPL {
    Class isa;
};

struct Person_IMPL {
    struct NSObject_IMPL NSObject_IVARS; // 8
    int _age; // 4
}; // 16 内存对齐：结构体的大小必须是最大成员大小的倍数

struct Student_IMPL {
    struct Person_IMPL Person_IVARS; // 16
    int _no; // 4
}; // 16



// Person
@interface Person : NSObject
{
    int _age;
}
@end

@implementation Person

@end

// Student
@interface Student : Person
{
    int _no;
}
@end

@implementation Student

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Student *stu = [[Student alloc] init];
        NSLog(@"stu - %zd", class_getInstanceSize([Student class]));
        NSLog(@"stu - %zd", malloc_size((__bridge const void *)stu));
        
        Person *person = [[Person alloc] init];
        NSLog(@"person - %zd", class_getInstanceSize([Person class]));
        NSLog(@"person - %zd", malloc_size((__bridge const void *)person));
    }
    return 0;
}
