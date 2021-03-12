//
//  BJPerson.h
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BJPet;

@interface BJPerson : NSObject

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, assign) BJPet *pet;

@end

NS_ASSUME_NONNULL_END
