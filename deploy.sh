#!/bin/bash

# This script builds and deploys a Jekyll site to staging and live.
# If the latest commit is tagged and the tag starts with 'release',
# it deploys the existing build (in _site) to live (i.e. production).
# Otherwise it builds the site and deploys it to the staging server.
# Along with test.sh, it can also deploy previews to subdirectories,
# when you tag a commit with a tag starting with 'preview'.
#
# To set up: in your continuous-deployment service's settings,
# add these environment variables, using your server details:

# DEPLOY_METHOD_LIVE
# DEPLOY_METHOD_STAGING
# DEPLOY_METHOD_PREVIEWS

# DESTINATIONPATH_STAGING
# DESTINATIONPATH_LIVE
# DESTINATIONPATH_PREVIEWS

# If using SSH:
# SSH_STAGING
# SSH_LIVE
# SSH_PREVIEWS

# Optionally, if your host
# uses a non-standard SSH port
# SSH_STAGING_PORT
# SSH_LIVE_PORT
# SSH_PREVIEWS_PORT

# If using FTP:
# FTP_HOST_LIVE
# FTP_USER_LIVE
# FTP_PASSWORD_LIVE
# FTP_HOST_PREVIEWS
# FTP_USER_PREVIEWS
# FTP_PASSWORD_PREVIEWS
# FTP_HOST_STAGING
# FTP_USER_STAGING
# FTP_PASSWORD_STAGING

# Notes on each of these below.

# DEPLOY_METHOD...
# Set the method for each destination to SSH or LFTP.
# SSH is faster (with rsync) but requires higher-level server access.
# LFTP is the default, if a given DEPLOY_METHOD is not set.

# DESTINATIONPATH...
# e.g. public_html
# Very often, this will be the public_html folder on your server.
# Do not include a slash at the end. If SSH, and your user connects # directly to the destination folder, then leave this empty or do not set it.
# The _PREVIEWS path sets the directory where previews will be deployed. This is often public_html.

# SSH_PREVIEWS, e.g. username@example.com
# SSH_STAGING, e.g. username@staging.example.com
# SSH_LIVE, e.g. username@example.com
# These are only necessary for SSH deployment (uses rsync).

# FTP... variables are only necessary for FTP deployment (uses LFTP).
# Set these for each of your destination servers.


echo "Starting deployment..."

# Unshallow to get tags
if [ -f ${HOME}/clone/.git/shallow ];
then
    git fetch --unshallow || true
fi

# Get the short hash of the latest commit
commit=$(git log --pretty=format:"%h" -n 1^ 2>&1)

# Get the tag on the last commit
tag=$(git describe --tags --exact-match $commit 2>&1)

# Get commit author
committer=$(git show --format="%aN <%aE>" $commit)

# Get the time this script was run
timestamp=$(date +%Y-%m-%d:%H-%M-%S)

# Set the path and name for the deploy-version file
version_file="$HOME/cache/_site/deploy-version-$commit.txt"

# Set the default SSH port
ssh_port="22"

# If the tag starts with 'release',
# then deploy the latest build to live (i.e. production).
# Otherwise, deploy to staging.
if [[ $tag* =~ ^release.*$ ]]
then

    # Add the release tag name and new date to the deploy-version file
    echo "Release tag: $tag" >> "$version_file"
    echo "Deployed to live: $timestamp" >> "$version_file"

    # Sync the cached built files to the live server
    echo "Deploying $tag to live server..."

    if [[ $DEPLOY_METHOD_LIVE == "SSH" ]]
    then

        if [[ -n $SSH_LIVE_PORT ]]
        then
            ssh_port=$SSH_LIVE_PORT
        fi

        rsync -a -v -e "ssh -p $ssh_port" --stats --progress "$HOME/cache/_site/" "$SSH_LIVE":"$DESTINATIONPATH_LIVE"
    else
        lftp -d -c "open -u $FTP_USER_LIVE,$FTP_PASSWORD_LIVE $FTP_HOST_LIVE; set ssl:verify-certificate no; mirror -Rv '$HOME/cache/_site/' '$DESTINATIONPATH_LIVE'"
    fi
    echo "Live site deployed."

else

    # Write to a deploy-version file, named for the commit
    # and containing a timestamp.
    echo "Last commit: $commit" >> "$version_file"
    echo "Last commit by: $committer" >> "$version_file"
    echo "Deployed to staging: $timestamp" >> "$version_file"

    # Sync the built files to the staging server.
    # If it's a preview, deploy to the preview folder.
    echo "Deploying $commit by $committer to staging server..."
    if [[ $tag* =~ ^preview.*$ ]]
    then
        if [[ $DEPLOY_METHOD_PREVIEWS == 'SSH' ]]
        then

            if [[ -n $SSH_PREVIEWS_PORT ]]
            then
                ssh_port=$SSH_PREVIEWS_PORT
            fi

            rsync -a -v -e "ssh -p $ssh_port" --stats --progress "$HOME/cache/_site/" "$SSH_PREVIEWS":"$DESTINATIONPATH_PREVIEWS/$tag"
        else
            # If your server can't handle a queue of FTP commands,
            # you may need to remove `set ftp:sync-mode false;`
            lftp -d -c "open -u $FTP_USER_PREVIEWS,$FTP_PASSWORD_PREVIEWS $FTP_HOST_PREVIEWS; set ssl:verify-certificate no; set ftp:sync-mode false; mirror -Rv '$HOME/cache/_site/' '$DESTINATIONPATH_PREVIEWS/$tag'"
        fi
    else
        if [[ $DEPLOY_METHOD_STAGING == 'SSH' ]]
        then

            if [[ -n $SSH_STAGING_PORT ]]
            then
                ssh_port=$SSH_STAGING_PORT
            fi

            rsync -a -v -e "ssh -p $ssh_port" --stats --progress "$HOME/cache/_site/" "$SSH_STAGING":"$DESTINATIONPATH_STAGING"
        else
            # If your server can't handle a queue of FTP commands,
            # you may need to remove `set ftp:sync-mode false;`
            lftp -d -c "open -u $FTP_USER_STAGING,$FTP_PASSWORD_STAGING $FTP_HOST_STAGING; set ssl:verify-certificate no; set ftp:sync-mode false; mirror -Rv '$HOME/cache/_site/' '$DESTINATIONPATH_STAGING'"
        fi
    fi
    echo "Staging site deployed."

fi
