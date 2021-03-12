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
        person->_age = 10;
        [person valueForKey:@"age"];
        NSLog(@"person.age = %@", [person valueForKey:@"age"]);
        
        BJPet *pet = [[BJPet alloc] init];
        pet->_weight = 20;
        [pet valueForKey:@"weight"];
        NSLog(@"pet.weight = %@", [pet valueForKey:@"weight"]);
        
    }
    return 0;
}
