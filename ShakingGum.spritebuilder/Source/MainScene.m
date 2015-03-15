

#import "MainScene.h"

@implementation MainScene

- (void)play
{
    CCScene *gamePlayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlayScene];
}

@end
