

# Terraform:

buckets = {
us-east-1 = "snapshots-tool-aurora-us-east-1"
us-west-2 = "snapshots-tool-aurora-us-west-2"
us-east-2 = "snapshots-tool-aurora-us-east-2"
ap-southeast-2 = "snapshots-tool-aurora-ap-southeast-2"
ap-northeast-1 = "snapshots-tool-aurora-ap-northeast-1"
eu-west-1 = "snapshots-tool-aurora-eu-west-1"
eu-west-2 = "snapshots-tool-aurora-eu-west-2-real"
eu-central-1 = "snapshots-tool-aurora-eu-central-1"
us-west-1 = "snapshots-tool-aurora-us-west-1"
eu-west-3 = "snapshots-tool-aurora-eu-west-3"
ap-south-1 = "snapshots-tool-aurora-ap-south-1"
ap-southeast-1 = "snapshots-tool-aurora-ap-southeast-1"
ap-northeast-2 = "snapshots-tool-aurora-ap-northeast-2"
ca-central-1 = "snapshots-tool-aurora-ca-central-1"
sa-east-1 = "snapshots-tool-aurora-sa-east-1"
}

# sns allow 
/*
	"snsTopicSnapshotsAuroraToolDest": {
	"Condition": "SNSTopicIsEmpty",
	"Type": "AWS::SNS::Topic",

	"snspolicySnapshotsAuroraDest": {
	"Condition": "SNSTopicIsEmpty",
	"Type": "AWS::SNS::TopicPolicy",
*/
			
# sns allow topic
resource "aws_sns_topic" "sns_dest_topic_allow" {
  name = "sns_dest_topic_allow"
}

resource "aws_sns_topic_policy" "default" {
  arn = "${sns_dest_topic_allow.arn}"
  policy = "${data.aws_iam_policy_document.sns_dest_topic_allow_policy.json}"
}


			
# sns allow policy doc. json
data "aws_iam_policy_document" "sns_dest_topic_allow_policy" {
    policy_id = "__default_policy_ID"
    effect = "Allow"
    principals {
        type = "AWS"
        identifiers = ["*"]
    }

    statement {
        actions = [
            "SNS:GetTopicAttributes",
            "SNS:SetTopicAttributes",
            "SNS:AddPermission",
            "SNS:RemovePermission",
            "SNS:DeleteTopic",
            "SNS:Subscribe",
            "SNS:ListSubscriptionsByTopic",
            "SNS:Publish",
            "SNS:Receive",
        ]
    
        condition {
            test = "StringEquals"
            variable = "AWS:SourceOwner"
        # confirm w/ role switch
            values = [
                var.account_id,
            ]
        }
    }
}
		
/* end sns allow */		
		




	variable "CodeBucket" {
				type = string
				default =  "DEFAULT_BUCKET"
				description = "Name of the bucket that contains the lambda functions to deploy. Leave the default value to download the code from the AWS Managed buckets"
			},
	variable "SnapshotPattern" {
				type = string
				default =  "ALL_SNAPSHOTS"
				description = "Python regex for matching cluster identifiers to backup. Use \"ALL_SNAPSHOTS\" to back up every Aurora cluster in the region."
			},
	variable "RetentionDays" {
				type = number
				default =  7
				description = "Number of days to keep snapshots in retention before deleting them"
			},
	variable "DestinationRegion" {
				type = string
				description = "Destination region for snapshots."
			},
	variable "LogLevel" {
				type = string
				default =  "ERROR"
				description = "Log level for Lambda functions (DEBUG, INFO, WARN, ERROR, CRITICAL are valid values)."
			},
	variable "SourceRegionOverride" {
				type = string
				default =  "NO"
				description = "Set to the region where your Aurora clusters run, only if such region does not support Step Functions. Leave as NO otherwise"
			},
	variable "KmsKeyDestination" {
				type = string
				default =  null
				description = "Set to the ARN for the KMS key in the destination region to re-encrypt encrypted snapshots. Leave None if you are not using encryption"
			},
	variable "KmsKeySource" {
				type = string
					default =  null
				description = "Set to the ARN for the KMS key in the SOURCE region to re-encrypt encrypted snapshots. Leave None if you are not using encryption"
			},
	variable "DeleteOldSnapshots" {
				type = string
				default =  "TRUE"
				description = "Set to TRUE to enable deletion of snapshot based on RetentionDays. Set to FALSE to disable"
				"AllowedValues": ["TRUE" "FALSE"]
			},
	variable "CrossAccountCopy" {
				type = string
				"AllowedValues": ["TRUE" "FALSE"],
				default =  "TRUE"
				description = "Enable copying snapshots across accounts. Set to FALSE if your source snapshosts are not on a different account"
			},
	variable "SNSTopic" {
				type = string
				default =  ""
				description = "If you have a topic that you would like subscribed to notifications, enter it here. If empty, the tool will create a new topic"
			}


# ==============   Resources needed:


/*
      "alarmcwCopyFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",
			"Properties": {
        
        "alarmcwDeleteOldFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",
			"Condition": "DeleteOld",
		
		
- complete... below when resources filled out.
		
*/		

		
resource "aws_cloudwatch_metric_alarm" "copy_failed" {
	alarm_description  =  "DB Copy to destination status",
	actions_enabled  =  "true",
	comparison_operator  =  "GreaterThanOrEqualToThreshold",
	evaluation_periods  =  "1",
	metric_name  =  "ExecutionsFailed",
	namespace  =  "AWS/States",
	period  =  "300",
	statistic  =  "Sum",
	threshold  =  "2.0",
	treatMissingData  =  "ignore",
	alarm_actions = "@todo"
	ok_actions = "@todo"
	insufficient_data_actions = [@todo]
	dimensions = [ @todo
		name = "StateMachineArn"
		value = "${"Ref: statemachineCopySnapshotsDestAurora"}"
	]

}


