
# vars




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
