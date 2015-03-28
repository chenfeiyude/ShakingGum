//
//  Gameplay.m
//  ShakingGum
//
//  Created by Xiang Xu on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Gum.h"

@implementation Gameplay
{
    Gum *_gum;
    
    ItemManager *itemManager;
    CCPhysicsNode * _physicsNode;
    
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
    
    _gum = (Gum *)[CCBReader load: @"Gum"];
    
    
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.debugDraw = TRUE;
    
    itemManager = [ItemManager getInstance];
    
    [self schedule:@selector(addItems:) interval:1];
    
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    NSLog(@"Touch location: %@", NSStringFromCGPoint(touchLocation));
    NSLog(@"Gum Head location: %@", NSStringFromCGRect([[_gum getGumHead] boundingBox]));
    NSLog(@"Gum Body location: %@", NSStringFromCGRect([[_gum getGumBody] boundingBox]));
    NSLog(@"Gum Base location: %@", NSStringFromCGRect([[_gum getGumBase] boundingBox]));
    
    // start Gum dragging when a touch insdie of the Gum body occurs
    if (CGRectContainsPoint([[_gum getGumBase] boundingBox], touchLocation))
    {
        NSLog(@"Gum head touched");
    }
    
}


// This method is running every frame
- (void)update:(CCTime)delta {
    // do every thing for the items here
    NSMutableArray * currentItems = [itemManager getAllItems];
    
    for (Item* item in currentItems) {
        
        //check crashing here --------------------
        if (CGRectIntersectsRect(item.boundingBox, [[_gum getGumHead] boundingBox]))
        {
            CCParticleSystem *exploding = [item crashing];
            [self addChild:exploding];
            
            [item getStatus];// add status to gum
        }
        //----------------------------------------
        
        //check dead items here -------------------
        if (item.position.y <= 0) {
            //delete all items out of screen
            [item killItem];
            [self removeChild:item];
        }
        //-----------------------------------------
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
