//
//  Gum.h
//  ShakingGum
//
//  Created by Xiang Xu on 21/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "Item.h"
#import "ScoreItem.h"
#import "Bomb.h"
#import "Status.h"

@interface Gum : CCSprite

-(CCNode *)getGumHead;
-(CCNode *)getGumBody;
-(CCNode *)getGumBase;
-(void) handleItem : (Item *) item isCrashingWithHead:(BOOL) isCrashingWithHead;
-(NSInteger) getScore;
-(Status *) getStatus;
-(void) move : (CGPoint) direction beginTouchLocation: (CGPoint) touchPosition;
-(void) creatGumBody;
-(void) reduceTime:(CCTime)delta;
-(NSInteger) getRemainTime;
@end
