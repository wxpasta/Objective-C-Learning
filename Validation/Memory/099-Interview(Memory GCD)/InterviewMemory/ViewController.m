//
//  ViewController.m
//  InterviewMemory
//
//  Created by 巴糖 on 2021/3/26.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *name;

@end

@implementation ViewController

// MRC 管理一个name属性
//- (void)setName:(NSString *)name {
//    if (_name != name) {
//        [_name release];
//        _name = [name retain];
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // [self method1];
    // [self method2];
    
}

// 内存管理-对象
- (void)method1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            // 加锁
            self.name = [NSString stringWithFormat:@"abcdefghijk"];
            // 解锁
        });
    }
}

// 内存管理-地址（Tagged Pointer）
- (void)method2 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 1000; i++) {
        dispatch_async(queue, ^{
            self.name = [NSString stringWithFormat:@"abc"];
        });
    }
}




@end
