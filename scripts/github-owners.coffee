# Description:
#   Handles updating a GitHub PR with notifying all members of OWNERS file(s).
#   file.
#
# Notes:
#   Please see https://meowni.ca/posts/chromium-owners/ for a description on
#   how OWNERS files are configured. Credit to the Chromium team for inspiration.
#
#   Thanks also to the hubot-github-repo-event-notifier for inspiration and a framework
#   to create this.

inspect = (require('util')).inspect

module.exports = (robot) ->
    robot.router.post "/hubot/github-owners", (req, res) ->
      robot.logger.debug "github-owners: Received POST to /hubot/github-owners/ with data = #{inspect req.body}"
      eventType = req.headers["x-github-event"]
      robot.logger.debug "github-owners: Processing event type: \"#{eventType}\"..."

      data = req.body

      if eventType is "pull_request"
        robot.logger.debug "Proper event type of pull_request"
      else
        console.log "Incorrect GitHub event received!"
        # TODO proper exit?
      robot.logger.debug "github-owners: Processing hash URL: #{data.pull_request.commits_url}"
      robot.logger.debug "github-owners: Number of files PR reported changed:  #{data.pull_request.changed_files}"
      robot.logger.debug "github-owners: Number of commits in PR reported:  #{data.pull_request.commits}"
      robot.logger.debug "github-owners: Processing repo:  #{data.repository.full_name}"
      robot.logger.debug "github-owners: Processing PR number:  #{data.number}"


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


