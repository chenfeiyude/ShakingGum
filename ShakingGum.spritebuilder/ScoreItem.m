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
        [self addItemObj:[CCBReader load:@"ScoreItem"]];
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
    NSInteger randomValue = 1 + arc4random_uniform(9);//1 - 10
    [status setvalue: randomValue];
    
}

@end
