//
//  main.m
//  BaseKVC
//
//  Created by 巴糖 on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import "BJPerson.h"
#import "BJPet.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 案例一
        BJPerson *person = [[BJPerson alloc] init];
        // 通过KVC修改age属性
        [person setValue:@10 forKey:@"age"];
        
        
        BJPet *pet = [[BJPet alloc] init];
        [pet setValue:@10 forKey:@"weight"];
        
    }
    return 0;
}
