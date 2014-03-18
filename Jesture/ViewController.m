//
//  ViewController.m
//  Jesture
//
//  Created by Jason Humphries on 3/18/14.
//  Copyright (c) 2014 PopUp Inc. All rights reserved.
//

#import "ViewController.h"
//#import "XMLReader.h"
#import "MessageCell.h"

@interface ViewController () <QBActionStatusDelegate, QBChatDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *messageSendButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSMutableArray *allMessagesArray;
@property (weak, nonatomic) IBOutlet UILabel *currentUsernameLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allMessagesArray = [NSMutableArray array];
    
    // ACT AS JASON
    [self.userSegmentedControl setSelectedSegmentIndex:0];
    
    // ACT AS FITCH
//    [self.userSegmentedControl setSelectedSegmentIndex:1];
    
    [self startQB];
}

- (IBAction)dismissKeyboardAction:(id)sender
{
    [self.view endEditing:YES];
}

#define FITCH_USERNAME @"fitchc"
#define JASON_USERNAME @"humphriesj"

- (void)startQB
{
    // Create session with user
    QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
    if (self.userSegmentedControl.selectedSegmentIndex == 0) {
        extendedAuthRequest.userLogin = JASON_USERNAME;
        self.currentUsername = JASON_USERNAME;
    } else {
        extendedAuthRequest.userLogin = FITCH_USERNAME;
        self.currentUsername = FITCH_USERNAME;
    }
    extendedAuthRequest.userPassword = @"jesture2014";
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result
{
    // Create session result
    if (result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class]) {
        // You have successfully created the session
        QBAAuthSessionCreationResult *res = (QBAAuthSessionCreationResult *)result;
        
        // Sign In to QuickBlox Chat
        self.currentUser = [QBUUser user];
        self.currentUser.ID = res.session.userID;
        self.currentUser.password = @"jesture2014";
        self.currentToken = res.session.token;
        
        // set Chat delegate
        [QBChat instance].delegate = self;
        
        // login to Chat
        [[QBChat instance] loginWithUser:self.currentUser];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessageAction:nil];
    return YES;
}

- (IBAction)sendMessageAction:(id)sender
{
    [self sendQBMessage:self.messageTextField.text];
}

- (IBAction)userSegmentedControlAction:(id)sender
{
    //
}

- (void)sendQBMessage:(NSString*)msg
{
    // send message
    QBChatMessage *message = [QBChatMessage message];
    NSUInteger fitchID = 947052;
    NSUInteger jasonID = 947231;
    if (self.userSegmentedControl.selectedSegmentIndex == 0) {
        message.senderNick = JASON_USERNAME;
        message.recipientID = fitchID;
    } else {
        message.senderNick = FITCH_USERNAME;
        message.recipientID = jasonID;
    }
    message.text = msg;
    
    [[QBChat instance] sendMessage:message];
    
    [self.allMessagesArray addObject:message];
    [self.messagesTable reloadData];
    self.messageTextField.text = @"";
    [self.messageTextField resignFirstResponder];
}

#pragma mark -
#pragma mark QBChatDelegate

- (void)chatDidFailWithError:(NSInteger)code
{
    NSLog(@"Fail: %d", code);
}

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message
                         fromRoom:(NSString *)roomName
{
    NSLog(@"chatRoomDidReceiveMessage: %@", message);
}

- (void)chatDidReceivePresenceOfUser:(NSUInteger)userID
                                type:(NSString *)type
{
    NSLog(@"chatDidReceivePresenceOfUser: %d, %@", userID, type);
}

- (void)chatDidReceiveListOfRooms:(NSArray *)rooms
{
    NSLog(@"chatDidReceiveListOfRooms: %@", rooms);
}

- (void)chatDidLogin
{
    NSLog(@"You have successfully signed in to QuickBlox Chat (chatDidLogin)");
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message
{
    if (!self.allMessagesArray) {
        self.allMessagesArray = [NSMutableArray array];
    }
    NSLog(@"New message(chatDidReceiveMessage): %@", message);
    NSLog(@"allMessagesArray:%@", self.allMessagesArray);
    [self.allMessagesArray addObject:message];
    NSLog(@"added %@ to allmessagesarray", message);
    [self.messagesTable reloadData];
}



#pragma mark <UITableViewDataSource>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 75.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allMessagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *reversedArray = [[self.allMessagesArray reverseObjectEnumerator] allObjects];
    QBChatMessage *thisMessage = reversedArray[indexPath.row];
    cell.cellLabel.text = thisMessage.text;
    NSUInteger fitchID = 947052;
    NSUInteger jasonID = 947231;
    if (thisMessage.senderID == jasonID) {
        cell.currentUsernameLabel.text = JASON_USERNAME;
    } else if (thisMessage.senderID == fitchID) {
        cell.currentUsernameLabel.text = FITCH_USERNAME;
    } else {
        cell.currentUsernameLabel.text = @"idk";
    }
    cell.timeLabel.text = [thisMessage.datetime descriptionWithLocale:@"en_US"];
    [cell.blueView setFrame:CGRectMake(-320, 0, 320, 75)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MessageCell *selectedCell = (MessageCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         [selectedCell.blueView setFrame:CGRectMake(0, 0, 320, 75)];
                     } completion:^(BOOL finished) {
                         [selectedCell showResponseField];
                     }];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
