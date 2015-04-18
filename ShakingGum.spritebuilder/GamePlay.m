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

@implementation GamePlay
{
    Gum *gum;
    
    ItemManager *itemManager;
    
    CCPhysicsNode * _physicsNode;
    
    CCLabelTTF *_scoreLabel;
    
    CCLabelTTF *_timeLabel;
    
    CGPoint beginTouchLocation;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{ 
    self.userInteractionEnabled = TRUE;
    
    // initialise Gum in GamePlay scene
    gum = [[Gum alloc] init];
    
    [_physicsNode addChild:gum];
    
    _physicsNode.collisionDelegate = self;
    
    itemManager = [ItemManager getInstance];
    
    [self schedule:@selector(addItems:) interval:1];

    [self schedule:@selector(reduceTime:) interval:1];
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
        [_scoreLabel setString:[NSString stringWithFormat:@"Score: %ld", (long)[gum getScore]]];
        [_timeLabel setString:[NSString stringWithFormat:@"Time: %ld s", (long)[gum getRemainTime]]];
    }
    else {
        // show share and score
        [[NSUserDefaults standardUserDefaults] setInteger:[gum getScore] forKey:@"FinalScore"];
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
    
    [itemManager deleteDeadItems];
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair GumHead:(CCNode *)gumHead Item:(CCNode *)itemObj
{
    NSLog(@"crashing gum head");
    return [self handleCollision:YES Item:itemObj];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair GumBody:(CCNode *)gumBody Item:(CCNode *)itemObj
{
    NSLog(@"crashing gum body");
    return [self handleCollision:NO Item:itemObj];
}

-(BOOL) handleCollision:(BOOL)isCrashingHead Item:(CCNode *)itemObj
{
    Item* item = (Item* ) itemObj.parent;
    
    // show exploding
    CCParticleSystem *exploding = [item crashing];
    exploding.position = [item convertToWorldSpace:itemObj.position];
    [self addChild:exploding];

    [gum handleItem:item isCrashingWithHead:isCrashingHead];
    switch (gum.getStatus.getStatus) {
        case ADD_SCORE:
            // show +1
            
            break;
        case REDUCE_TIME:
            // show -5s
            
            break;
        case DEAD:
            // show dead!!
            
            break;
        default:
            break;
    }
    [item killItem];
    return YES;
}

-(void) addItems:(CCTime)delta {
    //create items
    id newItem = [itemManager createRandomItem];
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
    CCScene *gameOverScene = [CCBReader loadAsScene:@"GameOver"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene withTransition:[CCTransition transitionFadeWithDuration:3]];
}
@end
