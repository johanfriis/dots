local M = {}

function M.get_colors()
    local colors = require('rose-pine').moon
    return colors
end

function M.get_colorscheme()
    return 'rose-pine-moon'
end

return M
