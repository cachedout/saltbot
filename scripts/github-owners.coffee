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

found_files = []

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


      # Time to get some details about the commits
      robot.http(data.pull_request.commits_url).header('Accept', 'application/json').get() (err, res, body) ->
        # TODO error-check
        data = JSON.parse body
        robot.logger.debug("github-owners: Found commits data bundle: #{data}")
        for commit in data
          do (commit) ->
            robot.logger.debug("github-owners: Commit sha: #{commit.sha}")
            robot.logger.debug("github-owners: Fetching commit details for SHA #{commit.commit.url}")
            
            # Get the individual commit page
            robot.http(commit.url).header('Accept', 'application/json').get() (err, res, body) ->
              data = JSON.parse body
              for modified_file in data.files
                do (modified_file) ->
                  robot.logger.debug("github-owners: Located modified file: #{modified_file.filename}")
                  if modified_file.filename not in found_files
                    found_files.push modified_file.filename
              robot.logger.debug("github-owners: List query complete!")
              robot.logger.debug("github-owners: Files list: #{found_files}")
              search_dirs = []
        # OK, we have a list of files! Now, for each file find the directory
        robot.logger.debug("OK, time to look at some files")
        for found_file in found_files
         do (found_file) ->
           [search_dir, _] = found_files.split "/"
           robot.logger.debug("github-owners: search-dir #{search_dir}")
                
              
            



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


