//
//  Item.h
//  ShakingGum
//
//  Created by chenfeiyu on 18/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Status.h"

@interface Item : CCSprite {
    Status * status;
    NSInteger speed;
    CCNode * gameObj;
}

-(id) init;
-(void) initPosition;
-(void) crashing; // abstract method, must be override in child classes
-(void) initStatus; // abstract method, must be override in child classes
-(void) initSpeed; 
@end
