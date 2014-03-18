//
//  ViewController.h
//  Jesture
//
//  Created by Jason Humphries on 3/18/14.
//  Copyright (c) 2014 PopUp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) QBUUser *currentUser;
@property (strong, nonatomic) NSString *currentToken;

@end
