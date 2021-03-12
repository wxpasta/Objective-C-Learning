//
//  main.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "BJPet.h"
#import "BJObserver.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Q：通过KVC修改属性会触发KVO吗？
        // A：会触发KVO
        
        BJPet *pet = [[BJPet alloc] init];
        BJObserver *observer = [[BJObserver alloc] init];
        
        // 添加KVO监听
        [pet addObserver:observer
                 forKeyPath:@"weight"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        
        // 通过KVC修改age属性
        [pet setValue:@10 forKey:@"weight"];
        
        // 移除KVO监听
        [pet removeObserver:observer forKeyPath:@"weight"];
        
    }
    return 0;
}
