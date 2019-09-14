# bash-filename-sanitizer  
authored by: Sean Dean  
version: 2.0  

This is a simple script whose purpose is to sanitize file names within a folder.  Allowed characters are \[a-z0-9.\_-].  Uppercase letters are translated to lower case, spaces are translated to underscores, and all other characters are removed.  Excessive hyphens and underscores are reduced down to a single hyphen or underscore, and cases of sequential hyphen and underscore usage and converted into a single underscore.
