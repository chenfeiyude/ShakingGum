//
//  SoundManager.h
//  ShakingGum
//
//  Created by Xiang Xu on 23/04/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SoundManager : AVAudioPlayer

- (void)playScoringSound;
- (void)playExplodingSound;
- (void)playGameEndSound;
@end
