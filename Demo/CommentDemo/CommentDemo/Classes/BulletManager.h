//
//  BulletManager.h
//  CommentDemo
//
//  Created by AngieMIta on 2017/8/18.
//  Copyright © 2017年 AngieMIta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BulletView;

@interface BulletManager : NSObject

/** 弹幕状态回调 */
@property (nonatomic, copy) void (^generateViewBlock)(BulletView *view);

/** 弹幕开始执行 */
- (void)start;

/** 弹幕停止执行 */
- (void)stop;





@end
