//
//  AppInfo.h
//  Sprint03
//
//  Created by Admin on 10.04.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

-(id)initWithDictionary:(NSDictionary *)dic;

@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *subtitle;
@property (nonatomic, strong)NSURL *imageURL;

@end
