//
//  BJPet.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import "BJPet.h"

@implementation BJPet

- (void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
    
    NSLog(@"BJPet - willChangeValueForKey - %@", key);
}

- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"BJPet - didChangeValueForKey - begin - %@", key);
    
    [super didChangeValueForKey:key];
    
    NSLog(@"BJPet - didChangeValueForKey - end - %@", key);
}

@end
