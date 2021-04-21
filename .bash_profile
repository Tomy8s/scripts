# Git
alias gb="git branch"

function gc () {
	if [ -z $1 ]
	then
		git checkout master
		return
	fi


	if [ $# -gt 1 ]
	then
		git checkout $@
		return
	fi


	branch=`git branch | grep "$1" | sed 's/[ \*]//g'`
	num_branches=`wc -l <<< "$branch"`


	if [ $num_branches -gt 1 ]
	then
		echo "More than one branch matches \"$1\":"
		echo -e "\n\033[32m$branch\033[0m\n"
		echo "Please by more specific."
		return
	fi


	git checkout "$branch"
}

alias gd="git stash && git checkout master && git branch | grep -v '*' | xargs git branch -d"
alias pull="git pull"
alias push="git push"

function push0() {
	branch="$(git branch | grep '*' | cut -d ' ' -f 2)"
	git push -u origin $branch
}

# For fat fingers
alias nom="npm"
alias gti="git"


function dev-sg() {
	[ -d ~/.aws/temp/ ] || mkdir ~/.aws/temp/
	cp ~/.aws/{config,credentials} ~/.aws/temp/
	sso dev
	AWS_REGION=us-east-1 aws ec2 authorize-security-group-ingress --group-id sg-5f1bb923 --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=443,IpRanges='[{CidrIp=90.240.0.0/12,Description="TomY8s home"}]'
	cp ~/.aws/temp/{config,credentials} ~/.aws/
}


function connect() {
	# Usage: `connect instance-id|private-dns-name|instance-name`
	if [[ "$1" =~ "^i-" ]]
	then
		# Useful when `connect <name>` returns multiple results
		echo "Connecting with instance ID \"$1\""
		aws ssm start-session --target "$1"
	else
		if [[ "$1" =~ "^ip-" ]]
		then
			# Useful after running `kubectl get nodes`
			echo "Searching for instance based on Private DNS Name \"$1\"..."
			filter="Name=private-dns-name,Values=$1*"
		else
			# Useful when you only know (or guess!) the instance name
			echo "Searching for instance based on Name \"$1\"..."
			filter="Name=tag:Name,Values=*$1*"
		fi

		instances="$(aws ec2 describe-instances --filter $filter --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value]' --output text)"
		names="$(echo $instances | grep -v '^i-')"
		instance_count="$(wc -l <<< $names)"
		if [[ -z $names ]]
		then
			echo "No instance names found that match \"$1\""
		elif [[ $instance_count -eq 1 ]]
		then
			instance_id="$(echo $instances | grep '^i-')"
			aws ssm start-session --target "$instance_id"
		else
			echo "Found more than one matching instancee:"
			echo "$instances"
		fi
	fi
}


function goenc() {
	value=$(curl -s "https://${2:=paas}.cicd.ctmers.io:8154/go/api/admin/encrypt" \
		-u "$GO_USER:$GO_PASS" \
		-H 'Accept: application/vnd.go.cd.v1+json' \
		-H 'Content-Type: application/json' \
		-X POST -d "{\"value\": \"$1\"}" | jq -r .encrypted_value)

	pbcopy <<< "$value"
	echo "The following value has be copied to the clipboard:"
	echo $value
}


function tfs () {
	if [[ "$1" == "" ]]
	then
		version="$(cat .terraform_version)"
	else
		version="$1"
	fi

	tfswitch $version
}


function gac() {
	root_dir=$(git rev-parse --show-toplevel)
	git add ${root_dir}/*
	git commit -m $@
}


function valid-meta() {
	metadata_file="service.metadata.json"


	if [[ ! -e $metadata_file ]]
	then
		echo "$(pwd)/${metadata_file} not found"
		return 1
	fi


	response=$(curl \
		-s \
		-X POST \
		-H "Content-Type: application/json" \
		-d @service.metadata.json \
		"https://engineering-service-catalogue-api.maiya.io/metadata/validate")


	if [[ "$response" == "OK" ]]
	then
		echo "✅ Your metadata is valid"
		return 0
	else
		echo "❗ The following errors were found:"
		echo $response | jq
		return 1
	fi
}


function upload-meta() {
	echo "Validating..."
	valid-meta
	validation_result="$?"


	if [[ $validation_result != "0" ]]
	then
		return $validation_result
	fi


	case "$1" in
		test | uat)
			host="engineering-service-catalogue-api-uat.vassily.io" ;;
		prod)
			host="engineering-service-catalogue-api.maiya.io" ;;
		*)
			echo "Please specify a valid environment"
			return 2 ;;
	esac


	echo "Uploading to ${host}..."


	curl \
                -X POST \
                -H "Content-Type: application/json" \
                -d @service.metadata.json \
		 "https://${host}/services/metadata/${PWD##*/}"
}


