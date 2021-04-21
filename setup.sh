#!/bin/bash

# name="$1"
# email="$2"

# say 'configuring O.S settings
# defaults write -g ApplePressAndHoldEnabled -bool false
# defaults write -g CGDisableCursorLocationMagnification -bool true
# defaults write -g KeyRepeat -int 2
# defaults write -g InitialKeyRepeat -int 15


# say 'Installing home brew'
# install homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew update
# export PATH="/usr/local/bin:$PATH"


# say 'Installing node'
# brew install node
# npm install --global eslint
# npm install --global jsonlint


# say 'Configuring Git'
# echo -e "[user]\nname = $name\nemail = $email" > ~/.gitconfig
# npm install --global git-open


# say 'Installing VS Code'
# brew cask install visual-studio-code


# say 'Installing Spotify'
# brew cask install spotify


# say 'Installing VPN tools'
# brew install openvpn
# sudo brew services start openvpn
# brew cask reinstall tunnelblick


# say 'Installing Terraform'
# brew install warrensbox/tap/tfswitch
# brew install terraform-docs


# say 'Installing A.W.S  C.L.I tools'
# brew install awscli
# npm i -g aws-azure-login
# mkdir ~/.aws
# cat > ~/.aws/config <<EOF
# [default]
# azure_tenant_id=$tenant_id
# azure_app_id_uri=https://signin.aws.amazon.com/saml\#2
# azure_default_username=$email
# azure_default_role_arn=arn:aws:iam::$aws_account:role/$role
# azure_default_duration_hours=12
# azure_default_remember_me=true
# EOF
# echo 'alias sso="aws-azure-login --mode gui"' >> ~/.bash_profile


# say 'Installing Prometheus Alert Diff'
# brew install watch
# npm i -g prometheus-alert-diff
# echo 'export PROMETHEUS_SERVERS="https://prometheus.dev.ctmers.io https://prometheus.test.ctmers.io https://prometheus.prod.ctmers.io https://prometheus-app-test.sergeis-datacenter.co.uk https://prometheus-host-test.sergeis-datacenter.co.uk https://prometheus-app.meer-spacestation.co.uk https://prometheus-host.meer-spacestation.co.uk"' >> ~/.bash_profile
# echo 'alias prom-diff="watch --color prometheus-alert-diff"' >> ~/.bash_profile


# say 'Installing draw.io'
# brew cask install drawio


# say 'Installing whatsapp'
# brew cask install whatsapp


# say 'Installing GraphiQL'
# brew cask install graphiql


# say 'Installing JQ'
# brew install jq


# say 'Installing powershell'
# brew cask install powershell


# say 'Installing Session Manager Plugin'
# curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
# unzip sessionmanager-bundle.zip
# sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
# rm -rf sessionmanager-bundle.zip sessionmanager-bundle/


# say 'Installing W get'
# brew install wget


# say 'Installing Consul'
# brew install consul


# say 'Installing tree'
# brew install tree


# say 'Installing Go'
# brew install golang
# mkdir -p ~/go/{bin,src/github.com/TomY8s}
# echo -e "\n\n# Go lang" >> ~/Documents/.bash_profile
# echo 'export GOPATH=$HOME/go' >> ~/Documents/.bash_profile
# echo 'export PATH=$PATH:$GOPATH/bin' >> ~/Documents/.bash_profile


# say 'Installing GPG'
# brew install gnupg


# say 'Installing YQ'
# brew install yq

# say 'Installing ECS CLI'
# sudo curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-darwin-amd64-latest


# say 'Installing Packer'
# brew tap hashicorp/tap
# brew install hashicorp/tap/packer

say 'All tasks complete'

