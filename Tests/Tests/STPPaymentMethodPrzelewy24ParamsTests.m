//
//  STPPaymentMethodPrzelewy24ParamsTests.m
//  StripeiOS Tests
//
//  Created by Vineet Shah on 4/23/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "STPAPIClient.h"
#import "STPPaymentMethod.h"
#import "STPPaymentMethodBillingDetails.h"
#import "STPPaymentMethodParams.h"
#import "STPPaymentMethodPrzelewy24Params.h"
#import "STPTestingAPIClient.h"

@interface STPPaymentMethodPrzelewy24ParamsTests : XCTestCase

@end

@implementation STPPaymentMethodPrzelewy24ParamsTests

- (void)testCreatePrzelewy24PaymentMethod {
    STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:STPTestingDefaultPublishableKey];
    STPPaymentMethodPrzelewy24Params *przelewy24Params = [STPPaymentMethodPrzelewy24Params new];

    STPPaymentMethodBillingDetails *billingDetails = [STPPaymentMethodBillingDetails new];
    billingDetails.email = @"email@email.com";

    STPPaymentMethodParams *params = [STPPaymentMethodParams paramsWithPrzelewy24:przelewy24Params
                                                                   billingDetails:billingDetails
                                                                         metadata:@{@"test_key": @"test_value"}];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Payment Method Przelewy24 create"];

    [client createPaymentMethodWithParams:params
                               completion:^(STPPaymentMethod * _Nullable paymentMethod, NSError * _Nullable error) {
        [expectation fulfill];

        XCTAssertNil(error, @"Unexpected error creating Przelewy24 PaymentMethod: %@", error);
        XCTAssertNotNil(paymentMethod, @"Failed to create Przelewy24 PaymentMethod");
        XCTAssertNotNil(paymentMethod.stripeId, @"Missing stripeId");
        XCTAssertNotNil(paymentMethod.created, @"Missing created");
        XCTAssertFalse(paymentMethod.liveMode, @"Incorrect livemode");
        XCTAssertEqual(paymentMethod.type, STPPaymentMethodTypePrzelewy24, @"Incorrect PaymentMethod type");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        XCTAssertEqualObjects(paymentMethod.metadata, @{}, @"Metadata is not returned.");
#pragma clang diagnostic pop

        // Billing Details
        XCTAssertEqualObjects(paymentMethod.billingDetails.email, @"email@email.com", @"Incorrect email");

        // Przelewy24 Details
        XCTAssertNotNil(paymentMethod.przelewy24, @"Missing Przelewy24");
    }];

    [self waitForExpectationsWithTimeout:STPTestingNetworkRequestTimeout handler:nil];
}

@end