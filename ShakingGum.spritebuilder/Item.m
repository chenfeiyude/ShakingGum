//
//  Item.m
//  ShakingGum
//
//  Created by chenfeiyu on 18/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Item.h"
#include <stdlib.h>

@implementation Item

-(id)init
{
    self = [super init];
    
    if (self)
    {
        CCLOG(@"Item created");
        status = [[Status alloc] init];
        [self initSpeed];
        isDead = NO;
        //need to init a gameobj in child classes
        //e.g gameObj = [CCBReader load:@"Bomb"];
        
    }
    
    return self;
}

-(void) crashing{
    [self doesNotRecognizeSelector:_cmd];
}

-(void) initStatus{
    [self doesNotRecognizeSelector:_cmd];
}

-(void) initPosition{
    //init a random position here
    if (gameObj != nil) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat width = CGRectGetWidth(screen);
        width = width * arc4random_uniform(100) / 100; // need to be improved
        gameObj.position = CGPointMake(width, 0.0f);
    }
}

-(void) initSpeed{
    //set a random speed here
    speed = 10 * arc4random_uniform(10);
    
    if (gameObj != nil) {
        float direction = arc4random_uniform(2);
        if (direction != 1.0f) {
            direction = -1.0f;
        }
        CGPoint itemOffset = CGPointMake(arc4random_uniform(10) * direction, speed);
        gameObj.position = ccpAdd(gameObj.position, itemOffset);
    }
}

-(BOOL) isDead {
    if (isDead) {
        return YES;
    }
    if (gameObj != nil) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        if (gameObj.position.y >= CGRectGetHeight(screen)) {
            //this item is out of screen
            return YES;
        }
    }
    return NO;
}

-(void) killItem{
    isDead = YES;
}

@end
