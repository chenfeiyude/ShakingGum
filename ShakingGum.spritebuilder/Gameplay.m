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

@implementation Gameplay
{
    Gum *_gum;
    
    ItemManager *itemManager;
    
    CCNode *_contentNode;
    CCPhysicsNode * _physicsNode;
    
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
 
    self.userInteractionEnabled = TRUE;
    
    _gum = (Gum *)[CCBReader load:@"Gum"];;
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
    CGPoint touchLocation = [touch locationInNode:_contentNode];
//    CGPoint gumLocation = [_gum convertToWorldSpace: _gum.position];
    
//    CGPoint gumHeadLocation = [[_gum getGumHead] convertToWorldSpace: [_gum getGumHead].position];
//    CGPoint gumBodyLocation = [[_gum getGumBody] convertToWorldSpace: [_gum getGumBody].position];
//    CGPoint gumBaseLocation = [[_gum getGumBase] convertToWorldSpace: [_gum getGumBase].position];

    
    NSLog(@"Touch location: %@", NSStringFromCGPoint(touchLocation));
//    NSLog(@"Gum location: %@", NSStringFromCGPoint(gumLocation));
//    NSLog(@"GumHead location: %@", NSStringFromCGPoint(gumHeadLocation));
//    NSLog(@"GumBody location: %@", NSStringFromCGPoint(gumBodyLocation));
//    NSLog(@"GumBase location: %@", NSStringFromCGPoint(gumBaseLocation));
     NSLog(@"Gum: %@", NSStringFromCGRect([_gum boundingBox]));
     NSLog(@"GumHead: %@", NSStringFromCGRect([[_gum getGumHead] boundingBox]));



  
    
    
    // start Gum dragging when a touch insdie of the Gum body occurs
    if (CGRectContainsPoint([_gum boundingBox], touchLocation))
    {
        NSLog(@"Gum touched");
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
