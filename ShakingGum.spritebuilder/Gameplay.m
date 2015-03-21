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
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.debugDraw = TRUE;
    
    itemManager = [ItemManager getInstance];
    
    [self schedule:@selector(addItems:) interval:1];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView:touch.view];
    
    // start Gum dragging when a touch insdie of the Gum body occurs
    if (CGRectContainsPoint([_gum boundingBox], touchLocation))
    {
        NSLog(@"ztouched");
    }
    
}


// This method is running every frame
- (void)update:(CCTime)delta {
    // do every thing for the items here
    NSMutableArray * currentItems = [itemManager getAllItems];
    
    for (id item in currentItems) {
        
        //check crashing here --------------------
//        [item crashing];// show the item crashing effect
//        [item getStatus];// add status to gum
        //----------------------------------------
        
        //check dead items here -------------------
        CCNode * obj = [item getItem];
        if (obj.position.y <= 0) {
            //delete all items out of screen
            [item killItem];
            [_physicsNode removeChild:obj];
        }
        //-----------------------------------------
    }

    
    [itemManager deleteDeadItems];
}

-(void) addItems:(CCTime)delta {
    //create items
    CCNode * newItem = [[itemManager createRandomItem] getItem];
    if (newItem != nil) {
        [_physicsNode addChild: newItem];
    }
}

@end
