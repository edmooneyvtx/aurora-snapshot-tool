# 

Terraform:

TFVARS needed:

"Parameters": {
		"CodeBucket": {
			"Type": "String",
			"Default": "DEFAULT_BUCKET",
			"Description": "Name of the bucket that contains the lambda functions to deploy. Leave the default value to download the code from the AWS Managed buckets"
		},
		"SnapshotPattern": {
			"Type": "String",
			"Default": "ALL_SNAPSHOTS",
			"Description": "Python regex for matching cluster identifiers to backup. Use \"ALL_SNAPSHOTS\" to back up every Aurora cluster in the region."
		},
		"RetentionDays": {
			"Type": "Number",
			"Default": "7",
			"Description": "Number of days to keep snapshots in retention before deleting them"
		},
		"DestinationRegion": {
			"Type": "String",
			"Description": "Destination region for snapshots."
		},
		"LogLevel": {
			"Type": "String",
			"Default": "ERROR",
			"Description": "Log level for Lambda functions (DEBUG, INFO, WARN, ERROR, CRITICAL are valid values)."
		},
		"SourceRegionOverride": {
			"Type": "String",
			"Default": "NO",
			"Description": "Set to the region where your Aurora clusters run, only if such region does not support Step Functions. Leave as NO otherwise"
		},
		"KmsKeyDestination": {
			"Type": "String",
			"Default": "None",
			"Description": "Set to the ARN for the KMS key in the destination region to re-encrypt encrypted snapshots. Leave None if you are not using encryption"
		},
		"KmsKeySource": {
			"Type": "String",
			"Default": "None",
			"Description": "Set to the ARN for the KMS key in the SOURCE region to re-encrypt encrypted snapshots. Leave None if you are not using encryption"
		},
		"DeleteOldSnapshots": {
			"Type": "String",
			"Default": "TRUE",
			"Description": "Set to TRUE to enable deletion of snapshot based on RetentionDays. Set to FALSE to disable",
			"AllowedValues": ["TRUE", "FALSE"]
		},
		"CrossAccountCopy": {
			"Type": "String",
			"AllowedValues": ["TRUE", "FALSE"],
			"Default": "TRUE",
			"Description": "Enable copying snapshots across accounts. Set to FALSE if your source snapshosts are not on a different account"
		},
		"SNSTopic": {
			"Type": "String",
			"Default": "",
			"Description": "If you have a topic that you would like subscribed to notifications, enter it here. If empty, the tool will create a new topic"
		}
	},
	"Conditions": {
		"DefaultBucket": {
			"Fn::Equals": [{
				"Ref": "CodeBucket"
			}, "DEFAULT_BUCKET"]
		},
		"DeleteOld": {
			"Fn::Equals": [{
				"Ref": "DeleteOldSnapshots"
			}, "TRUE"]
		},
		"CrossAccount": {
			"Fn::Equals": [{
				"Ref": "CrossAccountCopy"
			}, "TRUE" ]
		},
		"SNSTopicIsEmpty": {
			"Fn::Equals": [{
				"Ref": "SNSTopic"
			}, ""]
		}
	},
	"Mappings": {
		"Buckets": {
			"us-east-1": {
				"Bucket": "snapshots-tool-aurora-us-east-1"
			},
			"us-west-2": {
				"Bucket": "snapshots-tool-aurora-us-west-2"
			},
			"us-east-2": {
				"Bucket": "snapshots-tool-aurora-us-east-2"
			},
			"ap-southeast-2": {
				"Bucket": "snapshots-tool-aurora-ap-southeast-2"
			},
			"ap-northeast-1": {
				"Bucket": "snapshots-tool-aurora-ap-northeast-1"
			},
			"eu-west-1": {
				"Bucket": "snapshots-tool-aurora-eu-west-1"
			},
			"eu-west-2": {
				"Bucket": "snapshots-tool-aurora-eu-west-2-real"
			},
			"eu-central-1": {
				"Bucket": "snapshots-tool-aurora-eu-central-1"
			},
			"us-west-1": {
				"Bucket": "snapshots-tool-aurora-us-west-1"
			},
			"eu-west-3": {
				"Bucket": "snapshots-tool-aurora-eu-west-3"
			},
			"ap-south-1": {
				"Bucket": "snapshots-tool-aurora-ap-south-1"
			},
			"ap-southeast-1": {
				"Bucket": "snapshots-tool-aurora-ap-southeast-1"
			},
			"ap-northeast-2": {
				"Bucket": "snapshots-tool-aurora-ap-northeast-2"
			},
			"ca-central-1": {
				"Bucket": "snapshots-tool-aurora-ca-central-1"
			},
			"sa-east-1": {
				"Bucket": "snapshots-tool-aurora-sa-east-1"
			}
		}
	},

Resources needed:



		"snsTopicSnapshotsAuroraToolDest": {
			"Condition": "SNSTopicIsEmpty",
			"Type": "AWS::SNS::Topic",
      
  	"snspolicySnapshotsAuroraDest": {
			"Condition": "SNSTopicIsEmpty",
			"Type": "AWS::SNS::TopicPolicy",
      
      "alarmcwCopyFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",
			"Properties": {
        
        "alarmcwDeleteOldFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",
			"Condition": "DeleteOld",
          
          "iamroleSnapshotsAurora": {
			"Type": "AWS::IAM::Role",
			"Properties": {
				"AssumeRolePolicyDocument": {
          
          
          "lambdaCopySnapshotsAurora": {
			"Type": "AWS::Lambda::Function",
            
            
            "lambdaDeleteOldDestAurora": {
			"Type": "AWS::Lambda::Function",
			"Condition": "DeleteOld",
              
              
              "iamroleStateExecution": {
			"Type": "AWS::IAM::Role",
			"Properties": {
				"AssumeRolePolicyDocument": {
          
          "statemachineCopySnapshotsDestAurora": {
			"Type": "AWS::StepFunctions::StateMachine",
			"Properties": {
        
        
        "statemachineDeleteOldSnapshotsDestAurora": {
			"Type": "AWS::StepFunctions::StateMachine",
			"Condition": "DeleteOld",
          
          "iamroleStepInvocation": {
			"Type": "AWS::IAM::Role",
			"Properties": {
        
        "cwEventCopySnapshotsAurora": {
			"Type": "AWS::Events::Rule",
			"Properties": {
        
        
        "cwEventDeleteOldSnapshotsAurora": {
			"Type": "AWS::Events::Rule",
			"Condition": "DeleteOld",


