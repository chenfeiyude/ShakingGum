//
//  ItemManager.m
//  ShakingGum
//
//  Created by chenfeiyu on 19/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ItemManager.h"
#import "Bomb.h"
#import "ScoreItem.h"

@implementation ItemManager

-(id)init
{
    self = [super init];
    
    if (self)
    {
        currentItems = [NSMutableArray new];
        maxItemSize  = 3;
    }
    
    return self;
}

+(id) getInstance{
    static ItemManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void) addItem:(Item *)item{
    if (item != nil && currentItems.count <= maxItemSize) {
        [currentItems addObject:item];
    }
}

-(void) deleteItem:(Item *) item{
    if (currentItems != nil && item != nil) {
        for (id currentItem in currentItems) {
            if ([currentItem isEqual:item]) {
                [currentItems removeObject:currentItem];
                break;
            }
        }
    }
}

// delete all current items from the game
-(void) clearItems{
    if (currentItems != nil && currentItems.count > 0) {
        [currentItems removeAllObjects];
    }
}

//create an item with input type
-(id) createItem:(ItemType)itemType{
    if (currentItems != nil && currentItems.count <= maxItemSize) {
        switch (itemType) {
            case BOMB:
            {
                Bomb *bomb = [[Bomb alloc] init];
                [currentItems addObject: bomb];
                return bomb;
            }
            case SCORE_ITEM:
            {
                ScoreItem *scoreItem = [[ScoreItem alloc] init];
                [currentItems addObject: scoreItem];
                return scoreItem;
            }
            default:
                return nil;
        }
    }
    return nil;
}

//create an random item to the game
-(id) createRandomItem{
    if (currentItems != nil && currentItems.count <= maxItemSize) {
        int random = arc4random_uniform(maxItemSize);
        ItemType itemType = NONE;
        int range = maxItemSize / enum_count;
        int bomb_range = range * ( BOMB + 1 ); // BOMB = 0 in enum set
        int score_range = range * ( SCORE_ITEM + 1);
        if (random <= bomb_range) {
            itemType = BOMB;
        }
        else if (random > bomb_range && random <= score_range) {
            itemType = SCORE_ITEM;
        }
        return [self createItem: itemType];
    }
    return nil;
}

-(NSMutableArray *) getAllItems {
    return currentItems;
}

-(void) deleteDeadItems {
    NSMutableArray * deadItems = [NSMutableArray new];
    for (id item in currentItems) {
        if ([item isDead] == YES) {
            [deadItems addObject:item];
        }
    }
    
    [currentItems removeObjectsInArray:deadItems];
}
@end
