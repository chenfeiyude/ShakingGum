//
//  Status.m
//  ShakingGum
//
//  Created by chenfeiyu on 18/03/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Status.h"

@implementation Status

-(id)init{
    self = [super init];
    
    if(self)
    {
        status= INIT;
        value= 0;
    }
    
    return self;
}

-(void) setStatus:(GameObjStatus)newStatus{
    status = newStatus;
}

-(GameObjStatus) getStatus{
    return status;
}

-(void) setvalue:(NSInteger)newValue {
    value = newValue;
}

-(NSInteger) getValue{
    return value;
}

@end
