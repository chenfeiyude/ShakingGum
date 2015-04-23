//
//  SoundManager.m
//  ShakingGum
//
//  Created by Xiang Xu on 23/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager
{
    NSString *soundPath;
    NSURL *soundURL;
    AVAudioPlayer *player;
}


- (void)playScoringSound
{
    soundPath = [[NSBundle mainBundle] pathForResource:@"ScoreSound" ofType:@"wav"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    [player play];
}

- (void)playExplodingSound
{
    soundPath = [[NSBundle mainBundle] pathForResource:@"ExplodeSound" ofType:@"wav"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    [player play];
}

- (void)playGameEndSound
{
    soundPath = [[NSBundle mainBundle] pathForResource:@"GameEndingSound" ofType:@"wav"];
    soundURL = [NSURL fileURLWithPath:soundPath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    [player play];
}


@end
