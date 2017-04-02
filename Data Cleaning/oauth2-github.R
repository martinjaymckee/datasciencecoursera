creationDate <- function (user = "jtleek", repo="datasharing") {
    require(httr)

    # 1. Find OAuth settings for github
    oauth_endpoints("github")

    # 2. Make Application
    myapp <- oauth_app( "SearchCreation",
        key = "05a214852963868d0c18",
        secret ="704363f594e5909489da5054d99fe89b072385fc" )

    # 3. Get OAuth Credentials
    github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

    # 4. Use API -- Read in the user's repo information, search for the desired repo and 
    gtoken <- config(token = github_token)
    user_path <- paste("https://api.github.com/users/", user, "/repos", sep = "")
    print(user_path)
    req <- with_config(gtoken, GET(user_path))
    stop_for_status(req)
    user_data <- content(req)
    valid_repos <- user_data[sapply(user_data, function(x){x$name == repo})]
    sapply(valid_repos, function(x){c(name = x$name, creation = x$created_at)})
}