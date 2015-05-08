

#import "MainScene.h"
#import "AdManager.h"
#import <CCTextureCache.h>

@implementation MainScene {
//    AdManager *_adManager;
}

-(void) didLoadFromCCB {
//    _adManager = [[AdManager alloc] init];
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
//    [_adManager hideAd];
    [self removeAllChildren];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

@end
