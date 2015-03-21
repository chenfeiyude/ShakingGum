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
        CCLOG(@"Bomb created");
        [self initStatus];
        gameObj = [CCBReader load:@"Bomb"];
        [self initPosition];
        [self initSpeed];
    }
    
    return self;
}


-(void) crashing{
    // gum will be dead
    isDead = YES;
}

-(void) initStatus{
    if (status == nil) {
        status = [[Status alloc] init];
    }
    [status setStatus: DEAD];
}

@end