resource "aws_cloudwatch_metric_alarm" "delete_old_failed" {
	alarm_name                = "delete_old_failed"
	comparison_operator       = "GreaterThanOrEqualToThreshold"
	evaluation_periods        = "2"
	metric_name               = "CPUUtilization"
	namespace                 = "AWS/EC2"
	period                    = "120"
	statistic                 = "Average"
	threshold                 = "80"
	alarm_description         = "This metric monitors ec2 cpu utilization"
	insufficient_data_actions = []
}
		
		
  /*        
          "iamroleSnapshotsAurora": {
			"Type": "AWS::IAM::Role",
			"Properties": {
				"AssumeRolePolicyDocument": {
					
*/
	resource "aws_iam_role" "test_role" {
	  name = "test_role"

	  assume_role_policy = <<EOF
	{
	  "Version": "2012-10-17",
	  "Statement": [
	    {
	      "Action": "sts:AssumeRole",
	      "Principal": {
		"Service": "ec2.amazonaws.com"
	      },
	      "Effect": "Allow",
	      "Sid": ""
	    }
	  ]
	}
	EOF

	  tags = {
	    tag-key = "tag-value"
	  }
	}

          
          
          "lambdaCopySnapshotsAurora": {
			"Type": "AWS::Lambda::Function",
            
            
            "lambdaDeleteOldDestAurora": {
			"Type": "AWS::Lambda::Function",
			"Condition": "DeleteOld",
 
/*
              
              "iamroleStateExecution": {
			"Type": "AWS::IAM::Role",
			"Properties": {
				"AssumeRolePolicyDocument": {
*/

	resource "aws_iam_role" "test_role" {
	  name = "test_role"

	  assume_role_policy = <<EOF
	{
	  "Version": "2012-10-17",
	  "Statement": [
	    {
	      "Action": "sts:AssumeRole",
	      "Principal": {
		"Service": "ec2.amazonaws.com"
	      },
	      "Effect": "Allow",
	      "Sid": ""
	    }
	  ]
	}
	EOF

	  tags = {
	    tag-key = "tag-value"
	  }
	}

	/*
          "statemachineCopySnapshotsDestAurora": {
			"Type": "AWS::StepFunctions::StateMachine",
			"Properties": {
 	*/

	resource "aws_sfn_state_machine" "sfn_state_machine" {
	  name     = "statemachineCopySnapshotsDestAurora"
	  role_arn = "${aws_iam_role.iam_for_sfn.arn}"

	  definition = <<EOF
	{
	  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
	  "StartAt": "HelloWorld",
	  "States": {
	    "HelloWorld": {
	      "Type": "Task",
	      "Resource": "${aws_lambda_function.lambda.arn}",
	      "End": true
	    }
	  }
	}
	EOF
	}

        /*
        "statemachineDeleteOldSnapshotsDestAurora": {
			"Type": "AWS::StepFunctions::StateMachine",
			"Condition": "DeleteOld",
	*/

	resource "aws_sfn_state_machine" "sfn_state_machine" {
	  name     = "statemachineDeleteOldSnapshotsDestAurora"
	  role_arn = "${aws_iam_role.iam_for_sfn.arn}"

	  definition = <<EOF
	{
	  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
	  "StartAt": "HelloWorld",
	  "States": {
	    "HelloWorld": {
	      "Type": "Task",
	      "Resource": "${aws_lambda_function.lambda.arn}",
	      "End": true
	    }
	  }
	}
	EOF
	}


/*
          "iamroleStepInvocation": {
			"Type": "AWS::IAM::Role",
			"Properties": {
*/

	resource "aws_iam_role" "test_role" {
	  name = "test_role"

	  assume_role_policy = <<EOF
	{
	  "Version": "2012-10-17",
	  "Statement": [
	    {
	      "Action": "sts:AssumeRole",
	      "Principal": {
		"Service": "ec2.amazonaws.com"
	      },
	      "Effect": "Allow",
	      "Sid": ""
	    }
	  ]
	}
	EOF

	  tags = {
	    tag-key = "tag-value"
	  }
	}


    /*    

        "cwEventCopySnapshotsAurora": {
			"Type": "AWS::Events::Rule",
			"Properties": {
*/

	resource "aws_cloudwatch_event_rule" "console" {
	  name        = "cwEventCopySnapshotsAurora"
	  description = "Capture each AWS Console Sign In"

	  event_pattern = <<PATTERN
	{
	  "detail-type": [
	    "AWS Console Sign In via CloudTrail"
	  ]
	}
	PATTERN
	}

	resource "aws_cloudwatch_event_target" "sns" {
	  rule      = "${aws_cloudwatch_event_rule.console.name}"
	  target_id = "SendToSNS"
	  arn       = "${aws_sns_topic.aws_logins.arn}"
	}

        
        /*

        "cwEventDeleteOldSnapshotsAurora": {
			"Type": "AWS::Events::Rule",
			"Condition": "DeleteOld",
*/
	resource "aws_cloudwatch_event_rule" "console" {
	  name        = "cwEventCopySnapshotsAurora"
	  description = "Capture each AWS Console Sign In"

	  event_pattern = <<PATTERN
	{
	  "detail-type": [
	    "AWS Console Sign In via CloudTrail"
	  ]
	}
	PATTERN
	}

	resource "aws_cloudwatch_event_target" "sns" {
	  rule      = "${aws_cloudwatch_event_rule.console.name}"
	  target_id = "SendToSNS"
	  arn       = "${aws_sns_topic.aws_logins.arn}"
	}


