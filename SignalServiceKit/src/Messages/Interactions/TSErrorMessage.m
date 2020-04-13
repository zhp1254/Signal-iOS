//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

#import "TSErrorMessage.h"
#import "ContactsManagerProtocol.h"
#import "OWSMessageManager.h"
#import "SSKEnvironment.h"
#import "TSContactThread.h"
#import "TSErrorMessage_privateConstructor.h"
#import <SignalCoreKit/NSDate+OWS.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

NSUInteger TSErrorMessageSchemaVersion = 2;

@interface ThreadlessErrorMessage ()

@property (nonatomic, readonly) TSErrorMessageType errorType;

@end

#pragma mark -

@implementation ThreadlessErrorMessage

- (instancetype)initWithErrorType:(TSErrorMessageType)errorType
{
    self = [super init];
    if (!self) {
        return self;
    }

    _errorType = errorType;

    return self;
}

+ (ThreadlessErrorMessage *)corruptedMessageInUnknownThread
{
    return [[self alloc] initWithErrorType:TSErrorMessageInvalidMessage];
}

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    switch (_errorType) {
        case TSErrorMessageInvalidMessage:
            return NSLocalizedString(@"ERROR_MESSAGE_INVALID_MESSAGE", @"");
        default:
            OWSFailDebug(@"Unknown error type.");
            return NSLocalizedString(@"ERROR_MESSAGE_UNKNOWN_ERROR", @"");
    }
}

@end

#pragma mark -

@interface TSErrorMessage ()

@property (nonatomic, getter=wasRead) BOOL read;

@property (nonatomic, readonly) NSUInteger errorMessageSchemaVersion;

@end

#pragma mark -

@implementation TSErrorMessage

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self) {
        return self;
    }

    if (self.errorMessageSchemaVersion < 1) {
        _read = YES;
    }

    if (self.errorMessageSchemaVersion == 1) {
        NSString *_Nullable phoneNumber = [coder decodeObjectForKey:@"recipientId"];
        if (phoneNumber) {
            _recipientAddress = [[SignalServiceAddress alloc] initWithPhoneNumber:phoneNumber];
            OWSAssertDebug(_recipientAddress.isValid);
        }
    }

    _errorMessageSchemaVersion = TSErrorMessageSchemaVersion;

    if (self.isDynamicInteraction) {
        self.read = YES;
    }

    return self;
}

- (instancetype)initWithTimestamp:(uint64_t)timestamp
                         inThread:(TSThread *)thread
                failedMessageType:(TSErrorMessageType)errorMessageType
                          address:(nullable SignalServiceAddress *)address
{
    self = [super initMessageWithTimestamp:timestamp
                                  inThread:thread
                               messageBody:nil
                             attachmentIds:@[]
                          expiresInSeconds:0
                           expireStartedAt:0
                             quotedMessage:nil
                              contactShare:nil
                               linkPreview:nil
                            messageSticker:nil
                         isViewOnceMessage:NO];

    if (!self) {
        return self;
    }

    _errorType = errorMessageType;
    _recipientAddress = address;
    _errorMessageSchemaVersion = TSErrorMessageSchemaVersion;

    if (self.isDynamicInteraction) {
        self.read = YES;
    }

    return self;
}

- (instancetype)initWithTimestamp:(uint64_t)timestamp
                         inThread:(TSThread *)thread
                failedMessageType:(TSErrorMessageType)errorMessageType
{
    return [self initWithTimestamp:timestamp inThread:thread failedMessageType:errorMessageType address:nil];
}

