//
//  BJPet.h
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPet : NSObject
// 顺序查找成员变量（条件+accessInstanceVariablesDirectly返回值为YES）
{
    int _weight; // first
    int _isWeight; // second
    int weight; // third
    int isWeight; // fourth
}

@end

NS_ASSUME_NONNULL_END
