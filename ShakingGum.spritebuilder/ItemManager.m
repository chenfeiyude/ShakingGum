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
    if (item != nil) {
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

-(void) clearItems{
    if (currentItems != nil && currentItems.count != 0) {
        [currentItems removeAllObjects];
    }
}

-(void) createItem:(ItemType)itemType{
    switch (itemType) {
        case BOMB:
            [currentItems addObject: [[Bomb alloc] init]];
            break;
        case SCORE_ITEM:
            [currentItems addObject: [[ScoreItem alloc] init]];
            break;
        default:
            break;
    }
}

-(void) createRandomItem{
    int random = arc4random_uniform(2);
    ItemType itemType = NONE;
    if (random == 1) {
        itemType = BOMB;
    }
    else if (random == 2) {
        itemType = SCORE_ITEM;
    }
    [self createItem: itemType];
}

@end
