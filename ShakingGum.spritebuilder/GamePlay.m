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
#import "AdManager.h"
#import <CCTextureCache.h>
#import "AnimationManager.h"
@implementation GamePlay
{
    Gum *gum;
    
    ItemManager *_itemManager;
    
    CCPhysicsNode * _physicsNode;
    
    CCLabelTTF *_scoreLabel;
    
    CCLabelTTF *_timeLabel;
    
    CGPoint beginTouchLocation;
    
    AdManager *_adManager;
    
    SoundManager *_soundManager;
    
    AnimationManager *_animationManager;
    
    BOOL isGameOver;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
        isGameOver = false;
    }
    
    return self;
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
    
    _adManager = [[AdManager alloc] init];
    
    _animationManager = [[AnimationManager alloc] init: self];
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
    else {
        [self gameOver];
    }
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
                [_animationManager scoringAnimation:@"+1" scoreLabel:_scoreLabel];
                [_soundManager playScoringSound];
                
                break;
            case ADD_TIME:
                [_animationManager scoringAnimation:@"+5s" scoreLabel:_scoreLabel];
                [_soundManager playScoringSound];
                break;
            case REDUCE_TIME:
                // show -5s
                [_animationManager scoringAnimation:@"-5s" scoreLabel:_scoreLabel];
                [_soundManager playExplodingSound];
                
                break;
            case DEAD:
                // show dead!!
                [_animationManager scoringAnimation:@"Dead" scoreLabel:_scoreLabel];
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
    if (isGameOver == NO) {
        // show share and score
        [[NSUserDefaults standardUserDefaults] setInteger:[gum getScore] forKey:@"FinalScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_soundManager playGameEndSound];
        
        [_itemManager clearItems];
        CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOver"];
        
        // Hide the ad banner
        [_adManager hideAd];
        [[CCDirector sharedDirector] replaceScene:gameOverScene withTransition:[CCTransition transitionFadeWithDuration:3]];
        
        isGameOver = YES;
    }
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
