//
//  GameOver.m
//  ShakingGum
//
//  Created by chenfeiyu on 16/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

- (void)play
{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

@end
