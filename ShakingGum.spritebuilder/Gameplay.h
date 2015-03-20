//
//  Gameplay.h
//  ShakingGum
//
//  Created by Xiang Xu on 15/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "ItemManager.h"

@interface Gameplay : CCNode {
    ItemManager *itemManager;
    CCNode * _physicsNode;
}

@end
