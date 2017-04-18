//
//  DetailViewController.h
//  Sprint03
//
//  Created by Admin on 10.04.17.
//  Copyright (c) 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titledetail;
@property (weak, nonatomic) IBOutlet UILabel *subtitledetail;
@property (weak, nonatomic) IBOutlet UIImageView *imagedetail;
@property(nonatomic,strong) NSString *eventName;
@property(nonatomic,strong) NSString *eventSubName;
@property(nonatomic,strong) UIImage *image;

@end
