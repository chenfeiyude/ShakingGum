

#import "MainScene.h"
#import "AdManager.h"
#import <CCTextureCache.h>

@implementation MainScene {
    AdManager *_adManager;
}

-(void) didLoadFromCCB {
    _adManager = [[AdManager alloc] init];
}

- (void)play
{
    CCScene *gameOverScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

-(void)onExit
{
    [super onExit];
    [_adManager hideAd];
    [self removeAllChildren];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

@end
