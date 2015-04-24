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
#import "TimeItem.h"

@implementation ItemManager

-(id)init
{
    self = [super init];
    
    if (self)
    {
        currentItems = [NSMutableArray new];
        maxItemSize  = 10;
        maxBombSize  = 3;
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
            case TIME_ITEM:
            {
                TimeItem *timeItem = [[TimeItem alloc] init];
                [currentItems addObject: timeItem];
                return timeItem;
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
        NSInteger random = arc4random_uniform((u_int32_t)maxItemSize);
        ItemType itemType = NONE;
        NSInteger range = maxItemSize / enum_count;
        NSInteger bomb_range = range * ( BOMB + 1 ); // BOMB = 0 in enum set
        NSInteger score_range = range * ( SCORE_ITEM + 1);
        NSInteger time_range = range * (TIME_ITEM + 1);
        NSInteger bomb_number = 0;
        for (id item in currentItems) {
            if ([item isKindOfClass:[Bomb class]]) {
                bomb_number++;
            }
        }
        if (random <= bomb_range && bomb_number < maxBombSize) {
            itemType = BOMB;
        }
        else if (random > bomb_range && random <= score_range) {
            itemType = SCORE_ITEM;
        }
        else if (random > score_range && random <= time_range) {
            itemType = TIME_ITEM;
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
        
        if ([item isDead]) {
            [deadItems addObject:item];
            [item removeFromParentAndCleanup:YES];
        }
    }
    
    [currentItems removeObjectsInArray:deadItems];
}

-(void) dealloc
{
    if (currentItems != nil) {
        for (id currentItem in currentItems) {
            [currentItem removeFromParentAndCleanup:YES];
            [currentItem removeAllChildren];
        }
        [currentItems removeAllObjects];
    }
}
@end
