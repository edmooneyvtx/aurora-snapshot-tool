
# vars


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


	variable "LambdaFunctionName" {
				type = string
				description = "Name of the payload for lambda"
				default = ""
	}

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
