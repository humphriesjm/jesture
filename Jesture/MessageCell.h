//
//  MessageCell.h
//  Jesture
//
//  Created by Jason Humphries on 3/18/14.
//  Copyright (c) 2014 PopUp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextField *responseField;
@property (weak, nonatomic) IBOutlet UIView *blueView;

- (void)showResponseField;

@end
