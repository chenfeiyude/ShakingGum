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
    
    CCLabelTTF *_scoreLabel;
    
    CGPoint beginTouchLocation;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
 
    self.userInteractionEnabled = TRUE;
    
    // initialise Gum in GamePlay scene
    _gum = (Gum *)[CCBReader load:@"Gum"];
    [_gum creatGumBody];
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    _gum.scale = (0.5);
    
    [_physicsNode addChild:_gum];
    
    _gum.position = CGPointMake(screenSize.width/2, 0);

    _physicsNode.debugDraw = TRUE;
    itemManager = [ItemManager getInstance];
    
    [_gum getGumHead].physicsBody.collisionType = @"GumHead";
    
    [self schedule:@selector(addItems:) interval:1];
    
}



-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_gum];
    beginTouchLocation = touchLocation;
}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_gum];
    CGPoint direction = CGPointMake(touchLocation.x - beginTouchLocation.x, touchLocation.y - beginTouchLocation.y);
    
    [_gum move:direction beginTouchLocation:beginTouchLocation];
}


// This method is running every frame
- (void)update:(CCTime)delta {
    // do every thing for the items here
    for (id obj in _physicsNode.children) {
        if ([obj isKindOfClass:[Item class]]) {
            Item* item = (Item* ) obj;
            for (CCNode * itemObj in item.children) {
                
                CGRect itemObjBoundingbox = itemObj.boundingBox;
                itemObjBoundingbox.origin = [itemObj.parent convertToWorldSpace:itemObjBoundingbox.origin];
                itemObjBoundingbox.origin.y = itemObjBoundingbox.origin.y + 50;
                
                CGRect headBoundingbox = [[_gum getGumHead] boundingBox];
                headBoundingbox.origin = [[_gum getGumHead].parent convertToWorldSpace:headBoundingbox.origin];
                
                //check crashing here --------------------
                if (CGRectIntersectsRect(itemObjBoundingbox, headBoundingbox))
                {
                    
                    NSLog(@"item location: %@", NSStringFromCGRect(itemObjBoundingbox));
                    NSLog(@"head location: %@", NSStringFromCGRect(headBoundingbox));
                
                    //should have only one obj in an item
                    
                    NSLog(@"crashing");
                    
                    CCParticleSystem *exploding = [item crashing];
                    
                    exploding.position = [item convertToWorldSpace:itemObj.position];
                    
                    [self addChild:exploding];
                    
                    // handle items, like add score, dead ...
                    [_gum handleItem:item];
                    
                    [item killItem];
                }
                
                //check dead items here -------------------
                if ([item convertToWorldSpace:itemObj.position].y <= 0) {
                    //delete all items out of screen
                    [item killItem];
                }

            }

        }
        
    }
    
    if ([[_gum getStatus] getStatus] != DEAD) {
        [_scoreLabel setString:[NSString stringWithFormat:@"Score: %ld", (long)[_gum getScore]]];
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
