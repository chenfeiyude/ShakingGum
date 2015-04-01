//
//  Gameplay.m
//  ShakingGum
//
//  Created by Xiang Xu on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "UITouch+CC.h"
#import "Gum.h"
#import "ItemManager.h"
#import "Item.h"
#import "Bomb.h"
#import "ScoreItem.h"

@implementation Gameplay
{
    Gum *_gum;
    
    ItemManager *itemManager;
    
    CCPhysicsNode * _physicsNode;
    
    int score;
    CCLabelTTF *_scoreLabel;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
 
    self.userInteractionEnabled = TRUE;
    
    // initialise Gum in GamePlay scene
    _gum = (Gum *)[CCBReader load:@"Gum"];
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    _gum.scale = (0.5);
    
    [_physicsNode addChild:_gum];
    _gum.position = CGPointMake(screenSize.width/2, -100);

    _physicsNode.debugDraw = TRUE;
    itemManager = [ItemManager getInstance];
    
    [_gum getGumHead].physicsBody.collisionType = @"GumHead";
    _physicsNode.collisionDelegate = self;
    
    [self schedule:@selector(addItems:) interval:1];
    
}

-(void) updateScore
{
    score += 1;
    [_scoreLabel setString:[NSString stringWithFormat:@"Score: %d", score]];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_gum];
    
    NSLog(@"Touched loaction: %@", NSStringFromCGPoint(touchLocation));

    // when a touch insdie of the Gum body occurs
    if (CGRectContainsPoint([[_gum getGumHead] boundingBox], touchLocation))
    {
    
    }
    
    if(CGRectContainsPoint([[_gum getGumBody] boundingBox], touchLocation))
    {
    }
    
    if(CGRectContainsPoint([[_gum getGumBase] boundingBox], touchLocation))
    {
    }
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_gum];
    
    // start Gum dragging when a touch insdie of the Gum body occurs
    if (CGRectContainsPoint([[_gum getGumHead] boundingBox], touchLocation))
    {
        [_gum getGumHead].position = touchLocation;
    }
    
    if(CGRectContainsPoint([[_gum getGumBody] boundingBox], touchLocation))
    {
        [_gum getGumBody].position = touchLocation;
    }
    
    if(CGRectContainsPoint([[_gum getGumBase] boundingBox], touchLocation))
    {
    }
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair GumHead:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
//    CCLOG(@"Something collided with GumHead!");
//
//    for (id obj in _physicsNode.children) {
//        if ([obj isKindOfClass:[Item class]]) {
//            Item* item = (Item* ) obj;
//            
//            //check crashing here --------------------
//            if (CGRectIntersectsRect(item.boundingBox, [[_gum getGumHead] boundingBox]))
//            {
//                NSLog(@"crashing");
//                
//                CCParticleSystem *exploding = [item crashing];
//                exploding.position = [_gum convertToWorldSpace:item.position];
//                
//                [self addChild:exploding];
//                //
//                //            [item getStatus];// add status to gum
//                [item killItem];
//                [item removeFromParentAndCleanup:YES];
//                
//                [self updateScore];
//                
//                break;
//            }
//            //----------------------------------------
//            
//            //check dead items here -------------------
//            if (item.position.y <= 0) {
//                //delete all items out of screen
//                [item killItem];
//                [item removeFromParentAndCleanup:YES];
//                break;
//            }
//            //-----------------------------------------
//        }
//        
//    }
//    
//    [itemManager deleteDeadItems];
}

// This method is running every frame
- (void)update:(CCTime)delta {
    // do every thing for the items here
//    NSMutableArray * currentItems = [itemManager getAllItems];
//    
    for (id obj in _physicsNode.children) {
        if ([obj isKindOfClass:[Item class]]) {
            Item* item = (Item* ) obj;
            
            //check crashing here --------------------
            if (CGRectIntersectsRect(item.boundingBox, [[_gum getGumHead] boundingBox]))
            {
                NSLog(@"crashing");
                
                CCParticleSystem *exploding = [item crashing];
                exploding.position = [_gum convertToWorldSpace:item.position];
                
                [self addChild:exploding];
                //
                //            [item getStatus];// add status to gum
                [item killItem];
                [item removeFromParentAndCleanup:YES];
                
                [self updateScore];
                
                break;
            }
            //----------------------------------------
            
            //check dead items here -------------------
            if (item.position.y <= 0) {
                //delete all items out of screen
                [item killItem];
                [item removeFromParentAndCleanup:YES];
                break;
            }
            //-----------------------------------------
        }
        
    }
    
    [itemManager deleteDeadItems];
    
   }

-(void) addItems:(CCTime)delta {
    //create items
    id newItem = [itemManager createRandomItem];
    if (newItem != nil) {
        [_physicsNode addChild:newItem];
    }
}

@end
