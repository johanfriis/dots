
" Wiki links [[text]]
syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends
syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends
syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal

" A nice little mini language for logging
" Inspired by the following article:
" https://peppe.rs/posts/plain_text_journaling/
ab note: ☰
ab meet: ◉
ab work: ≻

syn region MarkdownLogCalendar start="^\%1l" end="\ze# Week" contains=MarkdownLogCalendarWeek,MarkdownLogCalendarWeekHead
syn match MarkdownLogCalendarWeekHead /\sCW$/ contained
syn match MarkdownLogCalendarWeek /\s\d\d$/ contained

syn region MarkdownLogEntry start="^[☰≻◉]\s" end="$" contains=MarkdownLogTime,MarkdownLogContent
syn match MarkdownLogTime /\s:\d\{4}:\s/
syn match MarkdownLogNote /^☰/
syn match MarkdownLogMeet /^≻/
syn match MarkdownLogWork /^◉/

au BufWinEnter,Colorscheme * hi! MarkdownLogNote guifg=#c4a7e7 " iris
au BufWinEnter,Colorscheme * hi! MarkdownLogMeet guifg=#f6c177 " gold
au BufWinEnter,Colorscheme * hi! MarkdownLogWork guifg=#eb6f92 " love
au BufWinEnter,Colorscheme * hi! MarkdownLogCalendar guifg=#44415a " highlight med
au BufWinEnter,Colorscheme * hi! MarkdownLogCalendarWeekHead guifg=#6e6a86 " highlight high
au BufWinEnter,Colorscheme * hi! MarkdownLogCalendarWeek guifg=#6e6a86 " highlight high
au BufWinEnter,Colorscheme * hi! MarkdownLogTime guifg=#6e6a86 " highlight high
au BufWinEnter,Colorscheme * hi! markdownH1 guifg=#eb6f92 " love
au BufWinEnter,Colorscheme * hi! markdownH2 guifg=#c4a7e7 " iris

