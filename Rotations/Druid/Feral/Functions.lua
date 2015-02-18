


<!DOCTYPE html>
<html lang="en" class="">
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# object: http://ogp.me/ns/object# article: http://ogp.me/ns/article# profile: http://ogp.me/ns/profile#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    
    
    <title>BadBoy/Functions.lua at 7643a84e0654371de7855b7ef5ecebde786dc39f · BadBoy-Ultimate-Raider/BadBoy</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub">
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub">
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png">
    <meta property="fb:app_id" content="1401488693436528">

      <meta content="@github" name="twitter:site" /><meta content="summary" name="twitter:card" /><meta content="BadBoy-Ultimate-Raider/BadBoy" name="twitter:title" /><meta content="BadBoy - Ultimate Raider" name="twitter:description" /><meta content="https://avatars2.githubusercontent.com/u/8353969?v=3&amp;s=400" name="twitter:image:src" />
      <meta content="GitHub" property="og:site_name" /><meta content="object" property="og:type" /><meta content="https://avatars2.githubusercontent.com/u/8353969?v=3&amp;s=400" property="og:image" /><meta content="BadBoy-Ultimate-Raider/BadBoy" property="og:title" /><meta content="https://github.com/BadBoy-Ultimate-Raider/BadBoy" property="og:url" /><meta content="BadBoy - Ultimate Raider" property="og:description" />
      <meta name="browser-stats-url" content="/_stats">
    <link rel="assets" href="https://assets-cdn.github.com/">
    <link rel="conduit-xhr" href="https://ghconduit.com:25035">
    <link rel="xhr-socket" href="/_sockets">
    <meta name="pjax-timeout" content="1000">
    <link rel="sudo-modal" href="/sessions/sudo_modal">

    <meta name="msapplication-TileImage" content="/windows-tile.png">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="selected-link" value="repo_source" data-pjax-transient>
      <meta name="google-analytics" content="UA-3769691-2">

    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="collector-cdn.github.com" name="octolytics-script-host" /><meta content="github" name="octolytics-app-id" /><meta content="688A9457:72CA:18FC7AB7:54E3ED6F" name="octolytics-dimension-request_id" /><meta content="5498251" name="octolytics-actor-id" /><meta content="CuteOne" name="octolytics-actor-login" /><meta content="ebff15aa32fd7ad16c0bd1d0b2a7bb1e8f7b6f0de9440ca081936ed646cbea0f" name="octolytics-actor-hash" />
    
    <meta content="Rails, view, blob#show" name="analytics-event" />

    
    
    <link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico">


    <meta content="authenticity_token" name="csrf-param" />
<meta content="fl4/ZXKubdJbwPoE2cC0bI0yNHc+ky9h2ZAz/8xqgAq+jwLYyBZzgUVE8jgF0fyTQf0DDJd27cL/LppDuXH2EQ==" name="csrf-token" />

    <link href="https://assets-cdn.github.com/assets/github-05d3ac147405e5932c9a353ab0c2f804a68056d6023d99e0ee4f1628b65868f1.css" media="all" rel="stylesheet" />
    <link href="https://assets-cdn.github.com/assets/github2-a34ea5f36919335b720f812ba66ac87065665d8d6d759d6f237e7129ba34edb6.css" media="all" rel="stylesheet" />
    
    


    <meta http-equiv="x-pjax-version" content="41bbae73d04477b5f25186ca6764f171">

      
  <meta name="description" content="BadBoy - Ultimate Raider">
  <meta name="go-import" content="github.com/BadBoy-Ultimate-Raider/BadBoy git https://github.com/BadBoy-Ultimate-Raider/BadBoy.git">

  <meta content="8353969" name="octolytics-dimension-user_id" /><meta content="BadBoy-Ultimate-Raider" name="octolytics-dimension-user_login" /><meta content="22612894" name="octolytics-dimension-repository_id" /><meta content="BadBoy-Ultimate-Raider/BadBoy" name="octolytics-dimension-repository_nwo" /><meta content="true" name="octolytics-dimension-repository_public" /><meta content="false" name="octolytics-dimension-repository_is_fork" /><meta content="22612894" name="octolytics-dimension-repository_network_root_id" /><meta content="BadBoy-Ultimate-Raider/BadBoy" name="octolytics-dimension-repository_network_root_nwo" />
  <link href="https://github.com/BadBoy-Ultimate-Raider/BadBoy/commits/7643a84e0654371de7855b7ef5ecebde786dc39f.atom" rel="alternate" title="Recent Commits to BadBoy:7643a84e0654371de7855b7ef5ecebde786dc39f" type="application/atom+xml">

  </head>


  <body class="logged_in  env-production windows vis-public page-blob">
    <a href="#start-of-content" tabindex="1" class="accessibility-aid js-skip-to-content">Skip to content</a>
    <div class="wrapper">
      
      
      
      


      <div class="header header-logged-in true" role="banner">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/" data-hotkey="g d" aria-label="Homepage" data-ga-click="Header, go to dashboard, icon:logo">
  <span class="mega-octicon octicon-mark-github"></span>
</a>


      <div class="site-search repo-scope js-site-search" role="search">
          <form accept-charset="UTF-8" action="/BadBoy-Ultimate-Raider/BadBoy/search" class="js-site-search-form" data-global-search-url="/search" data-repo-search-url="/BadBoy-Ultimate-Raider/BadBoy/search" method="get"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /></div>
  <input type="text"
    class="js-site-search-field is-clearable"
    data-hotkey="s"
    name="q"
    placeholder="Search"
    data-global-scope-placeholder="Search GitHub"
    data-repo-scope-placeholder="Search"
    tabindex="1"
    autocapitalize="off">
  <div class="scope-badge">This repository</div>
</form>
      </div>
      <ul class="header-nav left" role="navigation">
        <li class="header-nav-item explore">
          <a class="header-nav-link" href="/explore" data-ga-click="Header, go to explore, text:explore">Explore</a>
        </li>
          <li class="header-nav-item">
            <a class="header-nav-link" href="https://gist.github.com" data-ga-click="Header, go to gist, text:gist">Gist</a>
          </li>
          <li class="header-nav-item">
            <a class="header-nav-link" href="/blog" data-ga-click="Header, go to blog, text:blog">Blog</a>
          </li>
        <li class="header-nav-item">
          <a class="header-nav-link" href="https://help.github.com" data-ga-click="Header, go to help, text:help">Help</a>
        </li>
      </ul>

    
<ul class="header-nav user-nav right" id="user-links">
  <li class="header-nav-item dropdown js-menu-container">
    <a class="header-nav-link name" href="/CuteOne" data-ga-click="Header, go to profile, text:username">
      <img alt="ph34rt3hcute1" class="avatar" data-user="5498251" height="20" src="https://avatars0.githubusercontent.com/u/5498251?v=3&amp;s=40" width="20" />
      <span class="css-truncate">
        <span class="css-truncate-target">CuteOne</span>
      </span>
    </a>
  </li>

  <li class="header-nav-item dropdown js-menu-container">
    <a class="header-nav-link js-menu-target tooltipped tooltipped-s" href="#" aria-label="Create new..." data-ga-click="Header, create new, icon:add">
      <span class="octicon octicon-plus"></span>
      <span class="dropdown-caret"></span>
    </a>

    <div class="dropdown-menu-content js-menu-content">
      
<ul class="dropdown-menu">
  <li>
    <a href="/new" data-ga-click="Header, create new repository, icon:repo"><span class="octicon octicon-repo"></span> New repository</a>
  </li>
  <li>
    <a href="/organizations/new" data-ga-click="Header, create new organization, icon:organization"><span class="octicon octicon-organization"></span> New organization</a>
  </li>
    <li class="dropdown-divider"></li>
    <li class="dropdown-header">
      <span title="BadBoy-Ultimate-Raider">This organization</span>
    </li>

    <li>
      <a href="/orgs/BadBoy-Ultimate-Raider/invitations/new" data-ga-click="Header, invite someone, icon:person"><span class="octicon octicon-person"></span> Invite someone</a>
    </li>

    <li>
      <a href="/orgs/BadBoy-Ultimate-Raider/new-team" data-ga-click="Header, create new team, icon:jersey"><span class="octicon octicon-jersey"></span> New team</a>
    </li>

    <li>
      <a href="/organizations/BadBoy-Ultimate-Raider/repositories/new" data-ga-click="Header, create new organization repository, icon:repo"><span class="octicon octicon-repo"></span> New repository</a>
    </li>


    <li class="dropdown-divider"></li>
    <li class="dropdown-header">
      <span title="BadBoy-Ultimate-Raider/BadBoy">This repository</span>
    </li>
      <li>
        <a href="/BadBoy-Ultimate-Raider/BadBoy/issues/new" data-ga-click="Header, create new issue, icon:issue"><span class="octicon octicon-issue-opened"></span> New issue</a>
      </li>
      <li>
        <a href="/BadBoy-Ultimate-Raider/BadBoy/settings/collaboration" data-ga-click="Header, create new collaborator, icon:person"><span class="octicon octicon-person"></span> New collaborator</a>
      </li>
</ul>

    </div>
  </li>

  <li class="header-nav-item">
        <a href="/notifications" aria-label="You have no unread notifications" class="header-nav-link notification-indicator tooltipped tooltipped-s" data-ga-click="Header, go to notifications, icon:read" data-hotkey="g n">
        <span class="mail-status all-read"></span>
        <span class="octicon octicon-inbox"></span>
</a>
  </li>

  <li class="header-nav-item">
    <a class="header-nav-link tooltipped tooltipped-s" href="/settings/profile" id="account_settings" aria-label="Settings" data-ga-click="Header, go to settings, icon:settings">
      <span class="octicon octicon-gear"></span>
    </a>
  </li>

  <li class="header-nav-item">
    <form accept-charset="UTF-8" action="/logout" class="logout-form" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="f4Ngxr7deaUQezE356rxjJ4Mh/BFhpXPtT9hbgK9Kstue8sLhSTAOQdwkP8ajgts6Jk0zSsqMdb0ly6A6AO3sA==" /></div>
      <button class="header-nav-link sign-out-button tooltipped tooltipped-s" aria-label="Sign out" data-ga-click="Header, sign out, icon:logout">
        <span class="octicon octicon-sign-out"></span>
      </button>
</form>  </li>

</ul>


    
  </div>
