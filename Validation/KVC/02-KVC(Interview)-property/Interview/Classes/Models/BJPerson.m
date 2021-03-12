//
//  BJPerson.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import "BJPerson.h"

@implementation BJPerson

- (void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
    
    NSLog(@"BJPerson - willChangeValueForKey - %@", key);
}

- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"BJPerson - didChangeValueForKey - begin - %@", key);
    
    [super didChangeValueForKey:key];
    
    NSLog(@"BJPerson - didChangeValueForKey - end - %@", key);
}

@end
