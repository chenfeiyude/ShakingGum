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
    BOOL isDead;
    BOOL isCrashing;
}

-(id) init;
-(void) initPosition;
-(id) crashing; // abstract method, must be override in child classes
-(void) initStatus; // abstract method, must be override in child classes
-(void) initSpeed;
-(BOOL) isDead; // check whether this item is dead or not
-(void) killItem;//kill this item
-(void) move;
-(id) getStatus;
@end
