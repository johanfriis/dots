function save --wraps='git add .; git commit -m"Save"; git pull; git push' --description 'alias save git add .; git commit -m"Save"; git pull; git push'
  git add .; git commit -m"Save"; git pull; git push $argv
        
end
