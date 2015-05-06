//
//  AnimationManager.m
//  ShakingGum
//
//  Implemented by XiangXu
//  Created by chenfeiyu on 06/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager

-(id)init : (CCNode *) newScene
{
    self = [super init];
    
    if (self)
    {
        scene = newScene;
    }
    
    return self;
}

- (void)scoringAnimation: (NSString *)message scoreLabel: (CCLabelTTF *)scoreLabel
{
    CCLabelTTF *_scoreSignLabel = [[CCLabelTTF alloc] initWithString:message fontName:@"MarkerFelt-Wide" fontSize:25.0];
    _scoreSignLabel.color = scoreLabel.color;
    
    
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    _scoreSignLabel.position = ccp(screenSize.width/2, screenSize.height/2 + 30);
    
    [scene addChild:_scoreSignLabel];
    
    CCActionCallBlock *showContent = [CCActionCallBlock actionWithBlock:^
                                      {
                                          [_scoreSignLabel setString:message];
                                      }];
    
    CCActionMoveBy *moveUp = [CCActionMoveBy actionWithDuration:0.5 position:CGPointMake(0, 40.0)];
    CCActionMoveBy *moveDown = [CCActionMoveBy actionWithDuration:0 position:CGPointMake(0, -10.0)];
    
    
    CCActionCallBlock *hideContent= [CCActionCallBlock actionWithBlock:^
                                     {
                                         [_scoreSignLabel setString:@""];
                                     }];
    
    CCActionCallBlock *remvoeLabel = [CCActionCallBlock actionWithBlock:^
                                      {
                                          [scene removeChild:_scoreSignLabel];
                                      }];
    
    
    CCActionSequence *sequence = [CCActionSequence actionWithArray: @[showContent, moveUp, hideContent, moveDown, remvoeLabel]];
    [_scoreSignLabel runAction:sequence];
}
@end
