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
static NSString* itemChildName = @"itemObj";

-(id)init
{
    self = [super init];
    
    if (self)
    {
        status = [[Status alloc] init];
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
    CGFloat width = CGRectGetWidth(screen);
    CGFloat height = CGRectGetHeight(screen);
    CCNode *itemObj = [self getChildByName:itemChildName recursively:false];
    width = arc4random_uniform(width - itemObj.boundingBox.size.width); // need to be improved
    self.position = CGPointMake(width, height); // initial item position
}

-(void) initSpeed{
    //set a random speed here
    CGFloat yDirection = -1.f;
    speed = CGPointMake(arc4random_uniform(20) * [self getRandomXDirection], yDirection * (arc4random_uniform(500) + 100));
}

-(BOOL) isDead {
    return isDead;
}

// this item is killed
-(void) killItem{
    isDead = YES;
}

-(void) move{
    CCNode *itemObj = [self getChildByName:itemChildName recursively:false];
    [itemObj.physicsBody applyForce: speed]; // give the item a speed, need to enable physics in spritbuilder
//    [itemObj.physicsBody applyImpulse:speed];// apply a velocity immediately
}

-(void) update: (CCTime) delta {
    [self move];
}

//get 1 for right and -1 for left direction
-(float) getRandomXDirection{
    float x_direction = arc4random_uniform(2);
    if (x_direction != 1.0f) {
        x_direction = -1.0f;
    }
    return x_direction;
}

-(id) getStatus {
    return status;
}

-(void) addItemObj: (CCNode*) itemObj
{
    if (itemObj != nil) {
        [itemObj.physicsBody setCollisionType:@"Item"];
        [itemObj.physicsBody setFriction:10.f];
        [itemObj.physicsBody setMass:10.f];
        [itemObj.physicsBody setAffectedByGravity:NO];
        [self addChild:itemObj z:0 name:itemChildName];
    }
}

@end
