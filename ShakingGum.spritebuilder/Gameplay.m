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

    _physicsNode.debugDraw = TRUE;
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
        NSLog(@"Game Over!!!!");
        // show share and score
    }
    
    // do every thing for the items here
    for (id obj in _physicsNode.children) {
        if ([obj isKindOfClass:[Item class]]) {
            Item* item = (Item* ) obj;
            for (CCNode * itemObj in item.children) {
                
                CGRect itemObjBoundingbox = itemObj.boundingBox;
                itemObjBoundingbox.origin = [itemObj.parent convertToWorldSpace:itemObjBoundingbox.origin];
                
                CGRect headBoundingbox = [[gum getGumHead] boundingBox];
                headBoundingbox.origin = [[gum getGumHead].parent convertToWorldSpace:headBoundingbox.origin];
                
                //check crashing here --------------------
                if (CGRectIntersectsRect(itemObjBoundingbox, headBoundingbox))
                {
                    //should have only one obj in an item
                    
                    NSLog(@"crashing");
                    
                    // show exploding
                    CCParticleSystem *exploding = [item crashing];
                    exploding.position = [item convertToWorldSpace:itemObj.position];
                    [self addChild:exploding];
                    
                    // handle items, like add score, dead ...
                    [gum handleItem:item];
                    
                    [item killItem];
                    
                    continue;
                }
                
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
@end
