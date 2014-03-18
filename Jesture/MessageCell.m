//
//  MessageCell.m
//  Jesture
//
//  Created by Jason Humphries on 3/18/14.
//  Copyright (c) 2014 PopUp Inc. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.responseField.hidden = YES;
}

- (void)showResponseField
{
    self.responseField.hidden = NO;
    self.responseField.textColor = [UIColor whiteColor];
    UIColor *color = [UIColor whiteColor];
    self.responseField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Response" attributes:@{NSForegroundColorAttributeName: color}];
    self.responseField.tintColor = [UIColor whiteColor];
    [self.responseField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.blueView setFrame:CGRectMake(-320, 0, 320, 75)];
                     } completion:^(BOOL finished) {
                         self.responseField.hidden = YES;
                         [self.responseField resignFirstResponder];
                     }];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
