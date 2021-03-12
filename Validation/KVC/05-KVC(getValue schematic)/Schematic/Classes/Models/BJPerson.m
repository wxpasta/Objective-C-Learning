//
//  BJPerson.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import "BJPerson.h"

@implementation BJPerson

// 优先查找 getAge
//- (int)getAge {
//    return 11;
//}
// 其次查找 age
//- (int)age {
//    return 12;
//}
// 再次查找 isAge
//- (int)isAge {
//    return 13;
//}
// 最后查找 _age
- (int)_age {
    return 14;
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
