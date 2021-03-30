//
//  ViewController+Test.h
//  iOSInterviewBlock
//
//  Created by 巴糖 on 2021/3/22.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController (Test)

@property (nonatomic, assign) int  weight;

// Property 'weight' requires method 'weight' to be defined
// - use @dynamic or provide a method implementation in this category
// 属性'weight'需要定义方法'weight'
// - 使用@dynamic或在这个类别中提供一个方法实现

// Property 'weight' requires method 'setWeight:' to be defined
// - use @dynamic or provide a method implementation in this category
// 属性'weight'需要定义方法'setWeight:'
// - 使用@dynamic或在这个类别中提供一个方法实现

// 类别自动生成setter、getter方法声明，但是不会生成方法的具体实现
// 编译可以通过，无报错提示，只有警告⚠️
// 程序运行起来，不使用weight的setter和getter方法，不会出现crash。

@end

NS_ASSUME_NONNULL_END
