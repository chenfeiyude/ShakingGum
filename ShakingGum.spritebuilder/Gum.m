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
}

-(id)init{
    self = [super init];
    
    if(self)
    {
        NSLog(@"Gum initialised");
    }
    
    return self;
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

@end
