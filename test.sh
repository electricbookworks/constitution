#!/bin/bash

# This script will build the site and run tests.
# For now, it only builds for staging and stores the site.

echo "Starting tests..."

# Uncomment lines 11-14 to unshallow your fetch,
# so that you can use lightweight tags.
# This will slow down deployment by fetching the entire repo.
# if [ -f ${HOME}/clone/.git/shallow ];
# then
#     git fetch --unshallow || true
# fi

# Get the branch name
branch=$(git symbolic-ref --short -q HEAD)

# If the branch name is not available,
# try for the environment variable for the branch name.
# CI_BRANCH is CodeShip's environment variable.
if [[ $branch = "" ]]
then
    branch=$CI_BRANCH
fi

echo "Branch: $branch"

# Get the short hash of the latest commit
commit=$(git log --pretty=format:"%h" -n 1^ 2>&1)
echo "Commit: $commit"

# Get the tag on the last commit
tag=$(git describe --tags --exact-match $commit 2>&1)
echo "Latest tag: $tag"

# Get commit author
committer=$(git show --format="%aN <%aE>" $commit)
echo "Committer: $committer"

# Get the time this script was run
timestamp=$(date +%Y-%m-%d:%H-%M-%S)
echo "Timestamp: $timestamp"

# Set the path and name for the deploy-version file
versionFile="$HOME/cache/_site/deploy-version-$commit.txt"
echo "Version file: $versionFile"

# Set the path and name for the branch-check file
branchCheckFile="$HOME/cache/_site/branch-check.txt"

# If the tag starts with 'release', then run the tests
# on the existing build.
if [[ $tag* =~ ^release.*$ ]]
then

    echo "This is tagged for release."

    # Double check that the last build was on the `live` branch,
    # so that we don't accidentally release a preview branch.
    # If the check fails, exit with an error.

    # Read the branch-check file, then check it for 'live'.
    branchCheck=$(<$branchCheckFile)
    echo "Last build was on the $branchCheck branch."

    if [[ $branchCheck != 'live' ]]
    then
        echo "Cannot deploy '$tag': last build was on '$branchCheck'."
        echo "We can only release from the 'live' branch."
        echo "Please only use 'release' tags on the 'live' branch."
        EXIT 1
    fi

    # No need for tests, we're deploying the already-tested build to live.
    # Add the release tag name and new date to the deploy-version file.
    echo "Release tag: $tag" >> "$versionFile"
    echo "Tested for live: $timestamp" >> "$versionFile"

# Otherwise, build the site.
else

    # Clear the cache of any previous builds
    # https://docs.cloudbees.com/docs/cloudbees-codeship/latest/basic-builds-and-configuration/dependency-cache#_clearing_the_cache
    # but we use a more direct approach to only delete the contents
    # of the _site folder, while avoiding the dangerous rm-rf.
    echo "Deleting previous builds from the cache..."
    find "$HOME/cache/_site" -mindepth 1 -delete

    # Check if cache is now empty
    if [ -n "$(ls -A $HOME/cache/_site)" ]; then
        echo "Warning: cache not emptied. Your site may include artefacts from previous builds."
    else
        echo "Cache is now empty."
    fi


    # Build the site
    echo "Building the site..."

    # Prevent timeouts by sending something to the terminal.
    # 300 seconds ten times is 50 minutes.
    function prevent_terminal_timeout() { ( for i in {1..100}; do echo "Preventing timeout by echoing every 300 seconds"; sleep 300; done ) & local pid=$!; trap 'kill ${pid}' SIGINT SIGTERM EXIT; }
    prevent_terminal_timeout &

    # If this has a _config.yml file, assume Jekyll and build,
    # otherwise, assume this is a static-file repo (e.g. external media)
    # and only copy the relevant files to the _site folder.
    if [ -f _config.yml ];
    then
        # If a preview, build with a preview baseurl,
        # named after the 'preview' tag, e.g. 'preview-new-feature'.
        if [[ $tag* =~ ^preview.*$ ]]
        then
            bundle exec jekyll build --baseurl="/$tag"

        # Otherwise, build the live site.
        else
            bundle exec jekyll build --config="_config.yml,_configs/_config.live.yml"
        fi
    else
        mkdir -p _site/book/images/web
        rsync -a book/images/web/ _site/book/images/web
    fi
    echo "Done building."

    # -------------------------------------------------
    # To do: add any commands that run your tests here.
    # -------------------------------------------------

    # Write to a deploy-version file, named for the commit
    # and containing a timestamp. >> appends new text.
    echo "Last commit: $commit" >> "$versionFile"
    echo "Last commit by: $committer" >> "$versionFile"
    echo "Built for staging: $timestamp" >> "$versionFile"

    # Write the name of the current branch to the branch-check file.
    # The single > replaces the file contents.
    echo "$branch" > "$branchCheckFile"

    # Save a copy of the build in the cache. See:
    # https://documentation.codeship.com/basic/builds-and-configuration/dependency-cache/#manual-caching
    echo "Copying build to cache..."
    rsync -a _site "$HOME/cache"
    echo "Copied."

fi

echo "Tests complete."
