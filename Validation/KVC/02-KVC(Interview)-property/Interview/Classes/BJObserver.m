//
//  BJObserver.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import "BJObserver.h"

@implementation BJObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    NSLog(@"observeValueForKeyPath - %@", change);
}

@end
