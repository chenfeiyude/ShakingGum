//
//  AnimationManager.h
//  ShakingGum
//
//  Implemented by XiangXu
//  Created by chenfeiyu on 06/05/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationManager : NSObject {
    CCNode *scene;
}

-(id)init: (CCNode*) newScene;
-(void)scoringAnimation: (NSString *)message scoreLabel: (CCLabelTTF *)scoreLabel;
@end
