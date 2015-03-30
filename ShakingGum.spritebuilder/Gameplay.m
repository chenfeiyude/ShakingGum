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
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
 
    self.userInteractionEnabled = TRUE;
    
    // initialise Gum in GamePlay scene
    _gum = (Gum *)[CCBReader load:@"Gum"];
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    _gum.position = CGPointMake(screenSize.width/2, 0);
    _gum.scale = (0.3);
    
    [_physicsNode addChild:_gum];
    
    _physicsNode.debugDraw = TRUE;
    itemManager = [ItemManager getInstance];
    
    [self schedule:@selector(addItems:) interval:1];
    
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_gum];

    NSLog(@"Touch location: %@", NSStringFromCGPoint(touchLocation));
   
    // when a touch insdie of the Gum body occurs
    if (CGRectContainsPoint([[_gum getGumHead] boundingBox], touchLocation))
    {
        NSLog(@"GumHead touched");
    }
    
    if(CGRectContainsPoint([[_gum getGumBody] boundingBox], touchLocation))
    {
        NSLog(@"GumBody touched");
    }
    
    if(CGRectContainsPoint([[_gum getGumBase] boundingBox], touchLocation))
    {
        NSLog(@"GumBase touched");
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


// This method is running every frame
- (void)update:(CCTime)delta {
    // do every thing for the items here
//    NSMutableArray * currentItems = [itemManager getAllItems];
    
    for (id obj in _physicsNode.children) {
        if ([obj isKindOfClass:[Item class]]) {
            Item* item = (Item* ) obj;
            //check crashing here --------------------
            if (CGRectIntersectsRect(item.boundingBox, [[_gum getGumHead] boundingBox]))
            {
                //            NSLog(@"crashing");
                //            CCParticleSystem *exploding = [item crashing];
                //            [self addChild:exploding];
                //
                //            [item getStatus];// add status to gum
//                [item removeFromParentAndCleanup:YES];
            }
            //----------------------------------------
            
            //check dead items here -------------------
            if (item.position.y <= 0) {
                //delete all items out of screen
                [item killItem];
                [item removeFromParentAndCleanup:YES];
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