function sso() {
	if [ -z "$1" ]
	then
		# Have to add functionality to aws-azure-login to make this work
		aws-azure-login --no-prompt
		return
	fi

	account_details_dir=~/.aws/accounts/$1
	if [ -d "$account_details_dir" ]
	then
		echo "Found existing credentials, testing validity..."
		cp $account_details_dir/{config,credentials} ~/.aws/
		aws sts get-caller-identity &> /dev/null
		if [ $? -eq 0 ]
		then
			echo "Existing credentials still valid."
			return 0
		fi
	else
		echo "First time using these creds, creating new dir at \"$account_details_dir\""
		mkdir -p $account_details_dir
	fi

		
	aws_account_ids='{
		"main": "482506117024",
		"dev": "029718257588",
		"test": "038452852957",
		"nonprod": "038452852957",
		"non-prod": "038452852957",
		"load": "038452852957",
		"uat": "038452852957",
		"staging": "038452852957",
		"shadow": "038452852957",
		"prod": "631977481591",
		"dr": "207498761283",
		"datanonprod": "207220154943",
		"dataprod": "077201780497",
		"paasnonprod": "650525879627",
		"paastest": "650525879627",
		"paasprod": "652661650227",
		"ngdpnonprod": "169858336832",
		"ngdpprod": "861394373581"
	}'

	account_id=$(jq -r ".$1" <<< $aws_account_ids)
	export AZURE_DEFAULT_ROLE_ARN="arn:aws:iam::${account_id}:role/ctm-cloud-platform" 
	echo "No valid credentials found for $1. Re-authentication necessary for account \"$AZURE_DEFAULT_ROLE_ARN\""
	aws-azure-login --no-prompt

	cp ~/.aws/{config,credentials} $account_details_dir/
}


export PROMETHEUS_SERVERS="https://prometheus.dev.ctmers.io https://prometheus.test.ctmers.io https://prometheus.prod.ctmers.io https://prometheus-app-test.sergeis-datacenter.co.uk https://prometheus-host-test.sergeis-datacenter.co.uk https://prometheus-app.meer-spacestation.co.uk https://prometheus-host.meer-spacestation.co.uk"

# npm install --global prometheus-alert-diff
# Contributions welcome: https://github.com/Tomy8s/prometheus-alert-diff
alias prom-diff="watch --color prometheus-alert-diff"

function awsacc() {
	account="$1"
	if [[ -d ~/.aws/accounts/${account} ]]
	then
		unset AWS_SESSION_TOKEN
		unset AWS_ACCESS_KEY_ID
		unset AWS_SECRET_ACCESS_KEY
		cp ~/.aws/accounts/${account}/* ~/.aws/
	else
		echo "no credentials found for $account"
	fi
}

# AWS
export AWS_REGION="eu-west-1"

# GitHub
export GITHUB_TOKEN=""

# GoCD
export GO_USER=""
export GO_PASS=""

# observability.prometheus-cloudflare-exporter
export CLOUDFLARE_EMAIL=""
export CLOUDFLARE_KEY=""
export CLOUDFLARE_URI="https://api.cloudflare.com/client/v4/graphql"
export CLOUDFLARE_STATUS_URI="https://yh6f0r4529hb.statuspage.io/api/v2/summary.json"
export ENVIRONMENT="localhost"


# observability.monitoring-auditor
export SERVICE_CATALOGUE_URL="https://engineering-service-catalogue-api.maiya.io/services/metadata"
export PROMETHEUS_CTMERS_URL="https://prometheus.prod.ctmers.io/api/v1/"
export PROMETHEUS_MAIN_URL="https://prometheus.meer-spacestation.co.uk/api/v1/"
export S3_ENV="dev"


# infrastructure.cloudflare
export TF_VAR_cloudflare_api_token=""
export TF_VAR_cloudflare_account_id=""


# account.infrastructure/kubernetes
export TF_VAR_rancher_access_key=""
export TF_VAR_rancher_secret_key=""

# route53
export HOSTED_ZONE_ID=""


# Go lang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin


export AZURE_DEFAULT_PASSWORD=`base64 -d <<< =`
