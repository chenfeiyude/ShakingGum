//
//  Gum.m
//  ShakingGum
//
//  Created by Xiang Xu on 21/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gum.h"

@implementation Gum
{
    CCNode *_gumHead;
    CCNode *_gumBody;
    CCNode *_gumBase;
    
    NSInteger score;
    Status* status;
}


-(id)init{
    self = [super init];
    
    if(self)
    {
        NSLog(@"Gum initialised");
        [self initStatus];
    }
    
    return self;
}

-(void) initStatus{
    if (status == nil) {
        status = [[Status alloc] init];
    }
    [status setStatus: INIT];
}

-(CCNode *)getGumHead
{
    return _gumHead;
}

-(CCNode *)getGumBody
{
    return _gumBody;
}

-(CCNode *)getGumBase
{
    return _gumBase;
}

-(NSInteger) getScore
{
    return score;
}

-(Status *) getStatus
{
    return status;
}

-(void) handleItem : (Item *) item
{
    Status* itemStatus = item.getStatus;
    [status setStatus:[itemStatus getStatus]];
    score += [[item getStatus] getValue];
    NSLog(@"Gum status changed to %ld (1:DEAD 2:ADD_SCORE)", (long)[status getStatus]);
}

@end
