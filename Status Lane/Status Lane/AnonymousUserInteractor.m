//
//  AnonymousUserInteractor.m
//  Status Lane
//
//  Created by Jonathan Aguele on 27/07/2015.
//  Copyright (c) 2015 Sui Generis Innovations. All rights reserved.
//

#import "AnonymousUserInteractor.h"
#import "ChoosePartnerPresenter.h"
#import "NetworkManager.h"
#import "Defaults.h"

@interface AnonymousUserInteractor(){
    
    NSString *partnerStatus;
    NSString *partnerName;
}

@property (nonatomic, strong) id <NetworkProvider> networkProvider;

@end


@implementation AnonymousUserInteractor

-(id<NetworkProvider>)networkProvider{
    
    if (!_networkProvider) {
        
        _networkProvider = [NetworkManager new];
    }
    return _networkProvider;
}



-(void)searchAnonymousUserWithUsername:(NSString *)username andfullName:(NSString *)fullName andStatus:(NSString *)status{
    
    partnerStatus = status;
    partnerName = fullName;
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnonymousUser"];
    [query whereKey:@"username" equalTo:username];
    
    [self.networkProvider queryDatabaseWithQuery:query
                                         success:^(id responseObject) {
                                             
                                             NSArray *array = responseObject;
                                             if (array.count == 0) {
                                                 
                                                 //Create annonymous user
                                                 [self createAnonymouseUserWithUsername:username fullName:fullName andStatus:status];
                                                 
                                             }
                                             else{
                                                 
                                                 PFObject *object = [array objectAtIndex:0];
                                                 if ([object[@"status"] isEqualToString:@"SINGLE"]) {
                                                     
                                                     [self setNewPartnerWithAnonymousUser:object];
                                                     
                                                 }
                                                 
                                                 else if ([[[PFUser currentUser] objectId] isEqualToString:[self determinePartnerOfAnonymousUser:object]]){
                                                     
                                                     [self setNewPartnerWithAnonymousUser:object];
                                                     
                                                 }
                                                 
                                                 else{
                                                     
                                                     [self.presenter stopAnimatingActivitiyView];
                                                     [self.presenter showErrorView:@"This user is in a relationship with someone else"];
                                                     
                                                 }
                                             }
                                             
                                             
                                         }failure:^(NSError *error) {
                                             
                                             [self.presenter stopAnimatingActivitiyView];
                                             [self.presenter showErrorView:error.localizedDescription];
                                             
                                         }];
    
    
}


-(void)createAnonymouseUserWithUsername:(NSString *)username fullName:(NSString *)fullname andStatus:(NSString *)status{
    
    PFObject *partner = [PFObject objectWithClassName:@"AnonymousUser"];
    partner[@"username"] = username;
    partner[@"fullName"] = fullname;
    partner[@"status"] = status;
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *partnerArray = @[currentUser];
    [partner setObject:partnerArray forKey:@"partner"];
    
    [self.networkProvider saveWithPFObject:partner
                                   success:^(id responseObject) {
                                       
                                       NSNumber *number = responseObject;
                                       BOOL success = [number boolValue];
                                       if (success) {
                                           
                                           //set new partner
                                           [self removePreviousPartner:partner];
                                           
                                       }
                                       
                                       else{
                                           
                                           [self.presenter stopAnimatingActivitiyView];
                                           [self.presenter showErrorView:@"Could Not Save At This Time Please Try Again Later"];
                                       }
                                       
                                   } failure:^(NSError *error) {
                                       
                                       [self.presenter showErrorView:error.localizedDescription];
                                       
                                       
                                   }];
    
    
}

-(void)removePreviousPartner:(PFObject *)partner{
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *arrayWithPreviousUser = currentUser[@"partner"];
    
    if (arrayWithPreviousUser) {
        
        if (![[arrayWithPreviousUser objectAtIndex:0] isKindOfClass:NSClassFromString(@"PFUser")]) {
            
            PFObject *previousPartner = [arrayWithPreviousUser objectAtIndex:0];
            previousPartner[@"status"] = @"SINGLE";
            [previousPartner removeObjectForKey:@"partner"];
            
            [self.networkProvider saveWithPFObject:previousPartner
                                           success:^(id responseObject) {
                                               
                                               [self setNewPartnerWithAnonymousUser:partner];
                                               
                                           } failure:^(NSError *error) {
                                               
                                               [self.presenter stopAnimatingActivitiyView];
                                               [self.presenter showErrorView:error.localizedDescription];

                                           }];

        }
        
        else{
            
            NSLog(@"array contains pfuser");
            NSLog(@"Is a user");
            //TODO
        }
    }
    
    else{
        
        [self setNewPartnerWithAnonymousUser:partner];
        
    }
    
}

-(void)setNewPartnerWithAnonymousUser:(PFObject *)anonymousUser{
    
    anonymousUser[@"status"] = partnerStatus;
    NSArray *partnerArray = @[anonymousUser];
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *partnerArray2 = @[currentUser];
    currentUser[@"status"] = partnerStatus;
    [currentUser setObject:partnerArray forKey:@"partner"];
    [anonymousUser setObject:partnerArray2 forKey:@"partner"];
    
    [self.networkProvider saveWithPFObject:currentUser
                                   success:^(id responseObject) {
                                       
                                       NSNumber *number = responseObject;
                                       BOOL success = [number boolValue];
                                       if (success) {
                                           
                                           [self setPartnerOnAnonymousUser:anonymousUser];
                                           [self updateStatusHistoryForUser:currentUser usingAnonymousUserAsPartner:anonymousUser];
                                       }
                                       
                                       else{
                                           
                                           [self.presenter stopAnimatingActivitiyView];
                                           [self.presenter showErrorView:@"Could Not Save At This Time Please Try Again Later"];

                                       }
                                       
                                   } failure:^(NSError *error) {
                                       
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter showErrorView:error.localizedDescription];
                                       
                                   }];
    
}

-(void)setPartnerOnAnonymousUser:(PFObject *)anonymousObject{
    
    [self.networkProvider saveWithPFObject:anonymousObject
                                   success:^(id responseObject) {
                                       
                                       [Defaults setPartnerFullName:partnerName];
                                       [Defaults setStatus:partnerStatus];
                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter dismissView];
                                       
                                   } failure:^(NSError *error) {

                                       [self.presenter stopAnimatingActivitiyView];
                                       [self.presenter showErrorView:error.localizedDescription];
                                       
                                   }];
}

-(void)updateStatusHistoryForUser:(PFUser  *)user usingAnonymousUserAsPartner:(PFObject*)anonymousUserPartner{
    
    PFObject *statusHistoryObject = [PFObject objectWithClassName:@"StatusHistory"];
    statusHistoryObject[@"historyId"] = user.objectId;
    statusHistoryObject[@"statusType"] = user[@"status"];
    statusHistoryObject[@"statusDate"] = [NSDate date];
    statusHistoryObject[@"partnerId"] = anonymousUserPartner.objectId;
    statusHistoryObject[@"partnerName"] = partnerName;
    [statusHistoryObject saveInBackground];
}



-(NSString *)determinePartnerOfAnonymousUser:(PFObject *)anonymouseUser{
    
    NSArray *partner = anonymouseUser[@"partner"];
    
    if (partner.count == 0) {
        //no partner
        return @"No partner";
    }
    else{
        
        PFUser *userPartner = [partner objectAtIndex:0];
        return [userPartner objectId];
        
    }
}


@end
