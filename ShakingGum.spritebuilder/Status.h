//
//  Status.h
//  ShakingGum
//
//  Created by chenfeiyu on 18/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GameObjStatus) {
    INIT,
    DEAD,
    ADD_SCORE
};

@interface Status : NSObject {
    GameObjStatus status; // gum and items status
    NSInteger     value;  // 0 as default if it is not used
}

-(id) init;
-(void) setStatus: (GameObjStatus )newStatus;
-(GameObjStatus ) getStatus;
-(void) setvalue: (NSInteger) newValue;
-(NSInteger) getValue;

@end
