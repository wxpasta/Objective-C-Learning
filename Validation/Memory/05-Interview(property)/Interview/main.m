//
//  main.m
//  Interview
//
//  Created by 巴糖 on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

/*
 
struct Person_IMPL {
    struct NSObject_IMPL NSObject_IVARS;
    int _age;
    int _height;
};
*/

// Person
@interface Person : NSObject
{
    @public
    int _age;
}
@property (nonatomic, assign) int height;
@end

@implementation Person

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {

        Person *person = [[Person alloc] init];
        [person setHeight:10];
        [person height];
        person->_age = 20;
    
        NSLog(@"person - %zd", class_getInstanceSize([Person class]));
        NSLog(@"person - %zd", malloc_size((__bridge const void *)person));
    }
    return 0;
}