</div>

      

        


      <div id="start-of-content" class="accessibility-aid"></div>
          <div class="site" itemscope itemtype="http://schema.org/WebPage">
    <div id="js-flash-container">
      
    </div>
    <div class="pagehead repohead instapaper_ignore readability-menu">
      <div class="container">
        
<ul class="pagehead-actions">

  <li>
      <form accept-charset="UTF-8" action="/notifications/subscribe" class="js-social-container" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="0pLsKufkc4wjArg64OOdKGL009KQrc9C4qaKLB97ZWt68GdLvrfWFGxu6SvVYJsLKEv+w5HuZlU/eCDCIWHb6Q==" /></div>    <input id="repository_id" name="repository_id" type="hidden" value="22612894" />

      <div class="select-menu js-menu-container js-select-menu">
        <a class="social-count js-social-count" href="/BadBoy-Ultimate-Raider/BadBoy/watchers">
          12
        </a>
        <a href="/BadBoy-Ultimate-Raider/BadBoy/subscription"
          class="minibutton select-menu-button with-count js-menu-target" role="button" tabindex="0" aria-haspopup="true">
          <span class="js-select-button">
            <span class="octicon octicon-eye"></span>
            Unwatch
          </span>
        </a>

        <div class="select-menu-modal-holder">
          <div class="select-menu-modal subscription-menu-modal js-menu-content" aria-hidden="true">
            <div class="select-menu-header">
              <span class="select-menu-title">Notifications</span>
              <span class="octicon octicon-x js-menu-close" role="button" aria-label="Close"></span>
            </div>

            <div class="select-menu-list js-navigation-container" role="menu">

              <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
                <span class="select-menu-item-icon octicon octicon-check"></span>
                <div class="select-menu-item-text">
                  <input id="do_included" name="do" type="radio" value="included" />
                  <span class="select-menu-item-heading">Not watching</span>
                  <span class="description">Be notified when participating or @mentioned.</span>
                  <span class="js-select-button-text hidden-select-button-text">
                    <span class="octicon octicon-eye"></span>
                    Watch
                  </span>
                </div>
              </div>

              <div class="select-menu-item js-navigation-item selected" role="menuitem" tabindex="0">
                <span class="select-menu-item-icon octicon octicon octicon-check"></span>
                <div class="select-menu-item-text">
                  <input checked="checked" id="do_subscribed" name="do" type="radio" value="subscribed" />
                  <span class="select-menu-item-heading">Watching</span>
                  <span class="description">Be notified of all conversations.</span>
                  <span class="js-select-button-text hidden-select-button-text">
                    <span class="octicon octicon-eye"></span>
                    Unwatch
                  </span>
                </div>
              </div>

              <div class="select-menu-item js-navigation-item " role="menuitem" tabindex="0">
                <span class="select-menu-item-icon octicon octicon-check"></span>
                <div class="select-menu-item-text">
                  <input id="do_ignore" name="do" type="radio" value="ignore" />
                  <span class="select-menu-item-heading">Ignoring</span>
                  <span class="description">Never be notified.</span>
                  <span class="js-select-button-text hidden-select-button-text">
                    <span class="octicon octicon-mute"></span>
                    Stop ignoring
                  </span>
                </div>
              </div>

            </div>

          </div>
        </div>
      </div>
</form>

  </li>

  <li>
    
  <div class="js-toggler-container js-social-container starring-container ">

    <form accept-charset="UTF-8" action="/BadBoy-Ultimate-Raider/BadBoy/unstar" class="js-toggler-form starred js-unstar-button" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="G42kfyxvnyCnRJTU7YywpecGamDP5v84CxXAxOwf5TUuD5fNYK504o3nUs0gPSyZ2pllCYEBzDY9MhBEx8CTXQ==" /></div>
      <button
        class="minibutton with-count js-toggler-target"
        aria-label="Unstar this repository" title="Unstar BadBoy-Ultimate-Raider/BadBoy">
        <span class="octicon octicon-star"></span>
        Unstar
      </button>
        <a class="social-count js-social-count" href="/BadBoy-Ultimate-Raider/BadBoy/stargazers">
          20
        </a>
</form>
    <form accept-charset="UTF-8" action="/BadBoy-Ultimate-Raider/BadBoy/star" class="js-toggler-form unstarred js-star-button" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="TbLE1Z/Gz9HMkuJKaklpN0hpMTjtwngF3GhhqZE/YMi6eqEjqnCxKQ92zIKX1gv0PNPphj64dbjb3uq2QXRf6g==" /></div>
      <button
        class="minibutton with-count js-toggler-target"
        aria-label="Star this repository" title="Star BadBoy-Ultimate-Raider/BadBoy">
        <span class="octicon octicon-star"></span>
        Star
      </button>
        <a class="social-count js-social-count" href="/BadBoy-Ultimate-Raider/BadBoy/stargazers">
          20
        </a>
</form>  </div>

  </li>

        <li>
          <a href="/BadBoy-Ultimate-Raider/BadBoy/fork" class="minibutton with-count js-toggler-target tooltipped-n" title="Fork your own copy of BadBoy-Ultimate-Raider/BadBoy to your account" aria-label="Fork your own copy of BadBoy-Ultimate-Raider/BadBoy to your account" rel="facebox nofollow">
            <span class="octicon octicon-repo-forked"></span>
            Fork
          </a>
          <a href="/BadBoy-Ultimate-Raider/BadBoy/network" class="social-count">15</a>
        </li>

</ul>

        <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
          <span class="mega-octicon octicon-repo"></span>
          <span class="author"><a href="/BadBoy-Ultimate-Raider" class="url fn" itemprop="url" rel="author"><span itemprop="title">BadBoy-Ultimate-Raider</span></a></span><!--
       --><span class="path-divider">/</span><!--
       --><strong><a href="/BadBoy-Ultimate-Raider/BadBoy" class="js-current-repository" data-pjax="#js-repo-pjax-container">BadBoy</a></strong>

          <span class="page-context-loader">
            <img alt="" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
          </span>

        </h1>
      </div><!-- /.container -->
    </div><!-- /.repohead -->

    <div class="container">
      <div class="repository-with-sidebar repo-container new-discussion-timeline  ">
        <div class="repository-sidebar clearfix">
            
<nav class="sunken-menu repo-nav js-repo-nav js-sidenav-container-pjax js-octicon-loaders"
     role="navigation"
     data-pjax="#js-repo-pjax-container"
     data-issue-count-url="/BadBoy-Ultimate-Raider/BadBoy/issues/counts">
  <ul class="sunken-menu-group">
    <li class="tooltipped tooltipped-w" aria-label="Code">
      <a href="/BadBoy-Ultimate-Raider/BadBoy" aria-label="Code" class="selected js-selected-navigation-item sunken-menu-item" data-hotkey="g c" data-selected-links="repo_source repo_downloads repo_commits repo_releases repo_tags repo_branches /BadBoy-Ultimate-Raider/BadBoy">
        <span class="octicon octicon-code"></span> <span class="full-word">Code</span>
        <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>    </li>

      <li class="tooltipped tooltipped-w" aria-label="Issues">
        <a href="/BadBoy-Ultimate-Raider/BadBoy/issues" aria-label="Issues" class="js-selected-navigation-item sunken-menu-item" data-hotkey="g i" data-selected-links="repo_issues repo_labels repo_milestones /BadBoy-Ultimate-Raider/BadBoy/issues">
          <span class="octicon octicon-issue-opened"></span> <span class="full-word">Issues</span>
          <span class="js-issue-replace-counter"></span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>      </li>

    <li class="tooltipped tooltipped-w" aria-label="Pull Requests">
      <a href="/BadBoy-Ultimate-Raider/BadBoy/pulls" aria-label="Pull Requests" class="js-selected-navigation-item sunken-menu-item" data-hotkey="g p" data-selected-links="repo_pulls /BadBoy-Ultimate-Raider/BadBoy/pulls">
          <span class="octicon octicon-git-pull-request"></span> <span class="full-word">Pull Requests</span>
          <span class="js-pull-replace-counter"></span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>    </li>


      <li class="tooltipped tooltipped-w" aria-label="Wiki">
        <a href="/BadBoy-Ultimate-Raider/BadBoy/wiki" aria-label="Wiki" class="js-selected-navigation-item sunken-menu-item" data-hotkey="g w" data-selected-links="repo_wiki /BadBoy-Ultimate-Raider/BadBoy/wiki">
          <span class="octicon octicon-book"></span> <span class="full-word">Wiki</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>      </li>
  </ul>
  <div class="sunken-menu-separator"></div>
  <ul class="sunken-menu-group">

    <li class="tooltipped tooltipped-w" aria-label="Pulse">
      <a href="/BadBoy-Ultimate-Raider/BadBoy/pulse" aria-label="Pulse" class="js-selected-navigation-item sunken-menu-item" data-selected-links="pulse /BadBoy-Ultimate-Raider/BadBoy/pulse">
        <span class="octicon octicon-pulse"></span> <span class="full-word">Pulse</span>
        <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>    </li>

    <li class="tooltipped tooltipped-w" aria-label="Graphs">
      <a href="/BadBoy-Ultimate-Raider/BadBoy/graphs" aria-label="Graphs" class="js-selected-navigation-item sunken-menu-item" data-selected-links="repo_graphs repo_contributors /BadBoy-Ultimate-Raider/BadBoy/graphs">
        <span class="octicon octicon-graph"></span> <span class="full-word">Graphs</span>
        <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>    </li>
  </ul>


    <div class="sunken-menu-separator"></div>
    <ul class="sunken-menu-group">
      <li class="tooltipped tooltipped-w" aria-label="Settings">
        <a href="/BadBoy-Ultimate-Raider/BadBoy/settings" aria-label="Settings" class="js-selected-navigation-item sunken-menu-item" data-selected-links="repo_settings /BadBoy-Ultimate-Raider/BadBoy/settings">
          <span class="octicon octicon-tools"></span> <span class="full-word">Settings</span>
          <img alt="" class="mini-loader" height="16" src="https://assets-cdn.github.com/assets/spinners/octocat-spinner-32-e513294efa576953719e4e2de888dd9cf929b7d62ed8d05f25e731d02452ab6c.gif" width="16" />
</a>      </li>
    </ul>
</nav>

              <div class="only-with-full-nav">
                  
