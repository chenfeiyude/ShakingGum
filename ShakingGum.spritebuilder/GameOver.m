//
//  GameOver.m
//  ShakingGum
//
//  Created by chenfeiyu on 16/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"
//#import "AdManager.h"
#import "AdMobManager.h"
#import "ShareManager.h"
#import <CCTextureCache.h>
@implementation GameOver
{
//    AdManager *_adManager;
    AdMobManager *_adManager;
    CCLabelTTF *_finalScoreLabel;
    CCLabelTTF *_bestScoreLabel;
    
    NSInteger score;
    NSInteger bestScore;
    NSUserDefaults *defaults;
    
    ShareManager *shareManager;
}

- (void)didLoadFromCCB
{
    [self configureScore];
//    _adManager = [[AdManager alloc] init];
    _adManager = [[AdMobManager alloc] init];
    shareManager = [[ShareManager alloc] init:score];
}

- (void)configureScore
{
    // initialise user default
    defaults = [NSUserDefaults standardUserDefaults];
    
    // load the score from GamePlay scene
    score = [[NSUserDefaults standardUserDefaults] integerForKey:@"FinalScore"];
    
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"BestScore"])
    {
        // load the best score from user default
        bestScore = [defaults integerForKey:@"BestScore"];
    }
    else
    {
        // initialise best score at the fist time
        [defaults setInteger:0 forKey:@"BestScore"];
        [defaults synchronize];
    }
    
    // if current score is bigger than best score, then update best score
    if(score > bestScore)
    {
        [defaults setInteger:score forKey:@"BestScore"];
        [defaults synchronize];
        
        // read best score from use default again after update
        bestScore = [defaults integerForKey:@"BestScore"];
    }

    
    [_bestScoreLabel setString:[NSString stringWithFormat:@"x %ld", (long)bestScore]];
    [_finalScoreLabel setString:[NSString stringWithFormat:@"x %ld", (long)score]];
    
    
}

- (void)playAgain
{
    CCScene *gameOverScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

-(void)toHomePage
{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}


- (void)ShareOnTwitter
{
    [shareManager shareOnTwitter];
}

- (void)ShareOnFaceBook
{
    [shareManager shareOnFacebook];
}

- (void)ShareOnWeChat
{
    [shareManager shareOnWeChat];
}

- (void)ShareOnWeibo
{
    [shareManager shareOnWeibo];
}



-(void)onExit
{
    [super onExit];
    [_adManager hideAd];
    [self removeAllChildren];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    
    [defaults removeObjectForKey:@"FinalScore"];
    [defaults synchronize];
}

@end
