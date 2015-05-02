//
//  ItemManager.h
//  ShakingGum
//
//  Created by chenfeiyu on 19/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

typedef NS_ENUM(NSInteger, ItemType) {
    BOMB,
    SCORE_ITEM,
    TIME_ITEM,
    NONE,
    enum_count,
};

@interface ItemManager : NSObject {
    NSMutableArray * currentItems;
    NSInteger maxItemSize;
    NSInteger maxBombSize;
    NSInteger maxScoreSize;
    NSInteger maxTimeSize;
}

+(id) getInstance; // this class is a singleton class  e.g ItemManager *sharedManager = [ItemManager getInstance];

-(id) init;
-(void) addItem: (Item *) item;
-(void) deleteItem: (Item *) item;
-(void) deleteDeadItems;
-(void) clearItems;
-(id) createItem: (ItemType) itemType;
-(id) createRandomItem;
-(NSMutableArray *) getAllItems;
@end
