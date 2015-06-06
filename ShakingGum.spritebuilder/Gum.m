//
//  Gum.m
//  ShakingGum
//
//  Created by Xiang Xu on 21/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gum.h"

@implementation Gum
{
    CCNode *gumHead;
    CCNode *gumBody;
    CCNode *gumBase;
    
    NSInteger score;
    NSInteger remainTime;
    NSInteger MAX_REMAIN_TIME;
    Status* status;
    NSInteger moveSpeed;
    NSInteger bodySize;
}


-(id)init{
    self = [super init];
    
    if(self)
    {
        [self initStatus];
        [self creatGumBody];
        
        CGSize screenSize = [CCDirector sharedDirector].viewSize;
        self.position = CGPointMake(screenSize.width/2 - 10, 0);
//        self.scale = (0.5);
    }
    
    return self;
}

-(void) initStatus{
    if (status == nil) {
        status = [[Status alloc] init];
    }
    [status setStatus: INIT];
    moveSpeed = 5;
    MAX_REMAIN_TIME = 100;
    remainTime = MAX_REMAIN_TIME;// init remain time 100s
    bodySize = 20;
}

-(CCNode *)getGumHead
{
    return gumHead;
}

-(CCNode *)getGumBody
{
    return gumBody;
}

-(CCNode *)getGumBase
{
    return gumBase;
}

-(NSInteger) getScore
{
    return score;
}

-(Status *) getStatus
{
    return status;
}

-(void) handleItem : (Item *) item isCrashingWithHead:(BOOL) isCrashingWithHead
{
    if([status getStatus] != DEAD)
    {
        if (isCrashingWithHead) {
            Status* itemStatus = item.getStatus;
            [status setStatus:[itemStatus getStatus]];
            if ([item isKindOfClass:[ScoreItem class]]) {
                score += [[item getStatus] getValue];
            }
            else if ([item isKindOfClass:[TimeItem class]]) {
                remainTime += [[item getStatus] getValue];
                if (remainTime > MAX_REMAIN_TIME) {
                    remainTime = MAX_REMAIN_TIME;
                }
            }
        }
        else {
            // collision with body will reduce the time
            if ([item isKindOfClass:[Bomb class]]) {
                [status setStatus:REDUCE_TIME];
                if(remainTime > 5) {
                    remainTime -= 5;
                }
                else {
                    remainTime = 0;
                }
            }
        }
        
        NSLog(@"Gum status changed to %ld (1:DEAD 2:ADD_SCORE 3:REDUCE_TIME 4:ADD_TIME)", (long)[status getStatus]);
    }
}

-(void) move : (CGPoint) direction beginTouchLocation: (CGPoint) touchPosition
{
    CGPoint force = CGPointMake(direction.x * moveSpeed, direction.y * moveSpeed);
    [gumHead.physicsBody applyForce: force]; // give the gum a speed, need to enable physics in spritbuilder
    for (CCNode* obj in gumBody.children) {
        [obj.physicsBody applyForce: force]; // give the gum a speed, need to enable physics in spritbuilder
    }
}

-(void) creatGumBody
{
    gumBody = [[CCSprite alloc] init];
    gumBase = [CCBReader load:@"GumBody"];
    gumBase.position = CGPointMake(0, 0);
    gumBase.physicsBody.type = CCPhysicsBodyTypeStatic;
    
    CCNode* bodyB = gumBase;
    for (int i = 0; i < bodySize; i++) {
        CCNode* bodyA = [CCBReader load:@"GumBody"];
        [bodyA.physicsBody setCollisionType:@"GumBody"];
        
        bodyA.position = CGPointMake(bodyB.position.x, bodyB.position.y + bodyB.boundingBox.size.height);
        [gumBody addChild:bodyA];
//        [CCPhysicsJoint connectedRotaryLimitJointWithBodyA:bodyA.physicsBody bodyB:bodyB.physicsBody min:-10 max:10];
        [CCPhysicsJoint connectedPivotJointWithBodyA:bodyA.physicsBody bodyB:bodyB.physicsBody anchorA:CGPointMake(40, 0)];
        
        bodyB = bodyA;
    }
    gumHead = [CCBReader load:@"GumHead"];
//    gumHead = [CCBReader load:@"GumBody"];
    gumHead.position = CGPointMake(bodyB.position.x, bodyB.position.y + bodyB.boundingBox.size.height);
//    [CCPhysicsJoint connectedRotaryLimitJointWithBodyA:gumHead.physicsBody bodyB:bodyB.physicsBody min:-10 max:10];
    [CCPhysicsJoint connectedPivotJointWithBodyA:gumHead.physicsBody bodyB:bodyB.physicsBody anchorA:CGPointMake(40, 0.1)];
    
    //set lower friction and mass would be better to move
//    [gumHead.physicsBody setFriction:0.f];
//    [gumHead.physicsBody setMass:10.f];
//    [gumBody.physicsBody setFriction:0.f];
//    [gumBody.physicsBody setMass:10.f];
    
//    [gumHead.physicsBody setAffectedByGravity:FALSE];
//    [gumBody.physicsBody setAffectedByGravity:FALSE];
    
    [gumHead.physicsBody setCollisionType:@"GumHead"];
    
    [self addChild:gumHead];
    [self addChild:gumBody];
    [self addChild:gumBase];
}

-(void) reduceTime:(CCTime)delta {
    //reduce game time
    if (remainTime > 0) {
        remainTime--;
    }
    else {
        //timeout game over, gum is dead now
        [status setStatus:DEAD];
    }
}

-(NSInteger) getRemainTime
{
    return remainTime;
}

-(void) dealloc
{
    if (gumHead != nil) {
        [gumHead removeFromParentAndCleanup:YES];
        [gumHead removeAllChildren];
    }
    if (gumBody != nil) {
        [gumBody removeFromParentAndCleanup:YES];
        [gumBody removeAllChildren];
    }
    if (gumBase != nil) {
        [gumBase removeFromParentAndCleanup:YES];
        [gumBase removeAllChildren];
    }
    
}

@end
