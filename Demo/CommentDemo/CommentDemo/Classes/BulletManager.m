//
//  BulletManager.m
//  CommentDemo
//
//  Created by AngieMIta on 2017/8/18.
//  Copyright © 2017年 AngieMIta. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()

/** 弹幕的数据来源 */
@property (nonatomic, strong) NSMutableArray *datasource;

/** 弹幕使用过程中得变量 */
@property (nonatomic, strong) NSMutableArray *bulletComments;

/** 存储弹幕view的数组变量 */
@property (nonatomic, strong) NSMutableArray *bulletViews;

@property (nonatomic) BOOL bStopAnimation;
@end


@implementation BulletManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bStopAnimation = YES;
    }
    return self;
}


- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~",
                                                       @"弹幕222~~~22222222~~~22222",
                                                       @"弹幕3~~~",
                                                       @"弹幕44444~~~4444~~~44444",
                                                       @"弹幕5~~~",
                                                       @"弹幕666666~~~",
                                                       @"弹幕7~~~",
                                                       @"弹幕8~~~",
                                                       @"弹幕9~~~",
                                                       @"弹幕10~~~666666",
                                                       @"弹幕12~~~666666",
                                                       ]];
    }
    
    return _datasource;
}


- (NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

- (NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}


/** 弹幕开始执行 */
- (void)start{
    if (!self.bStopAnimation) {
        return;
    }
    
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.datasource];
    
    
    [self initBulleComment];
}

/** 弹幕停止执行 */
- (void)stop{
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

/** 初始化弹幕,随机分配弹幕轨迹 */
- (void)initBulleComment{
    NSMutableArray *trajectorys =  [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    
    for (int i = 0; i < 3; i++) {
        if (self.bulletComments.count > 0) {
            // 通过随机数渠道弹幕的轨迹
            NSInteger index = arc4random() % trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            // 从弹幕数组中逐一取出弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulleView:comment trajectory:trajectory];
        }
    }
}


- (void)createBulleView:(NSString *)comment trajectory:(int)trajectory{
    if (self.bStopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc]initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    
    
    __weak typeof (view) weakView = view;
    __weak typeof (self) myself = self;
    
    view.moveStatusBlock = ^(MoveStatus start) {
        if (self.bStopAnimation) {
            return;
        }
        switch (start) {
            case Start:
                // 弹幕开始进入屏幕,讲view加入弹幕管理的变量中bulletViews
                [myself.bulletViews addObject:weakView];
                break;
            case Enter:{
                // 将弹幕完全进入屏幕,判断是否还有其他内容,如果有则在改弹幕轨迹中创建一个弹幕
                NSString *comment = [self nextCommmet];
                if (comment) {
                    [self createBulleView:comment trajectory:trajectory];
                }
                break;
            }
            case End:{
                // 弹幕飞出屏幕后从bulletViews中删除,释放资源
                if ([myself.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [myself.bulletViews removeObject:weakView];
                }
                if (myself.bulletViews.count == 0) {
                    // 说明屏幕上已经没有弹幕了,开始循环滚蛋
                    self.bStopAnimation = YES;
                    [myself start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
    
    
}

- (NSString *)nextCommmet{
    if (self.bulletComments.count == 0) {
        return nil;
    }
    
    NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}


@end
