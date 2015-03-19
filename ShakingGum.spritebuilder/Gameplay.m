//
//  Gameplay.m
//  ShakingGum
//
//  Created by Xiang Xu on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Gum.h"

@implementation Gameplay
{
    Gum *_gum;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
    self.userInteractionEnabled = TRUE;
    
    
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Touched");
}



@end
