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
    NONE
};

@interface ItemManager : NSObject {
    NSMutableArray * currentItems;
}

+(id) getInstance; // this class is a singleton class  e.g ItemManager *sharedManager = [ItemManager getInstance];

-(id) init;
-(void) addItem: (Item *) item;
-(void) deleteItem: (Item *) item;
-(void) clearItems;
-(void) createItem: (ItemType) itemType;
-(void) createRandomItem;
@end
