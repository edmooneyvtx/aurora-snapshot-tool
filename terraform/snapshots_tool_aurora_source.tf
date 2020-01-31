

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

/*
	  tags = {
    Environment = var.environment
    Terraform   = "true"
    Cost_Center = module.tagging_variables.tagging_cost_center_di
    Application = module.tagging_variables.tagging_application_di
    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
    Project     = module.tagging_variables.project_tag
    Project_Id  = module.tagging_variables.project_id_tag
  }

*/

# sns allow 
/*
	"snsTopicSnapshotsAuroraToolDest": {
	"Condition": "SNSTopicIsEmpty",
	"Type": "AWS::SNS::Topic",

	"snspolicySnapshotsAuroraDest": {
	"Condition": "SNSTopicIsEmpty",
	"Type": "AWS::SNS::TopicPolicy",
*/
			

# include the tagging library
module tagging {
  source = "../../modules/tagging_variables"
}
			
# sns allow topic
resource "aws_sns_topic" "sns_dest_topic_allow" {
  name = "sns_dest_topic_allow"
	
  tags = {
	Environment = var.environment
	Terraform   = "true"
	Cost_Center = module.tagging_variables.tagging_cost_center_di
	Application = module.tagging_variables.tagging_application_di
	Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	Project     = module.tagging_variables.project_tag
	Project_Id  = module.tagging_variables.project_id_tag
  }
}

resource "aws_sns_topic_policy" "default" {
  arn = "${sns_dest_topic_allow.arn}"
  policy = "${data.aws_iam_policy_document.sns_dest_topic_allow_policy.json}"
	
  tags = {
    Environment = var.environment
    Terraform   = "true"
    Cost_Center = module.tagging_variables.tagging_cost_center_di
    Application = module.tagging_variables.tagging_application_di
    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
    Project     = module.tagging_variables.project_tag
    Project_Id  = module.tagging_variables.project_id_tag
  }
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
		




# ==============   Resources needed:


/*
      "alarmcwCopyFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",
			"Properties": {
        
        "alarmcwDeleteOldFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",
			"Condition": "DeleteOld",
		
		complete... below when resources filled out.
		
*/		

		
resource "aws_cloudwatch_metric_alarm" "copy_failed" {
	alarm_name         = "copy_failed"
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
	
	tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }

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
	
        tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }
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
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }

	}

          
 /*         
          "lambdaCopySnapshotsAurora": {
			"Type": "AWS::Lambda::Function",
            

*/

resource "aws_iam_role" "iam_for_lambda" {
  name = "CopySnapshotsAurora"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "exports.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs8.10"

  environment {
    variables = {
      foo = "bar"
    }
  }
}



/*
            
"lambdaDeleteOldDestAurora": {
	"Type": "AWS::Lambda::Function",
	"Condition": "DeleteOld",
*/
					
					
					

resource "aws_iam_role" "iam_for_lambda" {
  name = "DeleteOldDestAurora"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "exports.test"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("lambda_function_payload.zip")}"

  runtime = "nodejs8.10"

  environment {
    variables = {
      foo = "bar"
    }
  }
}



 
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
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
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

	  tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }

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


	  tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }

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
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
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


	tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }
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


        tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }
	}

	resource "aws_cloudwatch_event_target" "sns" {
	  rule      = "${aws_cloudwatch_event_rule.console.name}"
	  target_id = "SendToSNS"
	  arn       = "${aws_sns_topic.aws_logins.arn}"


	 tags = {
	    Environment = var.environment
	    Terraform   = "true"
	    Cost_Center = module.tagging_variables.tagging_cost_center_di
	    Application = module.tagging_variables.tagging_application_di
	    Sub_Systems = module.tagging_variables.tagging_sub_systems_di
	    Project     = module.tagging_variables.project_tag
	    Project_Id  = module.tagging_variables.project_id_tag
	  }

	}


