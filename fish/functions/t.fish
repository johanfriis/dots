function t --wraps=todo.sh --description 'todo.txt with default config'
  todo.sh -d ~/.config/todo/config $argv
end
