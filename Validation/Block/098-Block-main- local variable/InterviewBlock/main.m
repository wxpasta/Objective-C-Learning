//
//  main.m
//  InterviewBolck
//
//  Created by 巴糖 on 2021/3/22.
//

#import <Foundation/Foundation.h>

@interface Persion : NSObject

@property(nonatomic,assign) NSInteger age;

@end

@implementation Persion

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int age = 10;
        Persion *perisn = [[Persion alloc] init];
        perisn.age = 10;
        
        
        void(^blockName)(void) = ^() {
            NSLog(@"age %d", age);
            NSLog(@"perisn age %ld", perisn.age);
            
        };
        
        age = 30;
        perisn.age = 30;
        blockName();

    }
    return 0;
}
