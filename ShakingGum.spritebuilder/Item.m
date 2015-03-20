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
        CGFloat height = CGRectGetHeight(screen);
        width = arc4random_uniform(width); // need to be improved
        CCLOG(@"position: %4.2f %4.2f ", width, height);
        gameObj.position = CGPointMake(width, height);
    }
}

-(void) initSpeed{
    //set a random speed here
    speed = arc4random_uniform(10) + 1; // avoid 0 speed
    
    [self schedule:@selector(move:) interval: 1.0f/60.0f];
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

-(id) getItem {
    return gameObj;
}

-(void) move: (CCTime) delta{
    if (gameObj != nil) {
        float x_direction = arc4random_uniform(2);
        if (x_direction != 1.0f) {
            x_direction = -1.0f;
        }
        CGPoint force = CGPointMake(arc4random_uniform(5) * x_direction, speed * -1);
//        [gameObj.physicsBody applyForce: force]; // give the item a speed
        gameObj.position = ccpAdd(gameObj.position, force);
    }
}

@end
