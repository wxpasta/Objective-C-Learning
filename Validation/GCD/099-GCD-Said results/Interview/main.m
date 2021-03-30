//
//  main.m
//  InterviewGCD
//
//  Created by 巴糖 on 2021/3/22.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"任务1");
        dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            NSLog(@"任务2");
            dispatch_sync(queue, ^{
                NSLog(@"任务3");
            });
            NSLog(@"任务4.");
        });
        NSLog(@"任务5");
        

    }
    return 0;
}
