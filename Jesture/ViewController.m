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

@interface ViewController () <QBActionStatusDelegate, QBChatDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *messageSendButton;
@property (weak, nonatomic) IBOutlet UITableView *messagesTable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *userSegmentedControl;
@property (strong, nonatomic) NSMutableArray *allMessagesArray;
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
    } else {
        extendedAuthRequest.userLogin = FITCH_USERNAME;
    }
    extendedAuthRequest.userPassword = @"jesture2014";
    
    [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
}

#pragma mark -
#pragma mark QBActionStatusDelegate

- (void)completedWithResult:(Result *)result
{
    // Create session result
    if(result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class]){
        // You have successfully created the session
        QBAAuthSessionCreationResult *res = (QBAAuthSessionCreationResult *)result;
        
        // Sign In to QuickBlox Chat
        self.currentUser = [QBUUser user];
        self.currentUser.ID = res.session.userID; // your current user's ID
        self.currentUser.password = @"jesture2014"; // your current user's password
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
        message.recipientID = fitchID;
    } else {
        message.recipientID = jasonID;
    }
    message.text = msg;
    
    [[QBChat instance] sendMessage:message];
    
    NSString *formattedString = [NSString stringWithFormat:@"%u: %@", message.senderID, message.text];
    [self.allMessagesArray addObject:formattedString];
    [self.messagesTable reloadData];
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
    NSString *formattedString = [NSString stringWithFormat:@"%ul: %@", message.senderID, message.text];
    [self.allMessagesArray addObject:formattedString];
    NSLog(@"added %@ to allmessagesarray", formattedString);
    [self.messagesTable reloadData];
}



#pragma mark <UITableViewDataSource>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 54.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allMessagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *thisMessage = self.allMessagesArray[indexPath.row];
    cell.cellLabel.text = thisMessage;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
