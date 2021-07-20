$describetemplate = "aws ec2 describe-launch-templates"
$terminate = "aws ec2 Remove-EC2Instance -InstanceId i-06fab3aef78acf0cf -Force"

#Invoke-Expression $Command
 
#aws ec2 run-instances --launch-template LaunchTemplateId=lt-0a7bab162b38d866f

Invoke-Expression $describetemplate


ConvertFrom-Json
                [-InputObject] <String>
                [-AsHashtable]
                [-Depth <Int32>]
                [-NoEnumerate]
                [<CommonParameters>]