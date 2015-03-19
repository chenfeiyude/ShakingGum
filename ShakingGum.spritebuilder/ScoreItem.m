//
//  ScoreItem.m
//  ShakingGum
//
//  Created by chenfeiyu on 19/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ScoreItem.h"

@implementation ScoreItem

-(id)init
{
    self = [super init];
    
    if (self)
    {
        CCLOG(@"ScoreItem created");
        [self initStatus];
        gameObj = [CCBReader load:@"ScoreItem"];
        [self initPosition];
        [self initSpeed];
    }
    
    return self;
}


-(void) crashing{
    // gum will be added score
    
}

-(void) initStatus{
    if (!status) {
        status = [[Status alloc] init];
    }
    [status setStatus: ADD_SCORE];
    [status setvalue: 10];// this value should be random later
}

@end
