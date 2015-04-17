//
//  GameOver.m
//  ShakingGum
//
//  Created by chenfeiyu on 16/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver
{
    CCLabelTTF *_finalScore;
}

- (void)didLoadFromCCB
{
    NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:@"FinalScore"];
    [_finalScore setString:[NSString stringWithFormat:@"Score: %ld", (long)score]];

}

- (void)playAgain
{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

- (void)ShareToFaceBook
{
    NSLog(@"share to facebook");
}

@end
