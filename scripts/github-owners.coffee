# Description:
#   Handles updating a GitHub PR with notifying all members of OWNERS file(s).
#   file.
#
# Notes:
#   Please see https://meowni.ca/posts/chromium-owners/ for a description on
#   how OWNERS files are configured. Credit to the Chromium team for
#   inspiration.
#
#   Thanks also to the hubot-github-repo-event-notifier for inspiration and
#   a framework to create this.

inspect = (require('util')).inspect
Q = require('q')


fetch_commit = (robot, commit) ->
  robot.logger.debug("github-owners: Commit sha: #{commit.sha}")
  robot.logger.debug(
    "github-owners: Fetching commit details for SHA #{commit.commit.url}")
  q = Q.defer()

  robot.http(commit.url).header('Accept', 'application/json').
  get() (err, res, body) ->
    data = JSON.parse body
    q.resolve data.files

  return q.promise
  

find_owners = (robot, src_files) ->
  # Take an array of files and return a list of owners
  # TODO refactor for file->owner dict
  Q.
  allSettled(get_owner_file(robot, src_file.raw_url) for src_file in src_files).
  then(contents) ->
    console.log('Ready to resolve')


get_owner_file = (robot, src_file) ->
  # Return an owner file if it exists
  file_split = src_file.split "/"
  file_split_dir = file_split.end(0, -1)
  owners_dir = file_split_dir.join "/"
  owners_file = owners_dir + '/OWNERS'
  robot.logger.debug("github-owners: Found owners dir: #{owners_dir}")

  # Attempt to retreive it
  q = Q.defer()
  robot.http(owners_file).header().get() (err, res, body) ->
    q.resolve body
  return q
  

route_post = (robot, data) ->
    # Handles data received from a GH hook event
  robot.http(data.pull_request.commits_url).
  header('Accept', 'application/json').get() (err, res, body) ->
    # TODO error-check
    data = JSON.parse body
    robot.logger.
    debug("github-owners: Found commits data bundle: #{inspect data}")

    Q.allSettled(fetch_commit(robot, commit) for commit in data).
    then((contents) ->
      find_owners(robot, src_file.value for src_file in contents))
        

# Main POST
module.exports = (robot) ->
  robot.router.post "/hubot/github-owners", (req, res) ->
    eventType = req.headers["x-github-event"]
    robot.logger.debug "github-owners: Processing event type: " +
    "#{eventType}\"..."

    data = req.body

    if eventType is "pull_request"
      robot.logger.debug "Proper event type of pull_request"
    else
      console.log "Incorrect GitHub event received!"
      # TODO proper exit?
    robot.logger.debug "github-owners: Processing hash URL: " +
    "#{data.pull_request.commits_url}"
    robot.logger.debug "github-owners: Number of files PR reported changed: " +
    "#{data.pull_request.changed_files}"
    robot.logger.debug "github-owners: Number of commits in PR reported:  " +
    "#{data.pull_request.commits}"
    robot.logger.debug "github-owners: Processing repo:  " +
    "#{data.repository.full_name}"
    robot.logger.debug "github-owners: Processing PR number:  #{data.number}"
      
    route_post(robot, data)

    res.end ""





        # OK, we have the data, let's start working!
       
    # Verify that this is a PR event. If not, log and skip.
    
    # Get the commit hash(s)
    
    # For each commit hash, build a list of files.

    # Discard files we have already seen.

    # Add file(s) to list of files modified by this PR
    
    # Break apart files and directories.

    # Create unique set of directories.

    # For each directory, check for an OWNERS file.

    # Download the OWNERS file and evaluate it

    # Add OWNERS to list to notify.
    
    # Construct post.

    # Post it back to the PR.
    #


