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
        
        BJPerson *person = [[BJPerson alloc] init];
        // 以下两行代码等价
        // [person setValue:[NSNumber numberWithInt:30] forKey:@"age"];
        [person setValue:@30 forKey:@"age"];
        
        BJPet *pet = [[BJPet alloc]init];
        person.pet = pet;
        
        // -setValue:forKey:不支持路径
        [person setValue:@"man" forKey:@"gender"];
        // -setValue:forKeyPath:支持路径
        [person setValue:@10 forKeyPath:@"pet.weight"];
        
        // -valueForKey:不支持路径
        NSLog(@"person.age = %@", [person valueForKey:@"age"]);
        NSLog(@"person.gender = %@", [person valueForKey:@"gender"]);
        // -valueForKeyPath:支持路径
        NSLog(@"person.pet.weight = %@", [person valueForKeyPath:@"pet.weight"]);
        
    }
    return 0;
}
