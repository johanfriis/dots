-- force markdown to be recognised as pandoc
vim.cmd [[autocmd! filetypedetect BufNewFile,BufRead *.{md,markdown,mdown,mkd,mkdn}]]
vim.cmd [[autocmd BufNewFile,BufRead,BufFilePost *.{md,markdown,mdown,mkd,mkdn} setlocal filetype=telekasten]]
