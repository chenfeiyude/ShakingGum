//
//  Gameplay.m
//  ShakingGum
//
//  Created by Xiang Xu on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import "UITouch+CC.h"
#import "Gum.h"
#import "ItemManager.h"
#import "Item.h"
#import "Bomb.h"
#import "ScoreItem.h"
#import "SoundManager.h"

#import "AppDelegate.h"
#import <CCTextureCache.h>

@implementation GamePlay
{
    Gum *gum;
    
    ItemManager *_itemManager;
    
    CCPhysicsNode * _physicsNode;
    
    CCLabelTTF *_scoreLabel;
    
    CCLabelTTF *_timeLabel;
    
    CGPoint beginTouchLocation;

    ADBannerView *_adBannerView;
    
    SoundManager *_soundManager;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{ 
    self.userInteractionEnabled = TRUE;
    
    // initialise Gum in GamePlay scene
    gum = [[Gum alloc] init];
    
    [_physicsNode addChild:gum];
    _physicsNode.collisionDelegate = self;
    
    _itemManager = [ItemManager getInstance];
    
    [self schedule:@selector(addItems:) interval:1];

    [self schedule:@selector(reduceTime:) interval:1];
    
    _soundManager = [[SoundManager alloc] init];
    
    // iAd initialise
    _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _adBannerView.delegate = self;
    
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    CGRect frame = _adBannerView.frame;
    frame.origin.y = screenSize.height-_adBannerView.frame.size.height;
    NSLog(@"height: %f" , _adBannerView.frame.size.height);
    frame.origin.x = 0.0f;
    
    _adBannerView.frame = frame;
    
    [_adBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    AppController *app = (((AppController*) [UIApplication sharedApplication].delegate));
    [app.navController.view addSubview:_adBannerView];
}



-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:gum];
    beginTouchLocation = touchLocation;
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:gum];
    CGPoint direction = CGPointMake(touchLocation.x - beginTouchLocation.x, touchLocation.y - beginTouchLocation.y);
    
    [gum move:direction beginTouchLocation:beginTouchLocation];
}


// This method is running every frame
- (void)update:(CCTime)delta {
    if ([[gum getStatus] getStatus] != DEAD) {
        [_scoreLabel setString:[NSString stringWithFormat:@"x %ld", (long)[gum getScore]]];
        [_timeLabel setString:[NSString stringWithFormat:@"Time: %ld s", (long)[gum getRemainTime]]];
    }
    else {
        // show share and score
        [[NSUserDefaults standardUserDefaults] setInteger:[gum getScore] forKey:@"FinalScore"];
        [_soundManager playGameEndSound];
        [self performSelector:@selector(gameOver) withObject:nil afterDelay:0.3];//call gameOver method after delay
    }
    
    // do every thing for the items here
    for (id obj in _physicsNode.children) {
        if ([obj isKindOfClass:[Item class]]) {
            Item* item = (Item* ) obj;
            for (CCNode * itemObj in item.children) {
                //check dead items here -------------------
                if ([item convertToWorldSpace:itemObj.position].y <= 0) {
                    //delete all items out of screen
                    [item killItem];
                }

            }
        }
        
    }
    
    [_itemManager deleteDeadItems];
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair GumHead:(CCNode *)gumHead Item:(CCNode *)itemObj
{
    return [self handleCollision:YES Item:itemObj];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair GumBody:(CCNode *)gumBody Item:(CCNode *)itemObj
{
    return [self handleCollision:NO Item:itemObj];
}

-(BOOL) handleCollision:(BOOL)isCrashingHead Item:(CCNode *)itemObj
{
    Item* item = (Item* ) itemObj.parent;
    
    if ([item isKindOfClass:[Bomb class]] || isCrashingHead) {
        // show exploding when crash with head or item is a bomb
        CCParticleSystem *exploding = [item crashing];
        exploding.position = [item convertToWorldSpace:itemObj.position];
        [self addChild:exploding];
        [gum handleItem:item isCrashingWithHead:isCrashingHead];
        switch (gum.getStatus.getStatus) {
            case ADD_SCORE:
                // show +1
                [self scoringAnimation:@"+1"];
                [_soundManager playScoringSound];
                
                break;
            case ADD_TIME:
                [self scoringAnimation:@"+5s"];
                [_soundManager playScoringSound];
                break;
            case REDUCE_TIME:
                // show -5s
                [self scoringAnimation:@"-5s"];
                [_soundManager playExplodingSound];
                
                break;
            case DEAD:
                // show dead!!
                [self scoringAnimation:@"Dead"];
                [_soundManager playGameEndSound];
                
                break;
            default:
                break;
        }
        [item killItem];
    }
    return YES;
}

-(void) addItems:(CCTime)delta {
    //create items
    id newItem = [_itemManager createRandomItem];
    if (newItem != nil) {
        [_physicsNode addChild:newItem];
    }
}

-(void) reduceTime:(CCTime)delta {
    //reduce game time
    [gum reduceTime:delta];
}

-(void) gameOver
{
    [_itemManager clearItems];
    CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOver"];
    
    // Hide the ad banner
    _adBannerView.alpha = 0.0;
    [[CCDirector sharedDirector] replaceScene:gameOverScene withTransition:[CCTransition transitionFadeWithDuration:3]];
}

- (void)scoringAnimation: (NSString *)message
{
    CCLabelTTF *_scoreSignLabel = [[CCLabelTTF alloc] initWithString:message fontName:@"MarkerFelt-Wide" fontSize:25.0];
    _scoreSignLabel.fontColor = _scoreLabel.fontColor;
    
    
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    _scoreSignLabel.position = ccp(screenSize.width/2, screenSize.height/2 + 30);
    
    [self addChild:_scoreSignLabel];
    
    CCActionCallBlock *showContent = [CCActionCallBlock actionWithBlock:^
    {
        [_scoreSignLabel setString:message];
    }];
    
    CCActionMoveBy *moveUp = [CCActionMoveBy actionWithDuration:0.5 position:CGPointMake(0, 20.0)];
    CCActionMoveBy *moveDown = [CCActionMoveBy actionWithDuration:0 position:CGPointMake(0, -10.0)];
 
    
    CCActionCallBlock *hideContent= [CCActionCallBlock actionWithBlock:^
    {
        [_scoreSignLabel setString:@""];
    }];
    
    CCActionCallBlock *remvoeLabel = [CCActionCallBlock actionWithBlock:^
    {
        [self removeChild:_scoreSignLabel];
    }];

   
    CCActionSequence *sequence = [CCActionSequence actionWithArray: @[showContent, moveUp, hideContent, moveDown, remvoeLabel]];
    [_scoreSignLabel runAction:sequence];
}

#pragma mark iAd Delegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    // Hide the ad banner.
    [UIView animateWithDuration:0.5 animations:^
    {
        _adBannerView.alpha = 0.0;
    }];
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // Hide the ad banner.
    [UIView animateWithDuration:0.5 animations:^
    {
        _adBannerView.alpha = 0.0;
    }];
}

-(void)onExit
{
    [super onExit];
    [_physicsNode removeAllChildren];
    [self removeAllChildren];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
}


@end
