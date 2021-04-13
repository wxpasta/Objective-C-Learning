//
//  BulletView.h
//  CommentDemo
//
//  Created by AngieMIta on 2017/8/18.
//  Copyright © 2017年 AngieMIta. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSInteger {
    Start,
    Enter,
    End,
} MoveStatus;

@interface BulletView : UIView

/** 弹道 */
@property (nonatomic, assign) int trajectory;

/** 弹幕状态回调 */
@property (nonatomic, copy) void (^moveStatusBlock)(MoveStatus start);


/**
 初始化弹幕

 @param comment 文字
 @return return value description
 */
- (instancetype)initWithComment:(NSString *)comment;


/** 开始动画 */
- (void)startAnimation;

/** 停止动画 */
- (void)stopAnimation;

@end
