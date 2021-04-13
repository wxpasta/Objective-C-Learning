//
//  BulletView.m
//  CommentDemo
//
//  Created by AngieMIta on 2017/8/18.
//  Copyright © 2017年 AngieMIta. All rights reserved.
//

#import "BulletView.h"


#define Padding 10
#define PhotoHeight 30

@interface BulletView()

/** 弹幕Label */
@property (nonatomic, strong) UILabel *lblComment;
@property (nonatomic, strong) UIImageView *photoIgv;

@end

@implementation BulletView


/**
 初始化弹幕
 
 @param comment 文字
 @return return value description
 */
- (instancetype)initWithComment:(NSString *)comment{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 10;
        
        // 计算弹幕的实际宽高
        NSDictionary *arr = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        
        CGFloat width = [comment sizeWithAttributes:arr].width;
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoHeight, 30);
        
        self.lblComment.text = comment;
        self.lblComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        
        self.photoIgv.frame = CGRectMake(-Padding, -Padding, Padding + PhotoHeight, PhotoHeight + Padding);
        self.photoIgv.layer.cornerRadius = (PhotoHeight + Padding) / 2;
        self.photoIgv.layer.borderColor = [UIColor redColor].CGColor;
        self.photoIgv.layer.borderWidth = 1;
        self.photoIgv.image = [UIImage imageNamed:@"20121103181942-1429153779"];
    }
    return self;
}


/** 开始动画 */
- (void)startAnimation{
    
    // 根据弹幕长度执行动画效果
    // 根据v = s/t,时间相同情况下,距离越长,速度就越快
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    
    // 弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    
    // t = s/v
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;

    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         frame.origin.x -= wholeWidth;
                         self.frame = frame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         
                         // 弹幕结束
                         if (self.moveStatusBlock) {
                             self.moveStatusBlock(End);
                         }
                     }];
}

/** 停止动画 */
- (void)stopAnimation{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    
    
}


-(UILabel *)lblComment{
    if (!_lblComment) {
        _lblComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _lblComment.font = [UIFont systemFontOfSize:14];
        _lblComment.textColor = [UIColor whiteColor];
        _lblComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lblComment];
    }
    return _lblComment;
}

- (void)enterScreen{
    // 弹幕
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}

- (UIImageView *)photoIgv{
    if (!_photoIgv) {
        _photoIgv = [UIImageView new];
        _photoIgv.clipsToBounds = YES;
        _photoIgv.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_photoIgv];
    }
    return _photoIgv;
}


@end
