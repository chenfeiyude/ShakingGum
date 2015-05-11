

#import "MainScene.h"
#import "AdMobManager.h"
#import <CCTextureCache.h>

@implementation MainScene {
    AdMobManager *_adManager;
}

-(void) didLoadFromCCB {
    _adManager = [[AdMobManager alloc] init];
}

- (void)play
{
    CCScene *gameOverScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

- (void)help
{
    //TODO show the help box
    CCSprite *helpBox = (CCSprite*)[self getChildByName:@"HelpBox" recursively:true];
    helpBox.visible == YES? [helpBox setVisible:NO]:[helpBox setVisible:YES];
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