- (instancetype)initWithEnvelope:(SSKProtoEnvelope *)envelope
                 withTransaction:(SDSAnyWriteTransaction *)transaction
               failedMessageType:(TSErrorMessageType)errorMessageType
{
    TSContactThread *contactThread =
        [TSContactThread getOrCreateThreadWithContactAddress:envelope.sourceAddress transaction:transaction];

    // Legit usage of senderTimestamp. We don't actually currently surface it in the UI, but it serves as
    // a reference to the envelope which we failed to process.
    return [self initWithTimestamp:envelope.timestamp inThread:contactThread failedMessageType:errorMessageType];
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                   attachmentIds:(NSArray<NSString *> *)attachmentIds
                            body:(nullable NSString *)body
                    contactShare:(nullable OWSContact *)contactShare
                 expireStartedAt:(uint64_t)expireStartedAt
                       expiresAt:(uint64_t)expiresAt
                expiresInSeconds:(unsigned int)expiresInSeconds
              isViewOnceComplete:(BOOL)isViewOnceComplete
               isViewOnceMessage:(BOOL)isViewOnceMessage
                     linkPreview:(nullable OWSLinkPreview *)linkPreview
                  messageSticker:(nullable MessageSticker *)messageSticker
                   quotedMessage:(nullable TSQuotedMessage *)quotedMessage
    storedShouldStartExpireTimer:(BOOL)storedShouldStartExpireTimer
              wasRemotelyDeleted:(BOOL)wasRemotelyDeleted
                       errorType:(TSErrorMessageType)errorType
                            read:(BOOL)read
                recipientAddress:(nullable SignalServiceAddress *)recipientAddress
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId
                     attachmentIds:attachmentIds
                              body:body
                      contactShare:contactShare
                   expireStartedAt:expireStartedAt
                         expiresAt:expiresAt
                  expiresInSeconds:expiresInSeconds
                isViewOnceComplete:isViewOnceComplete
                 isViewOnceMessage:isViewOnceMessage
                       linkPreview:linkPreview
                    messageSticker:messageSticker
                     quotedMessage:quotedMessage
      storedShouldStartExpireTimer:storedShouldStartExpireTimer
                wasRemotelyDeleted:wasRemotelyDeleted];

    if (!self) {
        return self;
    }

    _errorType = errorType;
    _read = read;
    _recipientAddress = recipientAddress;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (OWSInteractionType)interactionType
{
    return OWSInteractionType_Error;
}

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    switch (_errorType) {
        case TSErrorMessageNoSession:
            return NSLocalizedString(@"ERROR_MESSAGE_NO_SESSION", @"");
        case TSErrorMessageInvalidMessage:
            return NSLocalizedString(@"ERROR_MESSAGE_INVALID_MESSAGE", @"");
        case TSErrorMessageInvalidVersion:
            return NSLocalizedString(@"ERROR_MESSAGE_INVALID_VERSION", @"");
        case TSErrorMessageDuplicateMessage:
            return NSLocalizedString(@"ERROR_MESSAGE_DUPLICATE_MESSAGE", @"");
        case TSErrorMessageInvalidKeyException:
            return NSLocalizedString(@"ERROR_MESSAGE_INVALID_KEY_EXCEPTION", @"");
        case TSErrorMessageWrongTrustedIdentityKey:
            return NSLocalizedString(@"ERROR_MESSAGE_WRONG_TRUSTED_IDENTITY_KEY", @"");
        case TSErrorMessageNonBlockingIdentityChange: {
            if (self.recipientAddress) {
                NSString *messageFormat = NSLocalizedString(@"ERROR_MESSAGE_NON_BLOCKING_IDENTITY_CHANGE_FORMAT",
                    @"Shown when signal users safety numbers changed, embeds the user's {{name or phone number}}");

                NSString *recipientDisplayName =
                    [SSKEnvironment.shared.contactsManager displayNameForAddress:self.recipientAddress
                                                                     transaction:transaction];
                return [NSString stringWithFormat:messageFormat, recipientDisplayName];
            } else {
                // address will be nil for legacy errors
                return NSLocalizedString(
                    @"ERROR_MESSAGE_NON_BLOCKING_IDENTITY_CHANGE", @"Shown when signal users safety numbers changed");
            }
        }
        case TSErrorMessageUnknownContactBlockOffer:
            return NSLocalizedString(@"UNKNOWN_CONTACT_BLOCK_OFFER",
                @"Message shown in conversation view that offers to block an unknown user.");
        case TSErrorMessageGroupCreationFailed:
            return NSLocalizedString(@"GROUP_CREATION_FAILED",
                @"Message shown in conversation view that indicates there were issues with group creation.");
        default:
            OWSFailDebug(@"failure: unknown error type");
            break;
    }
    return NSLocalizedString(@"ERROR_MESSAGE_UNKNOWN_ERROR", @"");
}

+ (instancetype)corruptedMessageWithEnvelope:(SSKProtoEnvelope *)envelope
                             withTransaction:(SDSAnyWriteTransaction *)transaction
{
    return [[self alloc] initWithEnvelope:envelope
                          withTransaction:transaction
                        failedMessageType:TSErrorMessageInvalidMessage];
}

+ (instancetype)invalidVersionWithEnvelope:(SSKProtoEnvelope *)envelope
                           withTransaction:(SDSAnyWriteTransaction *)transaction
{
    return [[self alloc] initWithEnvelope:envelope
                          withTransaction:transaction
                        failedMessageType:TSErrorMessageInvalidVersion];
}

+ (instancetype)invalidKeyExceptionWithEnvelope:(SSKProtoEnvelope *)envelope
                                withTransaction:(SDSAnyWriteTransaction *)transaction
{
    return [[self alloc] initWithEnvelope:envelope
                          withTransaction:transaction
                        failedMessageType:TSErrorMessageInvalidKeyException];
}

+ (instancetype)missingSessionWithEnvelope:(SSKProtoEnvelope *)envelope
                           withTransaction:(SDSAnyWriteTransaction *)transaction
{
    return
        [[self alloc] initWithEnvelope:envelope withTransaction:transaction failedMessageType:TSErrorMessageNoSession];
}

+ (instancetype)nonblockingIdentityChangeInThread:(TSThread *)thread address:(SignalServiceAddress *)address
{
    // MJK TODO - should be safe to remove this senderTimestamp
    return [[self alloc] initWithTimestamp:[NSDate ows_millisecondTimeStamp]
                                  inThread:thread
                         failedMessageType:TSErrorMessageNonBlockingIdentityChange
                                   address:address];
}

#pragma mark - OWSReadTracking

- (uint64_t)expireStartedAt
{
    return 0;
}

- (BOOL)shouldAffectUnreadCounts
{
    return NO;
}

- (void)markAsReadAtTimestamp:(uint64_t)readTimestamp
                       thread:(TSThread *)thread
                 circumstance:(OWSReadCircumstance)circumstance
                  transaction:(SDSAnyWriteTransaction *)transaction
{
    OWSAssertDebug(transaction);

    if (self.read) {
        return;
    }

    OWSLogDebug(@"marking as read uniqueId: %@ which has timestamp: %llu", self.uniqueId, self.timestamp);

    [self anyUpdateErrorMessageWithTransaction:transaction
                                         block:^(TSErrorMessage *message) {
                                             message.read = YES;
                                         }];

    // Ignore `circumstance` - we never send read receipts for error messages.
}

- (BOOL)isSpecialMessage
{
    if (self.errorType == TSErrorMessageNonBlockingIdentityChange) {
        return YES;
    }
    return [super isSpecialMessage];
}

@end

NS_ASSUME_NONNULL_END
