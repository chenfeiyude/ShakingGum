//
//  Item.m
//  ShakingGum
//
//  Created by chenfeiyu on 18/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)init
{
    self = [super init];
    
    if (self)
    {
        CCLOG(@"Item created");
        status = [[Status alloc] init];
        [self initSpeed];
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
    if (gameObj) {
        //e.g gameObj.position = ***********************
    }
}

-(void) initSpeed{
    //set a random speed here
    speed = 0;
}

@end
