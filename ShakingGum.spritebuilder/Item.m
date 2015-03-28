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
        status = [[Status alloc] init];
        [self initSpeed];
        isDead = NO;
        //need to load the obj in child classes
        //e.g [self addChild:[CCBReader load:@"Bomb"]];
        
    }
    
    return self;
}

-(id) crashing{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(void) initStatus{
    [self doesNotRecognizeSelector:_cmd];
}

-(void) initPosition{
    //init a random position here
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat width = CGRectGetWidth(screen) / 2;
    CGFloat height = CGRectGetHeight(screen);
    width = arc4random_uniform(width); // need to be improved
    self.position = CGPointMake(width * [self getRandomDirection], height); // initial item position
}

-(void) initSpeed{
    //set a random speed here
    speed = arc4random_uniform(10) + 1; // avoid 0 speed
    [self move];
}

-(BOOL) isDead {
    if (isDead) {
        return YES;
    }
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (self.position.y >= CGRectGetHeight(screen)) {
        //this item is out of screen
        return YES;
    }
    return NO;
}

// this item is killed
-(void) killItem{
    isDead = YES;
    [self removeFromParentAndCleanup:YES];
}

-(void) move{
    CGPoint force = CGPointMake(arc4random_uniform(20) * [self getRandomDirection], speed * -1);
    [self.physicsBody applyForce: force]; // give the item a speed, need to enable physics in spritbuilder
}

//get 1 for right and -1 for left direction
-(float) getRandomDirection{
    float x_direction = arc4random_uniform(2);
    if (x_direction != 1.0f) {
        x_direction = -1.0f;
    }
    return x_direction;
}

-(id) getStatus {
    return status;
}

@end
