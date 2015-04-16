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
    Status* status;
    NSInteger moveSpeed;
}


-(id)init{
    self = [super init];
    
    if(self)
    {
        NSLog(@"Gum initialised");
        [self initStatus];
        [self creatGumBody];
        
        CGSize screenSize = [CCDirector sharedDirector].viewSize;
        self.position = CGPointMake(screenSize.width/2, 0);
        self.scale = (0.5);
    }
    
    return self;
}

-(void) initStatus{
    if (status == nil) {
        status = [[Status alloc] init];
    }
    [status setStatus: INIT];
    moveSpeed = 20;
    remainTime = 100;// init remain time 100s
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

-(void) handleItem : (Item *) item
{
    Status* itemStatus = item.getStatus;
    [status setStatus:[itemStatus getStatus]];
    score += [[item getStatus] getValue];
    NSLog(@"Gum status changed to %ld (1:DEAD 2:ADD_SCORE)", (long)[status getStatus]);
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
    for (int i = 0; i < 10; i++) {
        CCNode* bodyA = [CCBReader load:@"GumBody"];
        bodyA.position = CGPointMake(bodyB.position.x, bodyB.position.y + bodyB.boundingBox.size.height);
        [gumBody addChild:bodyA];
        [CCPhysicsJoint connectedRotaryLimitJointWithBodyA:bodyA.physicsBody bodyB:bodyB.physicsBody min:-10 max:10];
        [CCPhysicsJoint connectedPivotJointWithBodyA:bodyA.physicsBody bodyB:bodyB.physicsBody anchorA:CGPointMake(26.5, -2.3)];
        
        bodyB = bodyA;
    }
    gumHead = [CCBReader load:@"GumBody"];
    gumHead.position = CGPointMake(bodyB.position.x, bodyB.position.y + bodyB.boundingBox.size.height);
    [CCPhysicsJoint connectedRotaryLimitJointWithBodyA:gumHead.physicsBody bodyB:bodyB.physicsBody min:-10 max:10];
    [CCPhysicsJoint connectedPivotJointWithBodyA:gumHead.physicsBody bodyB:bodyB.physicsBody anchorA:CGPointMake(26.5, -2.3)];
    
    [self addChild:gumHead];
    [self addChild:gumBody];
    [self addChild:gumBase];
    
    //set lower friction and mass would be better to move
    [[gumHead physicsBody] setFriction:0.f];
    [[gumHead physicsBody] setMass:10.f];
    [[gumBody physicsBody] setFriction:0.f];
    [[gumBody physicsBody] setMass:10.f];
    
    [[gumHead physicsBody] setCollisionType:@"GumHead"];
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

@end
