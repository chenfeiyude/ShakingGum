//
//  TimeItem.m
//  ShakingGum
//
//  Created by chenfeiyu on 24/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TimeItem.h"

@implementation TimeItem
-(id)init
{
    self = [super init];
    
    if (self)
    {
        [self initStatus];
        [self addItemObj:[CCBReader load:@"TimeItem"]];
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
    [status setStatus: ADD_TIME];
    NSInteger value = 5;
    [status setvalue: value];
    
}
@end
