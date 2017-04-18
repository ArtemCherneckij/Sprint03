//
//  AppInfo.m
//  Sprint03
//
//  Created by Admin on 10.04.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        self.title = dic[@"genus"];
        self.subtitle = dic[@"title"];
        self.imageURL = [NSURL URLWithString:dic[@"image"]];
    }
    return self;
}

@end
