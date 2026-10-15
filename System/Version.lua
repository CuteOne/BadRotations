local _, br = ...
-- The commit this copy of BadRotations comes from, for Session.log. GitHub's "Download ZIP" (git
-- archive) fills these in (.gitattributes: export-subst). In a git clone they stay as written, and
-- the commit is read from the .git folder instead (System/SessionLog.lua).
br.build = { commit = "$Format:%H$", date = "$Format:%cs$" }
