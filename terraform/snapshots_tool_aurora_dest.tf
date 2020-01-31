#


Terraform needed:

SNS snapshot topic: name: topic_aurora_tool_dest": "Type": "AWS::SNS::Topic",
- policy_doc for SNS: "Type": "AWS::SNS::TopicPolicy",

"Type": "AWS::CloudWatch::Alarm",

		"alarmcwCopyFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",

alarmcwDeleteOldFailedDest": {
			"Type": "AWS::CloudWatch::Alarm",

		"iamroleSnapshotsAurora": {
			"Type": "AWS::IAM::Role",

		"lambdaCopySnapshotsAurora": {
			"Type": "AWS::Lambda::Function",

            		"lambdaDeleteOldDestAurora": {
			"Type": "AWS::Lambda::Function",


		"iamroleStateExecution": {
			"Type": "AWS::IAM::Role",


		"statemachineCopySnapshotsDestAurora": {
			"Type": "AWS::StepFunctions::StateMachine",

            		"statemachineDeleteOldSnapshotsDestAurora": {
			"Type": "AWS::StepFunctions::StateMachine",
			"Condition": "DeleteOld",
