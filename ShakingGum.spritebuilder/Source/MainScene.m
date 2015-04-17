

#import "MainScene.h"

@implementation MainScene

- (void)play
{
    CCScene *gameOverScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

@end
