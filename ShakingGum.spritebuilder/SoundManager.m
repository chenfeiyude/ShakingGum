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
    NSMapTable *players;
    
    NSString *KEY_SOCRE;
    NSString *KEY_EXPLODE;
    NSString *KEY_DEAD;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        KEY_SOCRE   = @"scoreSound";
        KEY_EXPLODE = @"explodeSound";
        KEY_DEAD    = @"deadSound";
        players = [NSMapTable new];
        [self addSoundSource:@"ScoreSound" type:@"wav" name:KEY_SOCRE];
        [self addSoundSource:@"ExplodeSound" type:@"wav" name:KEY_EXPLODE];
        [self addSoundSource:@"GameEndingSound" type:@"wav" name:KEY_DEAD];
    }
    
    return self;
}

-(void) addSoundSource : (NSString*) path type:(NSString*)sourceType name:(NSString*)name
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:path ofType:sourceType];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    
    [players setObject:player forKey:name];
}

- (void)playScoringSound
{
    [(AVAudioPlayer*)[players objectForKey:KEY_SOCRE] play];
}

- (void)playExplodingSound
{
    [(AVAudioPlayer*)[players objectForKey:KEY_EXPLODE] play];
}

- (void)playGameEndSound
{
    [(AVAudioPlayer*)[players objectForKey:KEY_DEAD] play];
}

-(void)stopAllSound
{
    if (players != nil) {
        for (id player in players) {
            [player stop];
        }
    }
}

-(void)dealloc
{
    if (players != nil) {
        [self stopAllSound];
        [players removeAllObjects];
    }
}

@end
