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
    
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB
{
    self.userInteractionEnabled = TRUE;
    
    itemManager = [ItemManager getInstance];
    
    [self schedule:@selector(addItems:) interval:1];
}

// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Touched");
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
