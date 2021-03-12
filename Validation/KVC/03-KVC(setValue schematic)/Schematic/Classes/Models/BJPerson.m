//
//  BJPerson.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import "BJPerson.h"

@implementation BJPerson

// 优先查找setKey
//- (void)setAge:(int)age {
//    NSLog(@"setAge: - %d", age);
//}

// 其次查找_setKey
- (void)_setAge:(int)age {
    NSLog(@"_setAge: - %d", age);
}

// 没有setKey、_setKey进入accessInstanceVariablesDirectly方法
// 默认的返回值就是YES,访问成员变量
+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}


/*
 * 最终抛出异常
 *** Terminating app due to uncaught exception 'NSUnknownKeyException', reason: '[<BJPerson 0x101832d60> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key age.'
 */
@end