<div class="clone-url open"
  data-protocol-type="http"
  data-url="/users/set_protocol?protocol_selector=http&amp;protocol_type=clone">
  <h3><span class="text-emphasized">HTTPS</span> clone URL</h3>
  <div class="input-group js-zeroclipboard-container">
    <input type="text" class="input-mini input-monospace js-url-field js-zeroclipboard-target"
           value="https://github.com/BadBoy-Ultimate-Raider/BadBoy.git" readonly="readonly">
    <span class="input-group-button">
      <button aria-label="Copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>

  
<div class="clone-url "
  data-protocol-type="ssh"
  data-url="/users/set_protocol?protocol_selector=ssh&amp;protocol_type=clone">
  <h3><span class="text-emphasized">SSH</span> clone URL</h3>
  <div class="input-group js-zeroclipboard-container">
    <input type="text" class="input-mini input-monospace js-url-field js-zeroclipboard-target"
           value="git@github.com:BadBoy-Ultimate-Raider/BadBoy.git" readonly="readonly">
    <span class="input-group-button">
      <button aria-label="Copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>

  
<div class="clone-url "
  data-protocol-type="subversion"
  data-url="/users/set_protocol?protocol_selector=subversion&amp;protocol_type=clone">
  <h3><span class="text-emphasized">Subversion</span> checkout URL</h3>
  <div class="input-group js-zeroclipboard-container">
    <input type="text" class="input-mini input-monospace js-url-field js-zeroclipboard-target"
           value="https://github.com/BadBoy-Ultimate-Raider/BadBoy" readonly="readonly">
    <span class="input-group-button">
      <button aria-label="Copy to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
    </span>
  </div>
</div>



<p class="clone-options">You can clone with
  <a href="#" class="js-clone-selector" data-protocol="http">HTTPS</a>, <a href="#" class="js-clone-selector" data-protocol="ssh">SSH</a>, or <a href="#" class="js-clone-selector" data-protocol="subversion">Subversion</a>.
  <a href="https://help.github.com/articles/which-remote-url-should-i-use" class="help tooltipped tooltipped-n" aria-label="Get help on which URL is right for you.">
    <span class="octicon octicon-question"></span>
  </a>
</p>


  <a href="github-windows://openRepo/https://github.com/BadBoy-Ultimate-Raider/BadBoy" class="minibutton sidebar-button" title="Save BadBoy-Ultimate-Raider/BadBoy to your computer and use it in GitHub Desktop." aria-label="Save BadBoy-Ultimate-Raider/BadBoy to your computer and use it in GitHub Desktop.">
    <span class="octicon octicon-device-desktop"></span>
    Clone in Desktop
  </a>

                <a href="/BadBoy-Ultimate-Raider/BadBoy/archive/7643a84e0654371de7855b7ef5ecebde786dc39f.zip"
                   class="minibutton sidebar-button"
                   aria-label="Download the contents of BadBoy-Ultimate-Raider/BadBoy as a zip file"
                   title="Download the contents of BadBoy-Ultimate-Raider/BadBoy as a zip file"
                   rel="nofollow">
                  <span class="octicon octicon-cloud-download"></span>
                  Download ZIP
                </a>
              </div>
        </div><!-- /.repository-sidebar -->

        <div id="js-repo-pjax-container" class="repository-content context-loader-container" data-pjax-container>
          

<a href="/BadBoy-Ultimate-Raider/BadBoy/blob/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral/Functions.lua" class="hidden js-permalink-shortcut" data-hotkey="y">Permalink</a>

<!-- blob contrib key: blob_contributors:v21:f59b1809d0d0b0a3fc72382600db2914 -->

<div class="file-navigation js-zeroclipboard-container">
  
<div class="select-menu js-menu-container js-select-menu left">
  <span class="minibutton select-menu-button js-menu-target css-truncate" data-hotkey="w"
    data-master-branch="master"
    data-ref=""
    title=""
    role="button" aria-label="Switch branches or tags" tabindex="0" aria-haspopup="true">
    <span class="octicon octicon-git-branch"></span>
    <i>tree:</i>
    <span class="js-select-button css-truncate-target">7643a84e06</span>
  </span>

  <div class="select-menu-modal-holder js-menu-content js-navigation-container" data-pjax aria-hidden="true">

    <div class="select-menu-modal">
      <div class="select-menu-header">
        <span class="select-menu-title">Switch branches/tags</span>
        <span class="octicon octicon-x js-menu-close" role="button" aria-label="Close"></span>
      </div>

      <div class="select-menu-filters">
        <div class="select-menu-text-filter">
          <input type="text" aria-label="Find or create a branch…" id="context-commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Find or create a branch…">
        </div>
        <div class="select-menu-tabs">
          <ul>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="branches" data-filter-placeholder="Find or create a branch…" class="js-select-menu-tab">Branches</a>
            </li>
            <li class="select-menu-tab">
              <a href="#" data-tab-filter="tags" data-filter-placeholder="Find a tag…" class="js-select-menu-tab">Tags</a>
            </li>
          </ul>
        </div>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="branches">

        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


            <a class="select-menu-item js-navigation-item js-navigation-open "
               href="/BadBoy-Ultimate-Raider/BadBoy/blob/1nter2013/Rotations/Druid/Feral/Functions.lua"
               data-name="1nter2013"
               data-skip-pjax="true"
               rel="nofollow">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <span class="select-menu-item-text css-truncate-target" title="1nter2013">
                1nter2013
              </span>
            </a>
            <a class="select-menu-item js-navigation-item js-navigation-open "
               href="/BadBoy-Ultimate-Raider/BadBoy/blob/master/Rotations/Druid/Feral/Functions.lua"
               data-name="master"
               data-skip-pjax="true"
               rel="nofollow">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <span class="select-menu-item-text css-truncate-target" title="master">
                master
              </span>
            </a>
        </div>

          <form accept-charset="UTF-8" action="/BadBoy-Ultimate-Raider/BadBoy/branches" class="js-create-branch select-menu-item select-menu-new-item-form js-navigation-item js-new-item-form" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="wGMOAVzZQbbEvP6TlqOj+qNGRfkC9Jz40BSjEgKdWbCd56rS1XKH6fKeCQ/gGspWuISUFqDpOWx9QcVI+1H4EA==" /></div>
            <span class="octicon octicon-git-branch select-menu-item-icon"></span>
            <div class="select-menu-item-text">
              <span class="select-menu-item-heading">Create branch: <span class="js-new-item-name"></span></span>
              <span class="description">from ‘7643a84’</span>
            </div>
            <input type="hidden" name="name" id="name" class="js-new-item-value">
            <input type="hidden" name="branch" id="branch" value="7643a84e0654371de7855b7ef5ecebde786dc39f">
            <input type="hidden" name="path" id="path" value="Rotations/Druid/Feral/Functions.lua">
</form>
      </div>

      <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket" data-tab-filter="tags">
        <div data-filterable-for="context-commitish-filter-field" data-filterable-type="substring">


        </div>

        <div class="select-menu-no-results">Nothing to show</div>
      </div>

    </div>
  </div>
</div>

  <div class="button-group right">
    <a href="/BadBoy-Ultimate-Raider/BadBoy/find/7643a84e0654371de7855b7ef5ecebde786dc39f"
          class="js-show-file-finder minibutton empty-icon tooltipped tooltipped-s"
          data-pjax
          data-hotkey="t"
          aria-label="Quickly jump between files">
      <span class="octicon octicon-list-unordered"></span>
    </a>
    <button aria-label="Copy file path to clipboard" class="js-zeroclipboard minibutton zeroclipboard-button" data-copied-hint="Copied!" type="button"><span class="octicon octicon-clippy"></span></button>
  </div>

  <div class="breadcrumb js-zeroclipboard-target">
    <span class='repo-root js-repo-root'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/BadBoy-Ultimate-Raider/BadBoy/tree/7643a84e0654371de7855b7ef5ecebde786dc39f" class="" data-branch="7643a84e0654371de7855b7ef5ecebde786dc39f" data-direction="back" data-pjax="true" itemscope="url" rel="nofollow"><span itemprop="title">BadBoy</span></a></span></span><span class="separator">/</span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/BadBoy-Ultimate-Raider/BadBoy/tree/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations" class="" data-branch="7643a84e0654371de7855b7ef5ecebde786dc39f" data-direction="back" data-pjax="true" itemscope="url" rel="nofollow"><span itemprop="title">Rotations</span></a></span><span class="separator">/</span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/BadBoy-Ultimate-Raider/BadBoy/tree/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid" class="" data-branch="7643a84e0654371de7855b7ef5ecebde786dc39f" data-direction="back" data-pjax="true" itemscope="url" rel="nofollow"><span itemprop="title">Druid</span></a></span><span class="separator">/</span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/BadBoy-Ultimate-Raider/BadBoy/tree/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral" class="" data-branch="7643a84e0654371de7855b7ef5ecebde786dc39f" data-direction="back" data-pjax="true" itemscope="url" rel="nofollow"><span itemprop="title">Feral</span></a></span><span class="separator">/</span><strong class="final-path">Functions.lua</strong>
  </div>
</div>


  <div class="commit file-history-tease">
    <div class="file-history-tease-header">
        <img alt="ph34rt3hcute1" class="avatar" data-user="5498251" height="24" src="https://avatars2.githubusercontent.com/u/5498251?v=3&amp;s=48" width="24" />
        <span class="author"><a href="/CuteOne" rel="contributor">CuteOne</a></span>
        <time datetime="2015-02-10T22:54:19Z" is="relative-time">Feb 10, 2015</time>
        <div class="commit-title">
            <a href="/BadBoy-Ultimate-Raider/BadBoy/commit/7643a84e0654371de7855b7ef5ecebde786dc39f" class="message" data-pjax="true" title="Feral Update">Feral Update</a>
        </div>
    </div>

    <div class="participation">
      <p class="quickstat">
        <a href="#blob_contributors_box" rel="facebox">
          <strong>2</strong>
           contributors
        </a>
      </p>
          <a class="avatar-link tooltipped tooltipped-s" aria-label="CuteOne" href="/BadBoy-Ultimate-Raider/BadBoy/commits/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral/Functions.lua?author=CuteOne"><img alt="ph34rt3hcute1" class="avatar" data-user="5498251" height="20" src="https://avatars0.githubusercontent.com/u/5498251?v=3&amp;s=40" width="20" /></a>
    <a class="avatar-link tooltipped tooltipped-s" aria-label="averykey" href="/BadBoy-Ultimate-Raider/BadBoy/commits/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral/Functions.lua?author=averykey"><img alt="averykey" class="avatar" data-user="8989695" height="20" src="https://avatars0.githubusercontent.com/u/8989695?v=3&amp;s=40" width="20" /></a>


    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2 class="facebox-header">Users who have contributed to this file</h2>
      <ul class="facebox-user-list">
          <li class="facebox-user-list-item">
            <img alt="ph34rt3hcute1" data-user="5498251" height="24" src="https://avatars2.githubusercontent.com/u/5498251?v=3&amp;s=48" width="24" />
            <a href="/CuteOne">CuteOne</a>
          </li>
          <li class="facebox-user-list-item">
            <img alt="averykey" data-user="8989695" height="24" src="https://avatars2.githubusercontent.com/u/8989695?v=3&amp;s=48" width="24" />
            <a href="/averykey">averykey</a>
          </li>
      </ul>
    </div>
  </div>

