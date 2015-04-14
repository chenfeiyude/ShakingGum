//
//  Bomb.m
//  ShakingGum
//
//  Created by chenfeiyu on 19/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb


-(id)init
{
    self = [super init];
    
    if (self)
    {
//        CCLOG(@"Bomb created");
        [self initStatus];
        [self addItemObj:[CCBReader load:@"Bomb"]];
        [self initPosition];
        [self initSpeed];
    }
    
    return self;
}


-(id) crashing{
    // gum will be dead
    isDead = YES;
    CCParticleSystem *exploding = (CCParticleSystem *)[CCBReader load:@"exploding"];
    exploding.position = self.position;
    exploding.autoRemoveOnFinish = YES;
    exploding.visible = YES;
    return exploding;
}

-(void) initStatus{
    if (status == nil) {
        status = [[Status alloc] init];
    }
    [status setStatus: DEAD];
}

@end
