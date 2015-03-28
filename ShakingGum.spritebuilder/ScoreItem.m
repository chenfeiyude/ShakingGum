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
        [self initStatus];
        [self addChild:[CCBReader load:@"ScoreItem"]];
        [self initPosition];
        [self initSpeed];
    }
    
    return self;
}


-(id) crashing{
    // gum will be added score
    isDead = YES;
    CCParticleSystem *exploding = (CCParticleSystem *)[CCBReader load:@"exploding"];
    exploding.position = self.position;
    exploding.autoRemoveOnFinish = TRUE;
    return exploding;
}

-(void) initStatus{
    if (status == nil) {
        status = [[Status alloc] init];
    }
    [status setStatus: ADD_SCORE];
    [status setvalue: 10];// this value should be random later
}

@end