<div class="file">
  <div class="file-header">
    <div class="file-info">
        225 lines (202 sloc)
        <span class="file-info-divider"></span>
      6.7 kb
    </div>
    <div class="file-actions">
      <div class="button-group">
        <a href="/BadBoy-Ultimate-Raider/BadBoy/raw/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral/Functions.lua" class="minibutton " id="raw-url">Raw</a>
          <a href="/BadBoy-Ultimate-Raider/BadBoy/blame/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral/Functions.lua" class="minibutton js-update-url-with-hash">Blame</a>
        <a href="/BadBoy-Ultimate-Raider/BadBoy/commits/7643a84e0654371de7855b7ef5ecebde786dc39f/Rotations/Druid/Feral/Functions.lua" class="minibutton " rel="nofollow">History</a>
      </div><!-- /.button-group -->


          <a class="octicon-button disabled tooltipped tooltipped-w" href="#"
             aria-label="You must be on a branch to make or propose changes to this file"><span class="octicon octicon-pencil"></span></a>

        <a class="octicon-button danger disabled tooltipped tooltipped-w" href="#"
           aria-label="You must be on a branch to make or propose changes to this file">
        <span class="octicon octicon-trashcan"></span>
      </a>
    </div><!-- /.actions -->
  </div>
  

  <div class="blob-wrapper data type-lua">
      <table class="highlight tab-size-8 js-file-line-container">
      <tr>
        <td id="L1" class="blob-num js-line-number" data-line-number="1"></td>
        <td id="LC1" class="blob-code js-file-line"><span class="pl-k">if</span> <span class="pl-s3">select</span>(<span class="pl-c1">3</span>, <span class="pl-s3">UnitClass</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>)) <span class="pl-k">==</span> <span class="pl-c1">11</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L2" class="blob-num js-line-number" data-line-number="2"></td>
        <td id="LC2" class="blob-code js-file-line">    </td>
      </tr>
      <tr>
        <td id="L3" class="blob-num js-line-number" data-line-number="3"></td>
        <td id="LC3" class="blob-code js-file-line">    <span class="pl-c">------Member Check------</span></td>
      </tr>
      <tr>
        <td id="L4" class="blob-num js-line-number" data-line-number="4"></td>
        <td id="LC4" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">CalculateHP</span>(<span class="pl-vpf">unit</span>)</td>
      </tr>
      <tr>
        <td id="L5" class="blob-num js-line-number" data-line-number="5"></td>
        <td id="LC5" class="blob-code js-file-line">      incomingheals <span class="pl-k">=</span> <span class="pl-s3">UnitGetIncomingHeals</span>(unit) <span class="pl-k">or</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L6" class="blob-num js-line-number" data-line-number="6"></td>
        <td id="LC6" class="blob-code js-file-line">      <span class="pl-k">return</span> <span class="pl-c1">100</span> <span class="pl-k">*</span> ( <span class="pl-s3">UnitHealth</span>(unit) <span class="pl-k">+</span> incomingheals ) <span class="pl-k">/</span> <span class="pl-s3">UnitHealthMax</span>(unit)</td>
      </tr>
      <tr>
        <td id="L7" class="blob-num js-line-number" data-line-number="7"></td>
        <td id="LC7" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L8" class="blob-num js-line-number" data-line-number="8"></td>
        <td id="LC8" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L9" class="blob-num js-line-number" data-line-number="9"></td>
        <td id="LC9" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">GroupInfo</span>()</td>
      </tr>
      <tr>
        <td id="L10" class="blob-num js-line-number" data-line-number="10"></td>
        <td id="LC10" class="blob-code js-file-line">        members, group <span class="pl-k">=</span> { { Unit <span class="pl-k">=</span> <span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>, HP <span class="pl-k">=</span> <span class="pl-s3">CalculateHP</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>) } }, { low <span class="pl-k">=</span> <span class="pl-c1">0</span>, tanks <span class="pl-k">=</span> { } }</td>
      </tr>
      <tr>
        <td id="L11" class="blob-num js-line-number" data-line-number="11"></td>
        <td id="LC11" class="blob-code js-file-line">        group.<span class="pl-vo">type</span> <span class="pl-k">=</span> <span class="pl-s3">IsInRaid</span>() <span class="pl-k">and</span> <span class="pl-s1"><span class="pl-pds">&quot;</span>raid<span class="pl-pds">&quot;</span></span> <span class="pl-k">or</span> <span class="pl-s1"><span class="pl-pds">&quot;</span>party<span class="pl-pds">&quot;</span></span></td>
      </tr>
      <tr>
        <td id="L12" class="blob-num js-line-number" data-line-number="12"></td>
        <td id="LC12" class="blob-code js-file-line">        group.<span class="pl-vo">number</span> <span class="pl-k">=</span> <span class="pl-s3">GetNumGroupMembers</span>()</td>
      </tr>
      <tr>
        <td id="L13" class="blob-num js-line-number" data-line-number="13"></td>
        <td id="LC13" class="blob-code js-file-line">        <span class="pl-k">if</span> group.<span class="pl-vo">number</span> <span class="pl-k">&gt;</span> <span class="pl-c1">0</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L14" class="blob-num js-line-number" data-line-number="14"></td>
        <td id="LC14" class="blob-code js-file-line">            <span class="pl-k">for</span> i<span class="pl-k">=</span><span class="pl-c1">1</span>,group.<span class="pl-vo">number</span> <span class="pl-k">do</span></td>
      </tr>
      <tr>
        <td id="L15" class="blob-num js-line-number" data-line-number="15"></td>
        <td id="LC15" class="blob-code js-file-line">                <span class="pl-k">if</span> <span class="pl-s3">canHeal</span>(group.<span class="pl-vo">type</span><span class="pl-k">..</span>i) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L16" class="blob-num js-line-number" data-line-number="16"></td>
        <td id="LC16" class="blob-code js-file-line">                    <span class="pl-k">local</span> unit, hp <span class="pl-k">=</span> group.<span class="pl-vo">type</span><span class="pl-k">..</span>i, <span class="pl-s3">CalculateHP</span>(group.<span class="pl-vo">type</span><span class="pl-k">..</span>i)</td>
      </tr>
      <tr>
        <td id="L17" class="blob-num js-line-number" data-line-number="17"></td>
        <td id="LC17" class="blob-code js-file-line">                    members[<span class="pl-k">#</span>members<span class="pl-k">+</span><span class="pl-c1">1</span>] <span class="pl-k">=</span> { Unit <span class="pl-k">=</span> unit, HP <span class="pl-k">=</span> hp }</td>
      </tr>
      <tr>
        <td id="L18" class="blob-num js-line-number" data-line-number="18"></td>
        <td id="LC18" class="blob-code js-file-line">                    <span class="pl-k">if</span> hp <span class="pl-k">&lt;</span> <span class="pl-c1">90</span> <span class="pl-k">then</span> group.<span class="pl-vo">low</span> <span class="pl-k">=</span> group.<span class="pl-vo">low</span> <span class="pl-k">+</span> <span class="pl-c1">1</span> <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L19" class="blob-num js-line-number" data-line-number="19"></td>
        <td id="LC19" class="blob-code js-file-line">                    <span class="pl-k">if</span> <span class="pl-s3">UnitGroupRolesAssigned</span>(unit) <span class="pl-k">==</span> <span class="pl-s1"><span class="pl-pds">&quot;</span>TANK<span class="pl-pds">&quot;</span></span> <span class="pl-k">then</span> <span class="pl-s3">table.insert</span>(group.<span class="pl-vo">tanks</span>,unit) <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L20" class="blob-num js-line-number" data-line-number="20"></td>
        <td id="LC20" class="blob-code js-file-line">                <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L21" class="blob-num js-line-number" data-line-number="21"></td>
        <td id="LC21" class="blob-code js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L22" class="blob-num js-line-number" data-line-number="22"></td>
        <td id="LC22" class="blob-code js-file-line">            <span class="pl-k">if</span> group.<span class="pl-vo">type</span> <span class="pl-k">==</span> <span class="pl-s1"><span class="pl-pds">&quot;</span>raid<span class="pl-pds">&quot;</span></span> <span class="pl-k">and</span> <span class="pl-k">#</span>members <span class="pl-k">&gt;</span> <span class="pl-c1">1</span> <span class="pl-k">then</span> <span class="pl-s3">table.remove</span>(members,<span class="pl-c1">1</span>) <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L23" class="blob-num js-line-number" data-line-number="23"></td>
        <td id="LC23" class="blob-code js-file-line">            <span class="pl-s3">table.sort</span>(members, <span class="pl-k">function</span>(<span class="pl-vpf">x,y</span>) <span class="pl-k">return</span> x.<span class="pl-vo">HP</span> <span class="pl-k">&lt;</span> y.<span class="pl-vo">HP</span> <span class="pl-k">end</span>)</td>
      </tr>
      <tr>
        <td id="L24" class="blob-num js-line-number" data-line-number="24"></td>
        <td id="LC24" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L25" class="blob-num js-line-number" data-line-number="25"></td>
        <td id="LC25" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L26" class="blob-num js-line-number" data-line-number="26"></td>
        <td id="LC26" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L27" class="blob-num js-line-number" data-line-number="27"></td>
        <td id="LC27" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">WA_calcStats_feral</span>()</td>
      </tr>
      <tr>
        <td id="L28" class="blob-num js-line-number" data-line-number="28"></td>
        <td id="LC28" class="blob-code js-file-line">        <span class="pl-k">local</span> DamageMult <span class="pl-k">=</span> <span class="pl-c1">1</span></td>
      </tr>
      <tr>
        <td id="L29" class="blob-num js-line-number" data-line-number="29"></td>
        <td id="LC29" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L30" class="blob-num js-line-number" data-line-number="30"></td>
        <td id="LC30" class="blob-code js-file-line">        <span class="pl-k">local</span> CP <span class="pl-k">=</span> <span class="pl-s3">GetComboPoints</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>, <span class="pl-s3">dynamicTarget</span>(<span class="pl-c1">5</span>,<span class="pl-c1">true</span>))</td>
      </tr>
      <tr>
        <td id="L31" class="blob-num js-line-number" data-line-number="31"></td>
        <td id="LC31" class="blob-code js-file-line">        <span class="pl-k">if</span> CP <span class="pl-k">==</span> <span class="pl-c1">0</span> <span class="pl-k">then</span> CP <span class="pl-k">=</span> <span class="pl-c1">5</span> <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L32" class="blob-num js-line-number" data-line-number="32"></td>
        <td id="LC32" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L33" class="blob-num js-line-number" data-line-number="33"></td>
        <td id="LC33" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-s3">UnitBuffID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,tf) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L34" class="blob-num js-line-number" data-line-number="34"></td>
        <td id="LC34" class="blob-code js-file-line">            DamageMult <span class="pl-k">=</span> DamageMult <span class="pl-k">*</span> <span class="pl-c1">1.15</span></td>
      </tr>
      <tr>
        <td id="L35" class="blob-num js-line-number" data-line-number="35"></td>
        <td id="LC35" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L36" class="blob-num js-line-number" data-line-number="36"></td>
        <td id="LC36" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L37" class="blob-num js-line-number" data-line-number="37"></td>
        <td id="LC37" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-s3">UnitBuffID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,svr) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L38" class="blob-num js-line-number" data-line-number="38"></td>
        <td id="LC38" class="blob-code js-file-line">            DamageMult <span class="pl-k">=</span> DamageMult <span class="pl-k">*</span> <span class="pl-c1">1.4</span></td>
      </tr>
      <tr>
        <td id="L39" class="blob-num js-line-number" data-line-number="39"></td>
        <td id="LC39" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L40" class="blob-num js-line-number" data-line-number="40"></td>
        <td id="LC40" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L41" class="blob-num js-line-number" data-line-number="41"></td>
        <td id="LC41" class="blob-code js-file-line">        WA_stats_BTactive <span class="pl-k">=</span> WA_stats_BTactive <span class="pl-k">or</span>  <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L42" class="blob-num js-line-number" data-line-number="42"></td>
        <td id="LC42" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-s3">UnitBuffID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,bt) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L43" class="blob-num js-line-number" data-line-number="43"></td>
        <td id="LC43" class="blob-code js-file-line">            WA_stats_BTactive <span class="pl-k">=</span> <span class="pl-s3">GetTime</span>()</td>
      </tr>
      <tr>
        <td id="L44" class="blob-num js-line-number" data-line-number="44"></td>
        <td id="LC44" class="blob-code js-file-line">            DamageMult <span class="pl-k">=</span> DamageMult <span class="pl-k">*</span> <span class="pl-c1">1.3</span></td>
      </tr>
      <tr>
        <td id="L45" class="blob-num js-line-number" data-line-number="45"></td>
        <td id="LC45" class="blob-code js-file-line">        <span class="pl-k">elseif</span> <span class="pl-s3">GetTime</span>() <span class="pl-k">-</span> WA_stats_BTactive <span class="pl-k">&lt;</span> <span class="pl-c1">.2</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L46" class="blob-num js-line-number" data-line-number="46"></td>
        <td id="LC46" class="blob-code js-file-line">            DamageMult <span class="pl-k">=</span> DamageMult <span class="pl-k">*</span> <span class="pl-c1">1.3</span></td>
      </tr>
      <tr>
        <td id="L47" class="blob-num js-line-number" data-line-number="47"></td>
        <td id="LC47" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L48" class="blob-num js-line-number" data-line-number="48"></td>
        <td id="LC48" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L49" class="blob-num js-line-number" data-line-number="49"></td>
        <td id="LC49" class="blob-code js-file-line">        <span class="pl-k">local</span> RakeMult <span class="pl-k">=</span> <span class="pl-c1">1</span></td>
      </tr>
      <tr>
        <td id="L50" class="blob-num js-line-number" data-line-number="50"></td>
        <td id="LC50" class="blob-code js-file-line">        WA_stats_prowlactive <span class="pl-k">=</span> WA_stats_prowlactive <span class="pl-k">or</span>  <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L51" class="blob-num js-line-number" data-line-number="51"></td>
        <td id="LC51" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-s3">UnitBuffID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,inc) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L52" class="blob-num js-line-number" data-line-number="52"></td>
        <td id="LC52" class="blob-code js-file-line">            RakeMult <span class="pl-k">=</span> <span class="pl-c1">2</span></td>
      </tr>
      <tr>
        <td id="L53" class="blob-num js-line-number" data-line-number="53"></td>
        <td id="LC53" class="blob-code js-file-line">        <span class="pl-k">elseif</span> <span class="pl-s3">UnitBuffID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,prl) <span class="pl-k">or</span> <span class="pl-s3">UnitBuffID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,sm) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L54" class="blob-num js-line-number" data-line-number="54"></td>
        <td id="LC54" class="blob-code js-file-line">            WA_stats_prowlactive <span class="pl-k">=</span> <span class="pl-s3">GetTime</span>()</td>
      </tr>
      <tr>
        <td id="L55" class="blob-num js-line-number" data-line-number="55"></td>
        <td id="LC55" class="blob-code js-file-line">            RakeMult <span class="pl-k">=</span> <span class="pl-c1">2</span></td>
      </tr>
      <tr>
        <td id="L56" class="blob-num js-line-number" data-line-number="56"></td>
        <td id="LC56" class="blob-code js-file-line">        <span class="pl-k">elseif</span> <span class="pl-s3">GetTime</span>() <span class="pl-k">-</span> WA_stats_prowlactive <span class="pl-k">&lt;</span> <span class="pl-c1">.2</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L57" class="blob-num js-line-number" data-line-number="57"></td>
        <td id="LC57" class="blob-code js-file-line">            RakeMult <span class="pl-k">=</span> <span class="pl-c1">2</span></td>
      </tr>
      <tr>
        <td id="L58" class="blob-num js-line-number" data-line-number="58"></td>
        <td id="LC58" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L59" class="blob-num js-line-number" data-line-number="59"></td>
        <td id="LC59" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L60" class="blob-num js-line-number" data-line-number="60"></td>
        <td id="LC60" class="blob-code js-file-line">        WA_stats_RipTick <span class="pl-k">=</span> CP<span class="pl-k">*</span>DamageMult</td>
      </tr>
      <tr>
        <td id="L61" class="blob-num js-line-number" data-line-number="61"></td>
        <td id="LC61" class="blob-code js-file-line">        WA_stats_RipTick5 <span class="pl-k">=</span> <span class="pl-c1">5</span><span class="pl-k">*</span>DamageMult</td>
      </tr>
      <tr>
        <td id="L62" class="blob-num js-line-number" data-line-number="62"></td>
        <td id="LC62" class="blob-code js-file-line">        WA_stats_RakeTick <span class="pl-k">=</span> DamageMult<span class="pl-k">*</span>RakeMult</td>
      </tr>
      <tr>
        <td id="L63" class="blob-num js-line-number" data-line-number="63"></td>
        <td id="LC63" class="blob-code js-file-line">        WA_stats_ThrashTick <span class="pl-k">=</span> DamageMult</td>
      </tr>
      <tr>
        <td id="L64" class="blob-num js-line-number" data-line-number="64"></td>
        <td id="LC64" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L65" class="blob-num js-line-number" data-line-number="65"></td>
        <td id="LC65" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L66" class="blob-num js-line-number" data-line-number="66"></td>
        <td id="LC66" class="blob-code js-file-line">    <span class="pl-c">--Calculated Rake Dot Damage</span></td>
      </tr>
      <tr>
        <td id="L67" class="blob-num js-line-number" data-line-number="67"></td>
        <td id="LC67" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">CRKD</span>()</td>
      </tr>
      <tr>
        <td id="L68" class="blob-num js-line-number" data-line-number="68"></td>
        <td id="LC68" class="blob-code js-file-line">        <span class="pl-s3">WA_calcStats_feral</span>()</td>
      </tr>
      <tr>
        <td id="L69" class="blob-num js-line-number" data-line-number="69"></td>
        <td id="LC69" class="blob-code js-file-line">        <span class="pl-k">local</span> calcRake <span class="pl-k">=</span> WA_stats_RakeTick</td>
      </tr>
      <tr>
        <td id="L70" class="blob-num js-line-number" data-line-number="70"></td>
        <td id="LC70" class="blob-code js-file-line">        <span class="pl-k">return</span> calcRake</td>
      </tr>
      <tr>
        <td id="L71" class="blob-num js-line-number" data-line-number="71"></td>
        <td id="LC71" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L72" class="blob-num js-line-number" data-line-number="72"></td>
        <td id="LC72" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L73" class="blob-num js-line-number" data-line-number="73"></td>
        <td id="LC73" class="blob-code js-file-line">    <span class="pl-c">--Applied Rake Dot Damage</span></td>
      </tr>
      <tr>
        <td id="L74" class="blob-num js-line-number" data-line-number="74"></td>
        <td id="LC74" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">RKD</span>(<span class="pl-vpf">unit</span>)</td>
      </tr>
      <tr>
        <td id="L75" class="blob-num js-line-number" data-line-number="75"></td>
        <td id="LC75" class="blob-code js-file-line">        <span class="pl-k">if</span> Rake_sDamage<span class="pl-k">==</span><span class="pl-c1">nil</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L76" class="blob-num js-line-number" data-line-number="76"></td>
        <td id="LC76" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">0.5</span></td>
      </tr>
      <tr>
        <td id="L77" class="blob-num js-line-number" data-line-number="77"></td>
        <td id="LC77" class="blob-code js-file-line">        <span class="pl-k">elseif</span> <span class="pl-s3">ObjectExists</span>(unit) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L78" class="blob-num js-line-number" data-line-number="78"></td>
        <td id="LC78" class="blob-code js-file-line">            <span class="pl-k">if</span> <span class="pl-s3">getDebuffRemain</span>(unit,rk,<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>)<span class="pl-k">==</span><span class="pl-c1">0</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L79" class="blob-num js-line-number" data-line-number="79"></td>
        <td id="LC79" class="blob-code js-file-line">                rakeDot <span class="pl-k">=</span> <span class="pl-c1">0.5</span></td>
      </tr>
      <tr>
        <td id="L80" class="blob-num js-line-number" data-line-number="80"></td>
        <td id="LC80" class="blob-code js-file-line">            <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L81" class="blob-num js-line-number" data-line-number="81"></td>
        <td id="LC81" class="blob-code js-file-line">                rakeDot <span class="pl-k">=</span> Rake_sDamage[<span class="pl-s3">UnitGUID</span>(unit)]</td>
      </tr>
      <tr>
        <td id="L82" class="blob-num js-line-number" data-line-number="82"></td>
        <td id="LC82" class="blob-code js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L83" class="blob-num js-line-number" data-line-number="83"></td>
        <td id="LC83" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L84" class="blob-num js-line-number" data-line-number="84"></td>
        <td id="LC84" class="blob-code js-file-line">        <span class="pl-k">if</span> rakeDot<span class="pl-k">~=</span><span class="pl-c1">nil</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L85" class="blob-num js-line-number" data-line-number="85"></td>
        <td id="LC85" class="blob-code js-file-line">            <span class="pl-k">return</span> rakeDot</td>
      </tr>
      <tr>
        <td id="L86" class="blob-num js-line-number" data-line-number="86"></td>
        <td id="LC86" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L87" class="blob-num js-line-number" data-line-number="87"></td>
        <td id="LC87" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">0.5</span></td>
      </tr>
      <tr>
        <td id="L88" class="blob-num js-line-number" data-line-number="88"></td>
        <td id="LC88" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L89" class="blob-num js-line-number" data-line-number="89"></td>
        <td id="LC89" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L90" class="blob-num js-line-number" data-line-number="90"></td>
        <td id="LC90" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L91" class="blob-num js-line-number" data-line-number="91"></td>
        <td id="LC91" class="blob-code js-file-line">    <span class="pl-c">--Rake Dot Damage Percent</span></td>
      </tr>
      <tr>
        <td id="L92" class="blob-num js-line-number" data-line-number="92"></td>
        <td id="LC92" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">RKP</span>(<span class="pl-vpf">unit</span>)</td>
      </tr>
      <tr>
        <td id="L93" class="blob-num js-line-number" data-line-number="93"></td>
        <td id="LC93" class="blob-code js-file-line">        <span class="pl-k">local</span> RatioPercent <span class="pl-k">=</span> <span class="pl-s3">floor</span>(<span class="pl-s3">CRKD</span>()<span class="pl-k">/</span><span class="pl-s3">RKD</span>(unit)<span class="pl-k">*</span><span class="pl-c1">100</span><span class="pl-k">+</span><span class="pl-c1">0.5</span>)</td>
      </tr>
      <tr>
        <td id="L94" class="blob-num js-line-number" data-line-number="94"></td>
        <td id="LC94" class="blob-code js-file-line">        <span class="pl-k">return</span> RatioPercent</td>
      </tr>
      <tr>
        <td id="L95" class="blob-num js-line-number" data-line-number="95"></td>
        <td id="LC95" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L96" class="blob-num js-line-number" data-line-number="96"></td>
        <td id="LC96" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L97" class="blob-num js-line-number" data-line-number="97"></td>
        <td id="LC97" class="blob-code js-file-line">    <span class="pl-c">--Calculated Rip Dot Damage</span></td>
      </tr>
      <tr>
        <td id="L98" class="blob-num js-line-number" data-line-number="98"></td>
        <td id="LC98" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">CRPD</span>()</td>
      </tr>
      <tr>
        <td id="L99" class="blob-num js-line-number" data-line-number="99"></td>
        <td id="LC99" class="blob-code js-file-line">        <span class="pl-s3">WA_calcStats_feral</span>()</td>
      </tr>
      <tr>
        <td id="L100" class="blob-num js-line-number" data-line-number="100"></td>
        <td id="LC100" class="blob-code js-file-line">        <span class="pl-k">local</span> calcRip <span class="pl-k">=</span> WA_stats_RipTick5</td>
      </tr>
      <tr>
        <td id="L101" class="blob-num js-line-number" data-line-number="101"></td>
        <td id="LC101" class="blob-code js-file-line">        <span class="pl-k">return</span> calcRip</td>
      </tr>
      <tr>
        <td id="L102" class="blob-num js-line-number" data-line-number="102"></td>
        <td id="LC102" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L103" class="blob-num js-line-number" data-line-number="103"></td>
        <td id="LC103" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L104" class="blob-num js-line-number" data-line-number="104"></td>
        <td id="LC104" class="blob-code js-file-line">    <span class="pl-c">--Applied Rip Dot Damage</span></td>
      </tr>
      <tr>
        <td id="L105" class="blob-num js-line-number" data-line-number="105"></td>
        <td id="LC105" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">RPD</span>(<span class="pl-vpf">unit</span>)</td>
      </tr>
      <tr>
        <td id="L106" class="blob-num js-line-number" data-line-number="106"></td>
        <td id="LC106" class="blob-code js-file-line">        <span class="pl-k">if</span> Rip_sDamage<span class="pl-k">==</span><span class="pl-c1">nil</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L107" class="blob-num js-line-number" data-line-number="107"></td>
        <td id="LC107" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">0.5</span></td>
      </tr>
      <tr>
        <td id="L108" class="blob-num js-line-number" data-line-number="108"></td>
        <td id="LC108" class="blob-code js-file-line">        <span class="pl-k">elseif</span> <span class="pl-s3">ObjectExists</span>(unit) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L109" class="blob-num js-line-number" data-line-number="109"></td>
        <td id="LC109" class="blob-code js-file-line">            <span class="pl-k">if</span> <span class="pl-s3">getDebuffRemain</span>(unit,rp,<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>)<span class="pl-k">==</span><span class="pl-c1">0</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L110" class="blob-num js-line-number" data-line-number="110"></td>
        <td id="LC110" class="blob-code js-file-line">                ripDot <span class="pl-k">=</span> <span class="pl-c1">0.5</span></td>
      </tr>
      <tr>
        <td id="L111" class="blob-num js-line-number" data-line-number="111"></td>
        <td id="LC111" class="blob-code js-file-line">            <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L112" class="blob-num js-line-number" data-line-number="112"></td>
        <td id="LC112" class="blob-code js-file-line">                ripDot <span class="pl-k">=</span> Rip_sDamage[<span class="pl-s3">UnitGUID</span>(unit)]</td>
      </tr>
      <tr>
        <td id="L113" class="blob-num js-line-number" data-line-number="113"></td>
        <td id="LC113" class="blob-code js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L114" class="blob-num js-line-number" data-line-number="114"></td>
        <td id="LC114" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L115" class="blob-num js-line-number" data-line-number="115"></td>
        <td id="LC115" class="blob-code js-file-line">        <span class="pl-k">if</span> ripDot<span class="pl-k">~=</span><span class="pl-c1">nil</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L116" class="blob-num js-line-number" data-line-number="116"></td>
        <td id="LC116" class="blob-code js-file-line">            <span class="pl-k">return</span> ripDot</td>
      </tr>
      <tr>
        <td id="L117" class="blob-num js-line-number" data-line-number="117"></td>
        <td id="LC117" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L118" class="blob-num js-line-number" data-line-number="118"></td>
        <td id="LC118" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">0.5</span></td>
      </tr>
      <tr>
        <td id="L119" class="blob-num js-line-number" data-line-number="119"></td>
        <td id="LC119" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L120" class="blob-num js-line-number" data-line-number="120"></td>
        <td id="LC120" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L121" class="blob-num js-line-number" data-line-number="121"></td>
        <td id="LC121" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L122" class="blob-num js-line-number" data-line-number="122"></td>
        <td id="LC122" class="blob-code js-file-line">    <span class="pl-c">--Rip Dot Damage Percent</span></td>
      </tr>
      <tr>
        <td id="L123" class="blob-num js-line-number" data-line-number="123"></td>
        <td id="LC123" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">RPP</span>()</td>
      </tr>
      <tr>
        <td id="L124" class="blob-num js-line-number" data-line-number="124"></td>
        <td id="LC124" class="blob-code js-file-line">        <span class="pl-k">local</span> RatioPercent <span class="pl-k">=</span> <span class="pl-s3">floor</span>(<span class="pl-s3">CRPD</span>()<span class="pl-k">/</span><span class="pl-s3">RPD</span>(unit)<span class="pl-k">*</span><span class="pl-c1">100</span><span class="pl-k">+</span><span class="pl-c1">0.5</span>)</td>
      </tr>
      <tr>
        <td id="L125" class="blob-num js-line-number" data-line-number="125"></td>
        <td id="LC125" class="blob-code js-file-line">        <span class="pl-k">return</span> RatioPercent</td>
      </tr>
      <tr>
        <td id="L126" class="blob-num js-line-number" data-line-number="126"></td>
        <td id="LC126" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L127" class="blob-num js-line-number" data-line-number="127"></td>
        <td id="LC127" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L128" class="blob-num js-line-number" data-line-number="128"></td>
        <td id="LC128" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">useCDs</span>()</td>
      </tr>
      <tr>
        <td id="L129" class="blob-num js-line-number" data-line-number="129"></td>
        <td id="LC129" class="blob-code js-file-line">        <span class="pl-k">if</span> (BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>Cooldowns<span class="pl-pds">&#39;</span></span>] <span class="pl-k">==</span> <span class="pl-c1">1</span> <span class="pl-k">and</span> <span class="pl-s3">isBoss</span>()) <span class="pl-k">or</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>Cooldowns<span class="pl-pds">&#39;</span></span>] <span class="pl-k">==</span> <span class="pl-c1">2</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L130" class="blob-num js-line-number" data-line-number="130"></td>
        <td id="LC130" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L131" class="blob-num js-line-number" data-line-number="131"></td>
        <td id="LC131" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L132" class="blob-num js-line-number" data-line-number="132"></td>
        <td id="LC132" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L133" class="blob-num js-line-number" data-line-number="133"></td>
        <td id="LC133" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L134" class="blob-num js-line-number" data-line-number="134"></td>
        <td id="LC134" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L135" class="blob-num js-line-number" data-line-number="135"></td>
        <td id="LC135" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L136" class="blob-num js-line-number" data-line-number="136"></td>
        <td id="LC136" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">useAoE</span>()</td>
      </tr>
      <tr>
        <td id="L137" class="blob-num js-line-number" data-line-number="137"></td>
        <td id="LC137" class="blob-code js-file-line">        <span class="pl-k">if</span> (BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>AoE<span class="pl-pds">&#39;</span></span>] <span class="pl-k">==</span> <span class="pl-c1">1</span> <span class="pl-k">and</span> <span class="pl-k">#</span><span class="pl-s3">getEnemies</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>,<span class="pl-c1">8</span>) <span class="pl-k">&gt;=</span> <span class="pl-c1">3</span>) <span class="pl-k">or</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>AoE<span class="pl-pds">&#39;</span></span>] <span class="pl-k">==</span> <span class="pl-c1">2</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L138" class="blob-num js-line-number" data-line-number="138"></td>
        <td id="LC138" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L139" class="blob-num js-line-number" data-line-number="139"></td>
        <td id="LC139" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L140" class="blob-num js-line-number" data-line-number="140"></td>
        <td id="LC140" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L141" class="blob-num js-line-number" data-line-number="141"></td>
        <td id="LC141" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L142" class="blob-num js-line-number" data-line-number="142"></td>
        <td id="LC142" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L143" class="blob-num js-line-number" data-line-number="143"></td>
        <td id="LC143" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L144" class="blob-num js-line-number" data-line-number="144"></td>
        <td id="LC144" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">useDefensive</span>()</td>
      </tr>
      <tr>
        <td id="L145" class="blob-num js-line-number" data-line-number="145"></td>
        <td id="LC145" class="blob-code js-file-line">        <span class="pl-k">if</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>Defensive<span class="pl-pds">&#39;</span></span>] <span class="pl-k">==</span> <span class="pl-c1">1</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L146" class="blob-num js-line-number" data-line-number="146"></td>
        <td id="LC146" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L147" class="blob-num js-line-number" data-line-number="147"></td>
        <td id="LC147" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L148" class="blob-num js-line-number" data-line-number="148"></td>
        <td id="LC148" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L149" class="blob-num js-line-number" data-line-number="149"></td>
        <td id="LC149" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L150" class="blob-num js-line-number" data-line-number="150"></td>
        <td id="LC150" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L151" class="blob-num js-line-number" data-line-number="151"></td>
        <td id="LC151" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L152" class="blob-num js-line-number" data-line-number="152"></td>
        <td id="LC152" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">useInterrupts</span>()</td>
      </tr>
      <tr>
        <td id="L153" class="blob-num js-line-number" data-line-number="153"></td>
        <td id="LC153" class="blob-code js-file-line">        <span class="pl-k">if</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>Interrupts<span class="pl-pds">&#39;</span></span>] <span class="pl-k">==</span> <span class="pl-c1">1</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L154" class="blob-num js-line-number" data-line-number="154"></td>
        <td id="LC154" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L155" class="blob-num js-line-number" data-line-number="155"></td>
        <td id="LC155" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L156" class="blob-num js-line-number" data-line-number="156"></td>
        <td id="LC156" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L157" class="blob-num js-line-number" data-line-number="157"></td>
        <td id="LC157" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L158" class="blob-num js-line-number" data-line-number="158"></td>
        <td id="LC158" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L159" class="blob-num js-line-number" data-line-number="159"></td>
        <td id="LC159" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L160" class="blob-num js-line-number" data-line-number="160"></td>
        <td id="LC160" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">useCleave</span>()</td>
      </tr>
      <tr>
        <td id="L161" class="blob-num js-line-number" data-line-number="161"></td>
        <td id="LC161" class="blob-code js-file-line">        <span class="pl-k">if</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>Cleave<span class="pl-pds">&#39;</span></span>]<span class="pl-k">==</span><span class="pl-c1">1</span> <span class="pl-k">and</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>AoE<span class="pl-pds">&#39;</span></span>] <span class="pl-k">~=</span> <span class="pl-c1">3</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L162" class="blob-num js-line-number" data-line-number="162"></td>
        <td id="LC162" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L163" class="blob-num js-line-number" data-line-number="163"></td>
        <td id="LC163" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L164" class="blob-num js-line-number" data-line-number="164"></td>
        <td id="LC164" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L165" class="blob-num js-line-number" data-line-number="165"></td>
        <td id="LC165" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L166" class="blob-num js-line-number" data-line-number="166"></td>
        <td id="LC166" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L167" class="blob-num js-line-number" data-line-number="167"></td>
        <td id="LC167" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L168" class="blob-num js-line-number" data-line-number="168"></td>
        <td id="LC168" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">useProwl</span>()</td>
      </tr>
      <tr>
        <td id="L169" class="blob-num js-line-number" data-line-number="169"></td>
        <td id="LC169" class="blob-code js-file-line">        <span class="pl-k">if</span> BadBoy_data[<span class="pl-s1"><span class="pl-pds">&#39;</span>Prowl<span class="pl-pds">&#39;</span></span>]<span class="pl-k">==</span><span class="pl-c1">1</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L170" class="blob-num js-line-number" data-line-number="170"></td>
        <td id="LC170" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L171" class="blob-num js-line-number" data-line-number="171"></td>
        <td id="LC171" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L172" class="blob-num js-line-number" data-line-number="172"></td>
        <td id="LC172" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L173" class="blob-num js-line-number" data-line-number="173"></td>
        <td id="LC173" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L174" class="blob-num js-line-number" data-line-number="174"></td>
        <td id="LC174" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L175" class="blob-num js-line-number" data-line-number="175"></td>
        <td id="LC175" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L176" class="blob-num js-line-number" data-line-number="176"></td>
        <td id="LC176" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">outOfWater</span>()</td>
      </tr>
      <tr>
        <td id="L177" class="blob-num js-line-number" data-line-number="177"></td>
        <td id="LC177" class="blob-code js-file-line">        <span class="pl-k">if</span> swimTime <span class="pl-k">==</span> <span class="pl-c1">nil</span> <span class="pl-k">then</span> swimTime <span class="pl-k">=</span> <span class="pl-c1">0</span> <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L178" class="blob-num js-line-number" data-line-number="178"></td>
        <td id="LC178" class="blob-code js-file-line">        <span class="pl-k">if</span> outTime <span class="pl-k">==</span> <span class="pl-c1">nil</span> <span class="pl-k">then</span> outTime <span class="pl-k">=</span> <span class="pl-c1">0</span> <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L179" class="blob-num js-line-number" data-line-number="179"></td>
        <td id="LC179" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-s3">IsSwimming</span>() <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L180" class="blob-num js-line-number" data-line-number="180"></td>
        <td id="LC180" class="blob-code js-file-line">            swimTime <span class="pl-k">=</span> <span class="pl-s3">GetTime</span>()</td>
      </tr>
      <tr>
        <td id="L181" class="blob-num js-line-number" data-line-number="181"></td>
        <td id="LC181" class="blob-code js-file-line">            outTime <span class="pl-k">=</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L182" class="blob-num js-line-number" data-line-number="182"></td>
        <td id="LC182" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L183" class="blob-num js-line-number" data-line-number="183"></td>
        <td id="LC183" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-k">not</span> <span class="pl-s3">IsSwimming</span>() <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L184" class="blob-num js-line-number" data-line-number="184"></td>
        <td id="LC184" class="blob-code js-file-line">            outTime <span class="pl-k">=</span> swimTime</td>
      </tr>
      <tr>
        <td id="L185" class="blob-num js-line-number" data-line-number="185"></td>
        <td id="LC185" class="blob-code js-file-line">            swimTime <span class="pl-k">=</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L186" class="blob-num js-line-number" data-line-number="186"></td>
        <td id="LC186" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L187" class="blob-num js-line-number" data-line-number="187"></td>
        <td id="LC187" class="blob-code js-file-line">        <span class="pl-k">if</span> outTime <span class="pl-k">~=</span> <span class="pl-c1">0</span> <span class="pl-k">and</span> swimTime <span class="pl-k">==</span> <span class="pl-c1">0</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L188" class="blob-num js-line-number" data-line-number="188"></td>
        <td id="LC188" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">true</span></td>
      </tr>
      <tr>
        <td id="L189" class="blob-num js-line-number" data-line-number="189"></td>
        <td id="LC189" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L190" class="blob-num js-line-number" data-line-number="190"></td>
        <td id="LC190" class="blob-code js-file-line">        <span class="pl-k">if</span> outTime <span class="pl-k">~=</span> <span class="pl-c1">0</span> <span class="pl-k">and</span> <span class="pl-s3">IsFlying</span>() <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L191" class="blob-num js-line-number" data-line-number="191"></td>
        <td id="LC191" class="blob-code js-file-line">            outTime <span class="pl-k">=</span> <span class="pl-c1">0</span></td>
      </tr>
      <tr>
        <td id="L192" class="blob-num js-line-number" data-line-number="192"></td>
        <td id="LC192" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">false</span></td>
      </tr>
      <tr>
        <td id="L193" class="blob-num js-line-number" data-line-number="193"></td>
        <td id="LC193" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L194" class="blob-num js-line-number" data-line-number="194"></td>
        <td id="LC194" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L195" class="blob-num js-line-number" data-line-number="195"></td>
        <td id="LC195" class="blob-code js-file-line">
</td>
      </tr>
      <tr>
        <td id="L196" class="blob-num js-line-number" data-line-number="196"></td>
        <td id="LC196" class="blob-code js-file-line">    <span class="pl-k">function</span> <span class="pl-en">getDistance2</span>(<span class="pl-vpf">Unit1,Unit2</span>)</td>
      </tr>
      <tr>
        <td id="L197" class="blob-num js-line-number" data-line-number="197"></td>
        <td id="LC197" class="blob-code js-file-line">        <span class="pl-k">if</span> Unit2 <span class="pl-k">==</span> <span class="pl-c1">nil</span> <span class="pl-k">then</span> Unit2 <span class="pl-k">=</span> <span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>; <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L198" class="blob-num js-line-number" data-line-number="198"></td>
        <td id="LC198" class="blob-code js-file-line">        <span class="pl-k">if</span> <span class="pl-s3">ObjectExists</span>(Unit1) <span class="pl-k">and</span> <span class="pl-s3">ObjectExists</span>(Unit2) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L199" class="blob-num js-line-number" data-line-number="199"></td>
        <td id="LC199" class="blob-code js-file-line">            <span class="pl-k">local</span> X1,Y1,Z1 <span class="pl-k">=</span> <span class="pl-s3">ObjectPosition</span>(Unit1);</td>
      </tr>
      <tr>
        <td id="L200" class="blob-num js-line-number" data-line-number="200"></td>
        <td id="LC200" class="blob-code js-file-line">            <span class="pl-k">local</span> X2,Y2,Z2 <span class="pl-k">=</span> <span class="pl-s3">ObjectPosition</span>(Unit2);</td>
      </tr>
      <tr>
        <td id="L201" class="blob-num js-line-number" data-line-number="201"></td>
        <td id="LC201" class="blob-code js-file-line">            <span class="pl-k">local</span> unitSize <span class="pl-k">=</span> <span class="pl-c1">0</span>;</td>
      </tr>
      <tr>
        <td id="L202" class="blob-num js-line-number" data-line-number="202"></td>
        <td id="LC202" class="blob-code js-file-line">            <span class="pl-k">if</span> <span class="pl-s3">UnitGUID</span>(Unit1) <span class="pl-k">~=</span> <span class="pl-s3">UnitGUID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>) <span class="pl-k">and</span> <span class="pl-s3">UnitCanAttack</span>(Unit1,<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L203" class="blob-num js-line-number" data-line-number="203"></td>
        <td id="LC203" class="blob-code js-file-line">                unitSize <span class="pl-k">=</span> <span class="pl-s3">UnitCombatReach</span>(Unit1);</td>
      </tr>
      <tr>
        <td id="L204" class="blob-num js-line-number" data-line-number="204"></td>
        <td id="LC204" class="blob-code js-file-line">            <span class="pl-k">elseif</span> <span class="pl-s3">UnitGUID</span>(Unit2) <span class="pl-k">~=</span> <span class="pl-s3">UnitGUID</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>) <span class="pl-k">and</span> <span class="pl-s3">UnitCanAttack</span>(Unit2,<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L205" class="blob-num js-line-number" data-line-number="205"></td>
        <td id="LC205" class="blob-code js-file-line">                unitSize <span class="pl-k">=</span> <span class="pl-s3">UnitCombatReach</span>(Unit2);</td>
      </tr>
      <tr>
        <td id="L206" class="blob-num js-line-number" data-line-number="206"></td>
        <td id="LC206" class="blob-code js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L207" class="blob-num js-line-number" data-line-number="207"></td>
        <td id="LC207" class="blob-code js-file-line">            <span class="pl-k">local</span> distance <span class="pl-k">=</span> <span class="pl-s3">math.sqrt</span>(((X2<span class="pl-k">-</span>X1)<span class="pl-k">^</span><span class="pl-c1">2</span>)<span class="pl-k">+</span>((Y2<span class="pl-k">-</span>Y1)<span class="pl-k">^</span><span class="pl-c1">2</span>))</td>
      </tr>
      <tr>
        <td id="L208" class="blob-num js-line-number" data-line-number="208"></td>
        <td id="LC208" class="blob-code js-file-line">            <span class="pl-k">if</span> distance <span class="pl-k">&lt;</span> <span class="pl-s3">max</span>(<span class="pl-c1">5</span>, <span class="pl-s3">UnitCombatReach</span>(Unit1) <span class="pl-k">+</span> <span class="pl-s3">UnitCombatReach</span>(Unit2) <span class="pl-k">+</span> <span class="pl-c1">4</span><span class="pl-k">/</span><span class="pl-c1">3</span>) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L209" class="blob-num js-line-number" data-line-number="209"></td>
        <td id="LC209" class="blob-code js-file-line">                <span class="pl-k">return</span> <span class="pl-c1">4.9999</span></td>
      </tr>
      <tr>
        <td id="L210" class="blob-num js-line-number" data-line-number="210"></td>
        <td id="LC210" class="blob-code js-file-line">            <span class="pl-k">elseif</span> distance <span class="pl-k">&lt;</span> <span class="pl-s3">max</span>(<span class="pl-c1">8</span>, <span class="pl-s3">UnitCombatReach</span>(Unit1) <span class="pl-k">+</span> <span class="pl-s3">UnitCombatReach</span>(Unit2) <span class="pl-k">+</span> <span class="pl-c1">6.5</span>) <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L211" class="blob-num js-line-number" data-line-number="211"></td>
        <td id="LC211" class="blob-code js-file-line">                <span class="pl-k">if</span> distance<span class="pl-k">-</span>unitSize <span class="pl-k">&lt;=</span> <span class="pl-c1">5</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L212" class="blob-num js-line-number" data-line-number="212"></td>
        <td id="LC212" class="blob-code js-file-line">                    <span class="pl-k">return</span> <span class="pl-c1">5</span></td>
      </tr>
      <tr>
        <td id="L213" class="blob-num js-line-number" data-line-number="213"></td>
        <td id="LC213" class="blob-code js-file-line">                <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L214" class="blob-num js-line-number" data-line-number="214"></td>
        <td id="LC214" class="blob-code js-file-line">                    <span class="pl-k">return</span> distance<span class="pl-k">-</span>unitSize</td>
      </tr>
      <tr>
        <td id="L215" class="blob-num js-line-number" data-line-number="215"></td>
        <td id="LC215" class="blob-code js-file-line">                <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L216" class="blob-num js-line-number" data-line-number="216"></td>
        <td id="LC216" class="blob-code js-file-line">            <span class="pl-k">elseif</span> distance<span class="pl-k">-</span>(unitSize<span class="pl-k">+</span><span class="pl-s3">UnitCombatReach</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>)) <span class="pl-k">&lt;=</span> <span class="pl-c1">8</span> <span class="pl-k">then</span></td>
      </tr>
      <tr>
        <td id="L217" class="blob-num js-line-number" data-line-number="217"></td>
        <td id="LC217" class="blob-code js-file-line">                <span class="pl-k">return</span> <span class="pl-c1">8</span></td>
      </tr>
      <tr>
        <td id="L218" class="blob-num js-line-number" data-line-number="218"></td>
        <td id="LC218" class="blob-code js-file-line">            <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L219" class="blob-num js-line-number" data-line-number="219"></td>
        <td id="LC219" class="blob-code js-file-line">                <span class="pl-k">return</span> distance<span class="pl-k">-</span>(unitSize<span class="pl-k">+</span><span class="pl-s3">UnitCombatReach</span>(<span class="pl-s1"><span class="pl-pds">&quot;</span>player<span class="pl-pds">&quot;</span></span>))</td>
      </tr>
      <tr>
        <td id="L220" class="blob-num js-line-number" data-line-number="220"></td>
        <td id="LC220" class="blob-code js-file-line">            <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L221" class="blob-num js-line-number" data-line-number="221"></td>
        <td id="LC221" class="blob-code js-file-line">        <span class="pl-k">else</span></td>
      </tr>
      <tr>
        <td id="L222" class="blob-num js-line-number" data-line-number="222"></td>
        <td id="LC222" class="blob-code js-file-line">            <span class="pl-k">return</span> <span class="pl-c1">1000</span>;</td>
      </tr>
      <tr>
        <td id="L223" class="blob-num js-line-number" data-line-number="223"></td>
        <td id="LC223" class="blob-code js-file-line">        <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L224" class="blob-num js-line-number" data-line-number="224"></td>
        <td id="LC224" class="blob-code js-file-line">    <span class="pl-k">end</span></td>
      </tr>
      <tr>
        <td id="L225" class="blob-num js-line-number" data-line-number="225"></td>
        <td id="LC225" class="blob-code js-file-line"><span class="pl-k">end</span></td>
      </tr>
</table>

  </div>

</div>

<a href="#jump-to-line" rel="facebox[.linejump]" data-hotkey="l" style="display:none">Jump to Line</a>
<div id="jump-to-line" style="display:none">
  <form accept-charset="UTF-8" class="js-jump-to-line-form">
    <input class="linejump-input js-jump-to-line-field" type="text" placeholder="Jump to line&hellip;" autofocus>
    <button type="submit" class="button">Go</button>
  </form>
</div>

        </div>

      </div><!-- /.repo-container -->
      <div class="modal-backdrop"></div>
    </div><!-- /.container -->
  </div><!-- /.site -->


    </div><!-- /.wrapper -->

      <div class="container">
  <div class="site-footer" role="contentinfo">
    <ul class="site-footer-links right">
        <li><a href="https://status.github.com/" data-ga-click="Footer, go to status, text:status">Status</a></li>
      <li><a href="https://developer.github.com" data-ga-click="Footer, go to api, text:api">API</a></li>
      <li><a href="http://training.github.com" data-ga-click="Footer, go to training, text:training">Training</a></li>
      <li><a href="http://shop.github.com" data-ga-click="Footer, go to shop, text:shop">Shop</a></li>
        <li><a href="/blog" data-ga-click="Footer, go to blog, text:blog">Blog</a></li>
        <li><a href="/about" data-ga-click="Footer, go to about, text:about">About</a></li>

    </ul>

    <a href="/" aria-label="Homepage">
      <span class="mega-octicon octicon-mark-github" title="GitHub"></span>
    </a>

    <ul class="site-footer-links">
      <li>&copy; 2015 <span title="0.05022s from github-fe131-cp1-prd.iad.github.net">GitHub</span>, Inc.</li>
        <li><a href="/site/terms" data-ga-click="Footer, go to terms, text:terms">Terms</a></li>
        <li><a href="/site/privacy" data-ga-click="Footer, go to privacy, text:privacy">Privacy</a></li>
        <li><a href="/security" data-ga-click="Footer, go to security, text:security">Security</a></li>
        <li><a href="/contact" data-ga-click="Footer, go to contact, text:contact">Contact</a></li>
    </ul>
  </div>
</div>


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-suggester-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="fullscreen-contents js-fullscreen-contents" placeholder=""></textarea>
      <div class="suggester-container">
        <div class="suggester fullscreen-suggester js-suggester js-navigation-container"></div>
      </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped tooltipped-w" aria-label="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped tooltipped-w"
      aria-label="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    

    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      <a href="#" class="octicon octicon-x flash-close js-ajax-error-dismiss" aria-label="Dismiss error"></a>
      Something went wrong with that request. Please try again.
    </div>


      <script crossorigin="anonymous" src="https://assets-cdn.github.com/assets/frameworks-996268c2962f947579cb9ec2908bd576591bc94b6a2db184a78e78815022ba2c.js"></script>
      <script async="async" crossorigin="anonymous" src="https://assets-cdn.github.com/assets/github-cb53450ca7fbb94ef24a0fca46d90a0391d607a777966419fba0dc5f85a3649d.js"></script>
      
      

  </body>
</html>

