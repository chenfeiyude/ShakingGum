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
        CGFloat width = CGRectGetWidth(screen) / 2;
        CGFloat height = CGRectGetHeight(screen);
        width = arc4random_uniform(width); // need to be improved
        gameObj.position = CGPointMake(width * [self getRandomDirection], height); // initial item position
    }
}

-(void) initSpeed{
    //set a random speed here
    speed = arc4random_uniform(10) + 1; // avoid 0 speed
    
//    [self schedule:@selector(move:) interval: 1.0f/60.0f];
    [self move];
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

// this item is killed
-(void) killItem{
    isDead = YES;
}

-(id) getItem {
    return gameObj;
}

//-(void) move: (CCTime) delta{
//    if (gameObj != nil) {
//        CGPoint force = CGPointMake(arc4random_uniform(20) * [self getRandomDirection], speed * -1);
//        gameObj.position = ccpAdd(gameObj.position, force);
//    }
//}

-(void) move{
    if (gameObj != nil) {
        CGPoint force = CGPointMake(arc4random_uniform(20) * [self getRandomDirection], speed * -1);
        [gameObj.physicsBody applyForce: force]; // give the item a speed, need to enable physics in spritbuilder
    }
}

//get 1 for right and -1 for left direction
-(float) getRandomDirection{
    float x_direction = arc4random_uniform(2);
    if (x_direction != 1.0f) {
        x_direction = -1.0f;
    }
    return x_direction;
}

@end
